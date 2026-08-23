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
| ISO/IEC 25059:2023 | Extends the ORD's ISO/IEC 25010:2023 taxonomy — adds functional adaptability, robustness, user controllability, transparency, intervenability. Does not replace it. Second edition under member-body vote. |
| ISO/IEC/IEEE 29148:2018 | Unchanged for the PRD. The good-requirement characteristics hold; only the evidence satisfying *verifiable* changes. |
| ISO/IEC 22989:2022 | Vocabulary. Adopt its terms rather than coining local ones — record them via `/add-term`. |
| ISO/IEC 23894 | AI risk management. Feeds ORD § 9 and `/raid`. |
| ISO/IEC 5338 | AI system life-cycle processes. Feeds ORD § 5 and § 7. |
| EU AI Act — Regulation (EU) 2024/1689, as amended | Supplies requirement classes (Arts. 9–15, Annex IV), not document structure. **Application dates below are cited, not verified in this repo — see the stamp.** |
| ISO/IEC 42001:2023 | Organisational management system, above the document layer. Out of scope for this file. |
| ISO/IEC 5259 series | Data quality for ML. A data-as-subject schema is deferred per ADR-0003. |

### Regulatory dates — verification stamp

**Dates move; a rules file does not notice.** These are recorded once, here, with their provenance,
so no requirement document restates them and no author cites them believing they were checked today.

| Obligation | Date as recorded | Status |
|---|---|---|
| AI Act Art. 5 prohibitions, GPAI obligations, Art. 50 transparency duties | in force | cited |
| Annex III high-risk obligations | 2 December 2027 | cited — deferred from the original date by the amending regulation below |
| Annex I high-risk obligations | 2 August 2028 | cited — deferred as above |

- **Last verified:** 2026-08-21, in `../docs/research/requirements-for-ai-solutions.md` § *Current timing* —
  resolved from the repo root, i.e. the workspace directory **containing** this repo
  , not `docs/` inside it. That document is
  **workspace-local and not tracked in this repository**, as the `requirements-documents` pack is. A
  reader resolving the path against the repo root finds nothing; that is the path being ambiguous,
  not the evidence being absent.
- **Verified against a secondary source.** The research cites a law-firm briefing on Regulation (EU)
  2026/1744 (Digital Omnibus on AI, published 24 July 2026, in force 27 July 2026) for the deferral
  — competent, and not the primary text. **No date here has been checked against the consolidated
  text of Regulation (EU) 2024/1689 on EUR-Lex.**
- **Owner:** unassigned. Assign one before any document authored under this file makes a conformity
  claim.
- **Before citing a date in a conformity claim, verify it against EUR-Lex** — not against this
  table, not against the ADR, and not against the secondary briefing. Record the check by replacing
  *Last verified* above with the date, the person, and the primary source.
- **The requirement classes are not affected by this gap.** Arts. 9–15 and Annex IV supply the
  classes in the map above whatever the application dates turn out to be; it is only the deadlines
  that are unverified.

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
- Never cite an AI Act application date as verified against primary law on the strength of this
  file — the stamp above records a secondary source and an unassigned owner.
- Never record an evaluation set with no re-run trigger.
- Never name a model version in a requirement without a matching `MDL-NNN` row.
- Never treat go-live acceptance as final for a component whose behaviour is learned or generated.
- Never write "drift is monitored", "the model is explainable", or "human oversight is in place" —
  each is an unquantified adjective in disguise. Give the measure and the actor, or write `[TBD]`.
- Never apply this file to AI-assisted *authoring* of the solution — that is `ai-first-engineering`.
