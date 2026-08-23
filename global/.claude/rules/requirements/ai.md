# Requirements — AI Solutions

> Applies **in addition to** [language.md](language.md) and [tables.md](tables.md) whenever a
> delivered component's behaviour is learned or generated rather than specified. Neither sibling is
> relaxed here. Read the scope boundary in [README.md](README.md) first — these rules govern
> generated document content, not skill instruction prose.

## When this file applies

**Trigger test:** a delivered component whose output for a given input is not fully determined by
written logic — a trained model, an LLM call, a retrieval-augmented pipeline, an agent, or a
third-party AI service consumed as an API. One such component anywhere in scope triggers the file
for the requirements that touch it; deterministic requirements in the same document are unaffected.

**Not triggered by AI used to build the solution.** `ai-first-engineering` governs AI as the
*author* of code. This file governs AI as the *subject* of the requirement. The requirement subject
is always the delivered system, never the toolchain that produced it.

Per ADR-0003 there is **no separate AI requirements document**. Everything below lands in the
existing BRD, PRD and ORD, in the section the class map assigns.

## The Rule

**Non-determinism changes the evidence a requirement needs. It never changes the grammar it is
written in.**

The declarative end-state form, the modal ban, the "the system" ban and the vagueness ban all apply
unchanged. Probabilistic behaviour is the most plausible excuse yet available for writing `may` into
a criterion — which is exactly why it is refused here. **Variability belongs in the threshold, never
in the verb.**

## The evaluative criterion

A requirement over learned or generated behaviour is a declarative end state carrying four parts.
Missing any one of them, the statement is unfalsifiable at verification time.

| Part | Supplies | Never written as |
|---|---|---|
| **Behaviour** | the end state, stated so that variability is expected | "the output is correct" |
| **Threshold on a named set** | the scorer, the number that passes, and the `EVL-NNN` set it is measured on | "high quality", "a representative sample" |
| **Floor** | the worst *single case* tolerated on the scored scale, alongside the mean | omitted because the mean passes |
| **Review hook** | what happens to a case below threshold — who or what handles it | omitted because the mean passes |

**The floor is scalar. A categorical prohibition is a different obligation and does not live here.**
An output that is unacceptable *at any rate* — a leaked secret, a medical instruction from a
component not cleared to give one, a protected-attribute inference — is not a low score to be
averaged against. Scoring it at all implies a rate at which it passes. It is a **separate register
row** in ORD § 3.9.3 Prohibited Outputs — or § 3.3 Security where the prohibition is a disclosure
rather than a hazard, in one place and not both — stating the prohibited output, a tolerance of zero,
and its own verification method; the `EVL-NNN` row references that row's ID in `Prohibited outputs` and
restates no value. Conflating the two is how a prohibition becomes a percentage.

> ✗ `The model should rarely hallucinate`
> ✗ `Summarisation accuracy is acceptable under normal load`
> ✗ `Answer quality scores ≥ 4.0 of 5` *(no named set — unmeasurable at verification)*
> ✓ `Meeting-summary quality scores ≥ 4.0 of 5 mean on evaluation set EVL-004, with no individual case below 2.5 and an unsupported-claim rate below 3%. A case scoring below 2.5 is routed to human review before release.`

**A threshold measured on training data is not a threshold.** Every `EVL-NNN` set is held out from
whatever tuned the component.

**The ORD owns both registers; the PRD cites and never mints.** `EVL-NNN` and `MDL-NNN` are assigned
by `/write-ord` alone, exactly as `ORD-NNN` is — two skills allocating from one flat sequential
namespace with no coordination is how IDs collide, and `/write-reqs` authors the PRD *before* the
ORD, so a PRD minting its own would guarantee it. A PRD criterion needing a set it cannot yet name
writes **`[EVL-TBD — <what must be measured, and on what>]`**, and `/write-ord` resolves it to a real
ID when it builds the register — the same write-back the `Capability` and `Epic` columns already use
in [tables.md](tables.md). An unresolved `[EVL-TBD]` at the PRD gate is a visible hole, which is the
point; an invented `EVL-007` is not.

**Where no ORD is produced**, the PRD holds both registers itself and assigns the IDs — the rule
above prevents *concurrent* allocation, not allocation. Say so in the document rather than leaving a
reader to infer which skill owns the namespace.

**Where no evaluation set exists yet**, the `[TBD — source: "quoted vague statement"]` rule from
[language.md](language.md) applies unchanged. Never invent a threshold, a set size, or a scorer to
avoid writing TBD.

**The two TBD forms mark different holes; do not substitute one for the other.**

| Form | Means | Resolved by |
|---|---|---|
| `[TBD — source: "quoted vague statement"]` | the source never gave a threshold — there is nothing to measure yet | a stakeholder decision |
| `[EVL-TBD — <what must be measured, and on what>]` | the threshold is known, the **set** that proves it is not built or not yet numbered | `/write-ord`, writing the real `EVL-NNN` back |

Writing the first where the second is true hides a known measurement behind a stakeholder question
and it never gets built.

## Marking an AI-governed row

**Prefix `Requirement Description` with `[AI]`** on every ORD register row this file governs, and
prefix the `Acceptance Criterion` cell the same way on a PRD criteria row. The trigger is
per-component, so an ORD holds governed and ungoverned rows side by side and a finished register
otherwise gives a reviewer no way to tell which is which — this ruleset becomes uncheckable at
exactly the point someone tries to check it. The convention mirrors **[KPP]** in
[tables.md](tables.md) deliberately: same column, same bracket form, one thing to learn.

- **Where both apply, write `[KPP][AI]`** — in that order, always. KPP first because it is the
  older convention and the one a stakeholder reads for priority.
- **`[AI]` is not a priority and not a MoSCoW value.** It records which ruleset governs the row's
  form. A `[AI]` row is still `Must` / `Should` / `Could` / `Won't` like any other.
- **A row carrying `[AI]` and no `EVL-NNN` reference is incomplete** — that is precisely what the
  marker makes visible, and a reviewer is entitled to reject it on sight.

## Where AI requirement classes live

The class map. A row that does not appear here has no AI-specific home and follows the normal rules.

| Requirement class | Home | Origin |
|---|---|---|
| Risk classification decision | BRD | AI Act Art. 6 |
| Intended purpose | PRD § Scope boundary | AI Act Art. 11 / Annex IV |
| Prohibited uses | PRD § Out of Scope | AI Act Art. 11 |
| User-facing quality or accuracy outcome | PRD story criteria | 29148 |
| Functional adaptability | ORD § 3.8.2 Functional Adaptability | 25059 |
| Accuracy and fairness thresholds (operational) | ORD § 3.8.3 Accuracy and Fairness Thresholds | 25059, AI Act Art. 15 |
| Robustness — out-of-distribution and adversarial input | ORD § 3.2.5 Robustness | 25059, AI Act Art. 15 |
| User controllability and intervenability | ORD § 3.7.4 User Controllability and Intervenability | 25059 |
| Transparency, explainability, output labelling | ORD § 3.7.5 Transparency and Explainability | 25059, AI Act Arts. 13, 50 |
| Human oversight — who intervenes, when, with what authority | ORD § 3.7.4 and § 5 Support Model | AI Act Art. 14 |
| Record-keeping and inference logging | ORD § 3.6.3 Record-Keeping and Inference Logging, § 5.4 Monitoring | AI Act Art. 12 |
| Data governance, provenance, labelling method | ORD § 4.3 Regulatory and Compliance Constraints | AI Act Art. 10, ISO/IEC 5259 |
| Drift detection and re-verification cadence | ORD § 3.8.2, § 5.4 Monitoring, § 7 Service Level Requirements | ISO/IEC 5338 |
| Model and provider dependency | ORD § 9.3 Dependencies, keyed to `MDL-NNN` | — |
| Prompt-injection and model-specific attack surface | ORD § 3.3.7 Prompt Injection and Model Attack Surface | AI Act Art. 15 |
| Prohibited output — unacceptable at any rate, zero tolerance | ORD § 3.9.3 Prohibited Outputs, or § 3.3 Security where it is a disclosure | AI Act Art. 15 |
| Evaluation sets and model dependencies (registers) | ORD § 9.3 Dependencies, keyed to `EVL-NNN` / `MDL-NNN` | — |

**The ORD subsections named above are defined in** `skills/write-ord/REFERENCE.md` § *ISO/IEC
25059:2023 — AI Extension* and are scaffolded in its §3 template marked *(AI — 25059)*. They are
conditional on this file's trigger test: where it does not fire they do not apply, and are omitted
from the body *and* from the §3.10 Coverage Gaps table — an inapplicable subsection is not a gap.

**Where no PRD is produced**, intended purpose and prohibited uses are held in the ORD's scope
section rather than dropped. The class map assigns a *home*, not a document that must exist.

**Where the actor is load-bearing — human oversight, intervention authority, record-keeping — name
the actor and use the active voice**, per the second recorded deviation in
[language.md](language.md). "Oversight is provided" names nobody and binds nobody.

## Canonical schemas

Both are registers. A requirement row still carries its own value in its own sentence and
references the register by ID — the § View Tables rule in [tables.md](tables.md) applies, so a
threshold is never restated in two independently editable places.

### Evaluation set register

| ID | Evaluation set | Size | Held out from | Scorer | Threshold | Floor | Prohibited outputs | Re-run trigger | Owner |
|---|---|---|---|---|---|---|---|---|---|
| EVL-NNN | [named set] | [n cases] | [what it is held out from] | [deterministic check / embedding similarity / LLM-judge with its calibration set, statistic and minimum] | [pass value] | [worst single case tolerated] | [ORD-NNN row IDs, or —] | [what forces a re-run] | [role] |

- **`Scorer` names the method, not the intent.** An LLM-judge row states what it was calibrated
  against; an uncalibrated judge is a `[TBD]`, not a scorer.
- **"Calibrated" is an unquantified adjective unless it carries a number.** This file bans
  "explainable" and "monitored" for exactly this reason and takes no exemption for its own vocabulary.
  A judge-based `Scorer` cell names three things: the **human-annotated calibration subset**, the
  **agreement statistic** used against it, and the **value achieved with the minimum required** —
  for example *"LLM-judge, calibrated on 120 human-annotated cases, Krippendorff's α = 0.81 against
  two annotators, minimum 0.80"*. Krippendorff's own convention — α ≥ 0.800 to rely on a variable,
  0.667 ≤ α < 0.800 for tentative conclusions only — is a reasonable default where the project has
  not set its own; record the choice rather than assuming the reader shares it. A judge whose
  agreement is asserted but not measured is a `[TBD]`, the same as an uncalibrated one.
- **`Re-run trigger` is mandatory** — an evaluation with no trigger is a launch gate, not a
  requirement. At minimum: any model version change, any prompt change, any change to an upstream
  data source.
- **`Prohibited outputs` holds row IDs, never values.** It points at the ORD § 3.9 / § 3.3 rows
  carrying the categorical prohibitions this set is scored alongside, per the § View Tables rule in
  [tables.md](tables.md). `—` is a real answer meaning *considered, none apply* — it is not the same
  as leaving the cell blank, and the column exists so the question is asked rather than assumed.

### Model dependency

| ID | Component | Provider | Model / version | Pinned | Deprecation notice | Fallback behaviour | Re-evaluation trigger |
|---|---|---|---|---|---|---|---|
| MDL-NNN | [what depends on it] | [provider] | [model id and version] | Yes / No | [notice period, or "none contracted"] | [what happens when unavailable] | [EVL-NNN re-run] |

A model version named inside a requirement row without a matching `MDL-NNN` row is an
untracked dependency. `Pinned: No` with `Deprecation notice: none contracted` is a risk — raise it
via `/raid add risk` rather than leaving it in the table alone.

## Shelf life

A requirement over learned behaviour degrades with no change to the code — data drift, model
deprecation, a provider's silent update. **Acceptance at go-live is not final acceptance.**

- Every `EVL-NNN` row carries its re-run trigger, and the re-verification cadence is an ORD register
  row in its own right, not a note in the support model.
- A drift threshold is quantified like any other requirement, with its measure named
  (for example a population-stability index band), never as "drift is monitored".
- **Every drift or quality alert names its runbook.** An alert with no documented response is
  observability, not an operational requirement.

## The scenario triad for AI

The three values in [tables.md](tables.md) are unchanged — `Sunny Day`, `Rainy Day`, `Edge Case`.
For a generated-behaviour requirement they read as:

| Value | The component under |
|---|---|
| **Sunny Day** | In-distribution input, component available, confidence above threshold |
| **Rainy Day** | Component unavailable or timed out, confidence below threshold, refusal, fallback path taken |
| **Edge Case** | Out-of-distribution or adversarial input, prompt injection, unrepresented cohort, empty or maximum-length context |

A story whose criteria are all Sunny Day has been specified for the demo. For a generated-behaviour
component that warning is sharper than usual: the Sunny Day path is the one the vendor already
demonstrated.

## Standards of record

| Standard | Status here |
|---|---|
| ISO/IEC 25010:2023 | The ORD §3 taxonomy this file extends. Australian adoption: **AS/NZS ISO/IEC 25010:2025**. |
| ISO/IEC 25059:2023 | Extends the ORD's ISO/IEC 25010:2023 taxonomy — adds functional adaptability, robustness, user controllability, transparency, intervenability. Does not replace it. Second edition under member-body vote. Australian adoption: **AS ISO/IEC 25059:2024**. |
| ISO/IEC/IEEE 29148:2018 | Unchanged for the PRD. The good-requirement characteristics hold; only the evidence satisfying *verifiable* changes. |
| ISO/IEC 22989:2022 | Vocabulary. Adopt its terms rather than coining local ones — record them via `/add-term`. |
| ISO/IEC 23894 | AI risk management. Feeds ORD § 9 and `/raid`. |
| ISO/IEC 5338 | AI system life-cycle processes. Feeds ORD § 5 and § 7. |
| EU AI Act — Regulation (EU) 2024/1689, as amended by (EU) 2026/1744 | Supplies requirement classes (Arts. 9–15, Annex IV), not document structure. Application dates are in the stamp below, verified 2026-08-24. |
| ISO/IEC 42001:2023 | Organisational management system, above the document layer. Out of scope for this file. |
| ISO/IEC 5259 series | Data quality for ML. A data-as-subject schema is deferred per ADR-0003. |

### Regulatory dates — verification stamp

**Dates move; a rules file does not notice.** These are recorded once, here, with their provenance,
so no requirement document restates them and no author cites them believing they were checked today.

The research behind this file, `../docs/research/requirements-for-ai-solutions.md`, is
**deliberately not tracked in this repository.** The workspace `docs/` holds company-internal
material and is not published with the framework, as the `requirements-documents` pack is not. Its
findings are restated here and in ADR-0003, which are tracked; the source is not, by choice — a
reader resolving that path against the repo root is meant to find nothing.

| Obligation | Date as recorded | Status |
|---|---|---|
| AI Act Art. 5 prohibitions, GPAI obligations, Art. 50 transparency duties | in force | cited |
| Annex III high-risk obligations | 2 December 2027 | cited — deferred from the original date by the amending regulation below |
| Annex I high-risk obligations | 2 August 2028 | cited — deferred as above |

- **Last verified:** 2026-08-24, by **Glen Sanders**, against the European Commission's own
  announcement of the amending regulation entering into force —
  <https://digital-strategy.ec.europa.eu/en/news/ai-omnibus-enters-force> — which states the
  2 December 2027 and 2 August 2028 dates directly.
- **Amending instrument:** Regulation (EU) 2026/1744 (Digital Omnibus on AI), adopted 8 July 2026,
  published OJ 24 July 2026, in force 27 July 2026. CELEX `32026R1744`, ELI
  <https://eur-lex.europa.eu/eli/reg/2026/1744/oj/eng>. It amends Regulation (EU) 2024/1689 (the AI
  Act), ELI <https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng>.
- **What was not done:** the consolidated **Article 113** text was not read. EUR-Lex returned its
  Official Journal navigation page rather than the document on three URL forms, so the dates above
  rest on the Commission's announcement plus consistent independent legal analyses, not on the
  article itself. That is a strong chain and it is not the primary text. **Read Article 113 before
  certifying conformity**, and record it here.
- **Owner:** **Glen Sanders**, as maintainer of this ruleset. Re-verify on any amending regulation,
  and at minimum annually.
- **Deferral changes the deadline, not the content.** A register already carrying data governance,
  logging, human oversight and accuracy rows needs no retrofit in 2027; one that does not, does. The
  dates govern *when* evidence is demanded, never whether the classes above apply.

### Australian adoptions and instruments

Recorded because this pack is authored in an Australian context. **Cite the AS designation where one
exists** — it is the same text, and it is the one an Australian auditor asks for.

| Instrument | Status here |
|---|---|
| **AS/NZS ISO/IEC 25010:2025** | Identical adoption of ISO/IEC 25010:2023 — the taxonomy the ORD's §3 is keyed to. Cite this designation in an Australian document. |
| **AS ISO/IEC 25059:2024** | Australian adoption of ISO/IEC 25059:2023 — the AI extension this file applies. Cite alongside the ISO designation. |
| **AS ISO/IEC 42001:2023** | Identical adoption, February 2024. Organisational management system, above the document layer — out of scope for this file, as its ISO parent is. |
| ISO/IEC/IEEE 29148:2018 | **No Australian adoption identified.** Cite the ISO/IEC/IEEE designation. |
| **Voluntary AI Safety Standard (VAISS)** — DISR, 10 guardrails | **Voluntary. Binds nothing.** Useful as a checklist against the class map; never cite a guardrail as the authority for a requirement. |
| **Guidance for AI Adoption (GfAA)** — October 2025, six practices | Voluntary; supersedes VAISS in practice. Same treatment. |
| Proposed mandatory guardrails for high-risk AI, September 2024 | **Shelved.** Do not author against them. |
| **National AI Plan**, 2 December 2025 | Policy direction, not law: existing legislation and sector regulators, supported by voluntary guidance and the Australian AI Safety Institute. **There is no Australian AI Act.** |

**Watch item — an Australian AI standard to be legislated.** An Office of AI was established in the
Department of the Prime Minister and Cabinet, and on 15 July 2026 the Prime Minister announced an
intent to legislate an Australian AI standard — for consideration by National Cabinet in August 2026,
with legislation expected early 2027. Published scope centres on **large AI data centres** — energy,
water, and copyright protections for Australian creators — not on requirement classes for an AI
system generally. **None of it is law yet**, and nothing in this file's class map derives from it.
Re-check before the next document cycle; the owner named above owns this too.

**The practical consequence for an Australian project.** The binding classes in the map above come
from the **EU AI Act**, and apply only where a system falls within its scope. A purely domestic
Australian system currently has **no mandatory AI-specific requirement classes**: it is governed by
existing law — privacy, consumer, anti-discrimination, sector regulation — plus whatever the
organisation adopts voluntarily. Name which regime applies in the document rather than importing the
AI Act by default. The evaluative criterion, the evaluation-set discipline and the shelf-life rule in
this file are **engineering practice, not regulation**, and apply either way.

## Never

- Never create a separate AI requirements document — the classes above have homes (ADR-0003).
- Never let non-determinism justify a modal. `may`, `might`, `should`, `could` and `would` stay
  banned, and the excuse for reaching for them is stronger here than anywhere else.
- Never state a threshold without naming the evaluation set it is measured on.
- Never measure a threshold on data the component was tuned against.
- Never write a mean with no floor — an average that passes hides the case that harms someone.
- Never score a categorical prohibition — an output unacceptable at any rate is a zero-tolerance
  register row of its own, never a floor on a scale that implies a passing rate.
- Never mint an `EVL-NNN` or `MDL-NNN` outside the ORD where an ORD exists — write `[EVL-TBD — …]`
  and let `/write-ord` write it back.
- Never call a judge "calibrated" without naming the calibration set, the agreement statistic and
  the minimum required.
- Never leave an AI-governed row unmarked — `[AI]` is what makes this ruleset checkable by someone
  who was not in the room.
- Never cite an AI Act application date for a conformity certification without reading the
  consolidated Article 113 — the stamp above records exactly what was and was not checked.
- Never cite a VAISS or GfAA guardrail as the authority for a requirement. Both are voluntary; a
  requirement naming one as its source names no obligation.
- Never import the EU AI Act's classes into a purely domestic Australian system by default — name
  the regime that applies and why.
- Never cite an ISO designation alone where an AS adoption exists — an Australian auditor asks for
  the AS number.
- Never record an evaluation set with no re-run trigger.
- Never name a model version in a requirement without a matching `MDL-NNN` row.
- Never treat go-live acceptance as final for a component whose behaviour is learned or generated.
- Never write "drift is monitored", "the model is explainable", or "human oversight is in place" —
  each is an unquantified adjective in disguise. Give the measure and the actor, or write `[TBD]`.
- Never apply this file to AI-assisted *authoring* of the solution — that is `ai-first-engineering`.
