# Authoring Standards

The standards `/write-ac` cites, gathered into one document so the skill works where
there is no filesystem to read them from. Each part keeps the name of the file it came
from: a citation such as `tables.md` means the part below with that name.

- **`README.md`** — Requirements Rules
- **`language.md`** — Requirements Language
- **`tables.md`** — Requirements Tables
- **`ai.md`** — Requirements — AI Solutions
- **`reporting.md`** — Requirements — Reporting and Data

---

## `README.md`

Authoring standards for requirements documents — how a requirement is *worded* and how it is
*presented*. Consumed by `/write-prd`, `/write-ord`, `/write-reqs`, and `/write-ac`.

```
rules/requirements/
├── README.md      ← this file
├── language.md    ← voice, modality, banned constructions
├── tables.md      ← table-first presentation, canonical schemas, ID namespaces
├── ai.md          ← conditional: learned or generated behaviour (see trigger test)
└── reporting.md   ← conditional: a measure that is reported (see trigger test)
```

`language.md` and `tables.md` are unconditional — every requirements document obeys both.

`ai.md` and `reporting.md` are **conditional**: each applies on top of the unconditional two, and
neither relaxes either. They are independent — a change can fire both, one, or neither.

| File | Fires when | Adds |
|---|---|---|
| `ai.md` | a delivered component's behaviour is learned or generated rather than specified | the evaluative criterion, `EVL-NNN` / `MDL-NNN`, the ISO/IEC 25059 class map |
| `reporting.md` | the change creates, alters or retires a measure somebody reports | the measure definition, `DAT-NNN`, the ISO/IEC 25012 data-quality anchor |

See ADR-0003 for why AI requirements extend the pack rather than forming a fourth document;
`reporting.md` follows the same precedent rather than adding a reporting document.

### Why this is a separate rules category

`rules/common/` is the always-applied baseline for **code**. `rules/[lang]/` is activated
per-project via `/lang-rules`. Neither fits: these rules govern **documents**, and they apply
whenever a requirements document is authored regardless of the project's language or whether
any code exists yet.

This ruleset is not auto-loaded. The requirement skills cite it by path, per PRINCIPLE 6
(reference, don't duplicate). It exists so the sibling documents share one definition of a
requirement's form — neither `/write-prd` nor `/write-ord` can own it without the other
drifting, and `/write-reqs` is barred from owning templates.

### Scope boundary — read this first

These rules govern **generated document content only**.

They do **not** apply to the skills' own instruction prose. A skill instruction such as
"at least one KPP must be identified" is correct and stays. Applying the language rules to the
skill files themselves would strip the directives that make the skills work.

| Text | Governed? |
|---|---|
| A requirement, criterion, assumption or commitment written into a PRD/ORD/AC document | Yes |
| A skill's instructions to Claude, its rules, its failure-mode table | No |
| Template placeholder text and worked examples inside a template | Yes — examples teach the form |
| Narrative context sections (background, mission, operational scenarios) | Partially — see `language.md` § Narrative sections |

`ai.md` adds one boundary of its own: it governs AI as the **subject** of a requirement. AI as the
**author** of the solution is `ai-first-engineering`, which is not a requirements ruleset and is not
governed here.

### Enforcement

`/check-style` reads `~/.claude/knowledge/company/style-guide.md`, not this ruleset — a company
style guide may add to these rules but never relaxes them. Where the two conflict, the stricter
requirement wins and the conflict is flagged rather than silently resolved.


---

## `language.md`

> Governs the wording of requirements, acceptance criteria, and commitments in generated
> documents. Read the scope boundary in `README.md` first — these rules do **not**
> apply to skill instruction prose.

### The Principle

**Describe the delivered world as a fact, not the project's intentions about it.**

A requirement states how things *are* once the solution is in place. Written that way it is
either true or false at verification time, and there is no hedge to argue about.

| Instead of | Write |
|---|---|
| The system should respond within 3 seconds | Search results are returned within 3 seconds |
| We will encrypt data in transit | Data in transit is encrypted using TLS 1.3 |
| Users may be notified of despatch | Customer despatch notification is issued within 5 minutes |
| The service shall be available 99.9% of the time | Service availability is 99.9% per calendar month |

### Voice by Altitude

Two registers. Applying the wrong one at the wrong level is the most common error.

| Element | Form | Example |
|---|---|---|
| Capability / feature name | **Noun phrase** | `Customer despatch notification` |
| Requirement or story title | **Active, verb-first** | `Notify customer of despatch` |
| "I want" clause | **Active, verb-first**, solution-agnostic | `Notify the customer when despatch occurs` |
| Acceptance criterion | **Noun-first, passive, declarative** | `Despatch notification is issued within 5 minutes of consignment scan` |
| ORD requirement-table row | **Noun phrase** in `Requirement`; value in `Threshold` | `Despatch notification latency` / `≤ 5 min` |

Titles command. Criteria state. The criterion form is deliberate: leading with the noun and
using the passive leaves **no grammatical slot for a modal verb**, so the failure this ruleset
exists to prevent becomes hard to write rather than merely discouraged.

### Banned in Generated Requirements

**Modals — never appear in a requirement, criterion, or commitment:**
`could` · `should` · `would` · `may` · `might`

They make the statement unfalsifiable: a criterion that *may* be met cannot fail a test.

**`shall` — permitted but avoided.** It is not ambiguous, but the declarative present is
shorter and reads as a fact rather than an obligation. Prefer the rewrite; do not treat an
existing correct `shall` as a defect.

**Constructions — never:**
`allow me to` · `allows the user to` · `enables` · `is able to` · `can [verb]`

These describe a capability the solution grants rather than an outcome that is true. `can` is
the most common offender and the easiest to miss:

> ✗ `Then they can complete the purchase without re-entering card details`
> ✓ `Purchase completion is available to a returning customer without card re-entry`

**Never write "the system"** — or "the platform", "the application", "the solution". Name the
product, service, or component. Where no name exists yet, use the `[SYSTEM-NAME-TBD]`
placeholder the skill already defines, and resolve it before the document is approved.

### Demand, not design

**Quantify the business tolerance, not the engineering figure that satisfies it.**

A requirement can be fully quantified and testable — as ISO/IEC/IEEE 29148:2018 requires — without
presupposing a design. The discipline is one level down from the rule that a BRD never names a
solution.

| Business demand (belongs in the requirement) | Technical target (the design response, downstream) |
|---|---|
| An agent retrieves a customer's account without the customer noticing a wait | Sub-200ms API response at the 99th percentile |
| Service is restorable within one business day; beyond that, obligation X is breached at cost Y | RTO 4h, active-active across two zones |
| No more than one working day of transactions is lost in any failure | RPO 1h |
| A field technician completes a job through a 30-minute connectivity gap | Offline cache with conflict resolution on reconnect |

Every left-hand statement is quantified, testable and traceable to a business source — a contract, a
regulatory obligation, an incident cost, a named stakeholder. **None requires an architect to
write.** That is what makes a requirements document producible by a business-side role.

**Where a document states a technical target, it pre-empts the review it exists to inform.** The
figure is asserted rather than derived, and the design review becomes ratification of a number an
analyst chose. Supply the demand; let the design response supply the target.

**This is not a ban on numbers.** A tolerance without a number is a vagueness defect under the next
section. The test is not *is there a figure* but *whose figure is it* — the business's tolerance, or
the engineer's answer to it.

### Vagueness

Unquantified adjectives are not requirements: `fast`, `reliable`, `intuitive`, `robust`,
`scalable`, `secure`, `user-friendly`. Either give a threshold and a measurement method, or
write `[TBD — source: "quoted vague statement"]` and leave the gap visible. Never quantify by
invention.

Quantification alone is **not** sufficient — "The system should respond within 3 seconds" is
quantified and still fails this ruleset. Both the number and the form are required.

### Narrative Sections

Background, mission context, operational scenarios and day-in-the-life narratives are prose by
design and are exempt from the noun-first criterion form. They remain subject to the modal ban
and the "the system" ban, and they must never introduce a commitment that does not also appear
as a row (see `tables.md`).

### Recorded Deviations from ISO/IEC/IEEE 29148:2018

`/write-prd` cites 29148. This ruleset deviates from it twice, deliberately:

1. **Declarative present is preferred over `shall`.** 29148 makes `shall` the canonical binding
   verb. We prefer the end-state form because it is shorter and verifiable as a statement of
   fact. `shall` remains valid, so this is a preference, not a conflict.

   **The same deviation applies to the INCOSE *Guide to Writing Requirements*,** which is more
   prescriptive than the ISO text on this point and is the practitioner authority most likely to be
   cited against a document authored under these rules. Recording the deviation once, against both
   sources, is deliberate: a deviation noted against 29148 alone silently extends to INCOSE, which
   is how a documented choice becomes an apparent defect in review.
2. **Passive voice is mandated for acceptance criteria.** 29148 recommends active voice on the
   grounds that passive hides the actor. Accepted and mitigated: where the actor is
   load-bearing — authorisation, non-repudiation, audit, and anything in ORD §3.3 Security —
   name the actor explicitly and use the active voice. Elsewhere the passive is what makes
   noun-first possible once "the system" is banned.

Neither deviation is silent: any document claiming 29148 conformance cites this file.

**Not aligned to ASD-STE100.** Simplified Technical English mandates active voice and the
imperative, and governs technical *documentation* (procedures, manuals), not requirements.
Downstream operational artefacts — runbooks, operator and field procedures — may adopt STE
independently; requirements documents do not.

### Never

- Never use `could`, `should`, `would`, `may`, or `might` in a requirement, criterion, or commitment.
- Never state a technical target where a business tolerance belongs — no RTO, RPO, latency figure,
  availability percentage, instance count or protocol choice in a demand-side requirement.
- Never coin a term where ISO/IEC/IEEE 24765 (systems and software vocabulary) or, for AI,
  ISO/IEC 22989:2022 supplies one. Record the adopted term in the project glossary.
- Never write `enables`, `is able to`, `allows … to`, or `can [verb]` in a criterion.
- Never refer to "the system", "the platform", "the application", or "the solution".
- Never treat quantification as sufficient — a hedged number is still a hedge.
- Never invent a threshold to avoid writing `[TBD]`.
- Never apply these rules to the skills' own instruction prose (see `README.md`).


---

## `tables.md`

> Governs how requirements are *presented* in generated documents. Pairs with
> `language.md`, which governs how they are worded.

### The Rule

**Every binding statement is a row in a table with a stable ID. Prose carries narrative only.**

A statement is **binding** if someone could later be held to it. The test: *could this be
cited in a review, an audit, an SLA dispute, or an acceptance test?* If yes, it is a row.

This is deliberately narrower than "tabularise everything". Prose sections earn their place and
are made worse by tabulation — background, mission context, system overview, and day-in-the-life
operational scenarios stay as prose. What they must never do is introduce a commitment that does
not also appear as a row somewhere.

### Canonical Schemas

Use these exactly. A document that invents a column set drifts from its sibling, which is the
failure this file exists to prevent.

#### Requirement register — the demand-side ORD

Every operational requirement, in every section. The subsection heading supplies the ISO/IEC 25010
characteristic, so there is no characteristic column.

| ORD# | Ver | Requirement Title | Business Tolerance | KPP | MoSCoW | Status | Owner | Source |
|---|---|---|---|---|---|---|---|---|
| ORD-NNN | 1.0 | [active, verb-first] | [declarative end state, carrying its own quantified value] | [KPP] or blank | Must | Committed | [named business owner] | [contract, obligation, incident record, or BU/Function/Name] |

**Column-name equivalence.** The requirements-documents pack writes the first column `Ref` and uses
sentence case (`Requirement title`, `Business tolerance`). They are the same columns; `ORD#` is used
here for consistency with `PRD#` and `BRD#` elsewhere in this file. `MoSCoW` is an extension the
pack does not require — see below.

**The register states business demand, never the technical target that satisfies it.** *"Service is
restorable within one business day, beyond which obligation X is breached"* is a requirement;
*"RTO 4h"* is the design response to it. See `language.md` § *Demand, not design*.

- **`Requirement Title` is active and verb-first** — `Restore service within one business day` —
  while `Business Tolerance` is noun-first and passive. That split is the existing rule in
  `language.md` § *Voice by Altitude*, applied at one altitude: titles command,
  criteria state. It is not a summary of the tolerance and never carries a value of its own.
- **`Business Tolerance` carries its own quantified value.** No separate threshold column — under
  `language.md` the requirement is a declarative end state, so the number is part of
  the sentence. Prefix **[AI]** where `ai.md` governs the row.
- **`KPP` is a column, not a prefix.** A KPP carries **threshold** (minimum acceptable) and
  **objective** (desired) as two labelled values inside `Business Tolerance`; collapsing them to one
  figure is how KPP intent is lost downstream. `[AI]` remains a prefix — it records which ruleset
  governs the row's form, which is not a property a column should imply is severity.
- **`Status` is `Committed` / `Provisional` / `Assumed`** — the maturity of the demand statement, not
  of a technical threshold. An `Assumed` row without a named owner and a confirm-by date in the
  assumption register is an invented number, not an assumption.
- **`Owner` is the named business owner of the tolerance.** Not the delivery team and not the
  operating team — both are response-side and neither is knowable at ORD time.
- **`Ver` is the requirement's own version**, not the document's. It rises when the tolerance
  changes after first issue, and it is what makes inline provenance work: a proposed acceptance
  criterion carries `[ORD-003 · v1.0 · Provisional · owner: … · confirm by …]` so the criterion's
  standing travels with it to whoever writes the Capability AC. Without it a downstream reader
  cannot tell an agreed tolerance from a revised one.
- **Traceability is not a register column.** The up-link — the `OBJ-NNN` objective and the BRD
  objective it serves via its business requirement — lives once, in Appendix A. Carrying it in both
  places is the restatement the § *View Tables* rule forbids. A row tracing only as far as a `BR-N`
  has no funded outcome behind it, which is what Appendix A's `via` makes visible.
- **`Source` is the evidence, not the speaker alone.** A contract clause, a regulatory obligation, an
  incident record or an `ASM-NNN`. Where the only source is a stakeholder, name Business Unit,
  Function and Name.
- **There is no `Verification` column.** The measurement *population* belongs inside the tolerance
  sentence; the *instrument* that measures it is the design response, recorded at Appendix D when
  the SOAP is issued. A demand-side ORD that names its own instrument has pre-empted the review it
  exists to inform.

**MoSCoW, `KPP` and `Status` are three orthogonal axes and all three are kept.** A KPP is a
business-failure threshold; a Must is required for this release; a Status is how well evidenced the
statement is. Most KPPs are Musts; most Musts are not KPPs; a KPP may sit at any status, and one at
`Assumed` is the single item that warrants escalation.

**`Should` and `Could` as MoSCoW values are not a `language.md` violation.** That rule bans hedging
verbs inside requirement *text*; a controlled enum in a priority column is unambiguous. Do not
"correct" it. **MoSCoW is DSDM, and KPP is US DoD JCIDS** — neither is ISO-backed. Both are retained
as house convention; neither is cited as a standards obligation.

**Delivery Agent, Operational Owner, Timing and Verification are deliberately absent.** Each names
something the demand side does not know and cannot commit: who will build it, who will run it, when
it will be scheduled, and what instrument will prove it. Timing lives at the objective
(`OBJ-NNN` § *Target Date*), which the requirement inherits through Appendix A. Traceability and the
written-back downstream links both live in Appendix A, not in the register.

**`MoSCoW` is an extension to the demand-side standard.** The standard does not require it; these
rules keep it because `/write-ac` gates AC altitude on it. It is business prioritisation, so it sits
on the demand side legitimately — but an ORD authored to the pack alone carrying no `MoSCoW` column
is conforming, not defective.

#### Operational objective

The outcome layer between a BRD objective and an operational requirement. Every register row traces
to one.

| ID | Objective | Baseline | Target | Target Date | Traces to |
|---|---|---|---|---|---|
| OBJ-NNN | [operational outcome, never the solution] | [current measurable position] | [required outcome] | [date or milestone] | [BO-N via BR-N] · [ORD-NNN, …] |

`Baseline`, `Target` and `Target Date` are measures under ISO/IEC 25022 / 25023. Where any of the
three is unavailable, write `[TBD — source: "quoted vague statement"]` and leave the gap visible.
**Never invent a baseline** — an objective whose baseline is guessed cannot show improvement.

#### Scenario

Requirement-level scenarios and the consolidated scenario catalogue are **one table**, keyed by
`ORD#`. Building a second catalogue would restate every row.

| ID | ORD# | Scenario | Outcome | Condition | Expected end state |
|---|---|---|---|---|---|
| SCN-NNN | ORD-NNN | Sunny Day | Favourable | [in-distribution, everything available] | [declarative end state] |
| SCN-NNN | ORD-NNN | Sunny Day | Adverse | [processing succeeds, result is unfavourable] | [declarative end state] |
| SCN-NNN | ORD-NNN | Rainy Day | — | [dependency down, data unavailable, retrieval failed] | [declarative end state] |
| SCN-NNN | ORD-NNN | Edge Case | — | [empty, maximum, expired, first, last] | [declarative end state] |

**`Scenario` and `Outcome` are two axes, not one.** `Scenario` is the condition the *capability* is
put through — the three values in this file, unchanged. `Outcome` is whether the *subject being
measured* passes or fails, and it applies only on a Sunny Day: a determination that runs correctly
and returns bad news is not a capability failure. That is why a fourth `Scenario` value was not
added — it would conflate the two axes.

- **`Outcome` is `Favourable` / `Adverse`, and `—` where the axis does not apply.** A Rainy Day has
  no outcome because nothing was determined.
- **A determination, measurement or eligibility requirement carrying only a Favourable Sunny Day row
  is incomplete.** What must be true when the answer is unfavourable is a separate obligation, and
  it is the one most often left unstated.
- Each row stays a declarative statement under `language.md`. A Rainy Day row states
  what *is* true when the dependency fails, never what might happen.
- A story or requirement whose scenarios are all `Sunny Day` has been specified for the demo, not
  for production.

#### Business rule

Where classification, eligibility, calculation or reporting logic exists. **Business rules are
functional content**; an ORD carrying them is a declared deviation from its own scope, taken only
where no functional requirements document is produced in the chain — see `README.md`
§ *Scope boundary*. Say so in the document rather than letting the ORD absorb functional content
silently.

| ID | Rule Group | Required Decision | Status | Owner | Effective Date | Affects |
|---|---|---|---|---|---|---|
| BRL-NNN | Classification / Inclusion / Exclusion / Calculation / Exception / Reconciliation / Restatement | [the business decision the rule makes] | Confirmed / Provisional / Unresolved | [named, or TBD with confirm-by] | [where supplied] | [ORD-NNN, …] |

- **`Required Decision` states the decision, not the logic.** Follow OMG **DMN**'s separation:
  the decision is what must be determined; the decision logic is how. An ORD carries the first.
- **This register records business policy, never implementation design.**
- An `Unresolved` rule affecting a KPP-bearing requirement is raised via `/raid add decision`.

#### Impact register

What the change touches and who owns it. Identification and accountability — never target state.

| ID | Impact | Kind | Owner | Referred |
|---|---|---|---|---|
| IMP-NNN | [named L4 workflow or system in the current estate] | Process / System | [named owner] | [REF-NNN or —] |

Naming the as-is estate is identification; naming the to-be estate is design. A row says what is
touched and who owns it, and says nothing about what happens to it. **Where tier numbers are cited,
name the scheme they belong to** — an unqualified "L4" resolves differently in APQC, eTOM and a
house scheme.

#### Referred requirement

Content raised during elicitation that this document will not deliver. No row is classified against
a 25010 characteristic and no row becomes a requirement of this document.

| ID | Requirement | Raised by | Kind | Related impact | Resolver group | Referred to | Date | Status |
|---|---|---|---|---|---|---|---|---|
| REF-NNN | [what was raised] | [name] | Functional / Wrong resolver / Out of scope | [IMP-NNN] | [group, or **None in chain**] | [named recipient] | [date] | Referred / Accepted / **Referred, not accepted** |

An omitted requirement is indistinguishable from one nobody had; a referred requirement with a named
recipient is a handoff. **`Resolver group: None in chain` is a real answer** and the row stays open —
it is the visible form of a gap in the delivery chain, not a defect in the document.

#### PRD story criteria

A PRD story is deliberately narrative — "As a … I want … so that …" carries intent and the business
outcome, which a register row cannot. Its **acceptance criteria** are rows:

| ID | Acceptance Criterion | Scenario |
|---|---|---|
| PRD-NNN.N | [declarative statement of what is true once delivered] | Sunny Day / Rainy Day / Edge Case |

- Criterion IDs are `PRD-NNN.N` within their story, so `/write-ac` maps each `AC-NNN` to a precise
  criterion rather than a whole story.
- A criterion over learned or generated behaviour is prefixed **[AI]** in the `Acceptance Criterion`
  cell and follows `ai.md` as well as this file.
- The story carries a `MoSCoW` priority; `/write-ac` gates altitude on it exactly as it does for
  ORD register rows.
- **`Scenario` names the weather the requirement is being put through**, not a category of criterion.
  The three values are the same requirement examined under three conditions, which is why the column
  is `Scenario` and not `Type` — a reader who sees `Type` asks what kind of criterion this is, and
  the answer is always "an acceptance criterion".

| Value | The requirement under | Answers |
|---|---|---|
| **Sunny Day** | Everything available and behaving | What is true when it works |
| **Rainy Day** | Something failing — dependency down, timeout, refusal | What is true when it breaks |
| **Edge Case** | A valid but boundary condition — empty, maximum, expired, first, last | What is true at the limits |

- `Scenario` makes the Sunny-Day-only coverage warning mechanically checkable: a story whose criteria
  are all `Sunny Day` has been specified for the demo, not for production.
- **These are labels for the condition, not a licence to hedge.** Each row stays a declarative
  statement under `language.md` — a Rainy Day criterion states what *is* true when the
  dependency fails, never what *might* happen.
- **A determination or eligibility story carries two Sunny Day criteria** — one where the answer is
  favourable and one where it is adverse. The capability succeeding and returning bad news is not a
  Rainy Day, and stating only the favourable case leaves the larger obligation unwritten. See
  § *Scenario* above for the `Outcome` axis; a PRD story may carry the column or say it in the
  criterion, but it states both cases either way.

#### Statements that carry no ID

Two kinds of binding row are deliberately ID-less, because nothing ever traces *to* them:

- **Exclusions** (PRD § Out of Scope) — cited in scope disputes, never referenced by another row.
- **Coverage gaps** (ORD § 3.10) — a record of absence; the ID would belong to a requirement that
  does not exist.

Everything else that binds carries an ID. Do not extend this list to avoid assigning one.

#### Interface detail

Per-interface technical attributes, keyed to a register row by `ORD#`. Specification, not
commitment — the binding statement is the register row, so this carries no priority or timing.

| ORD# | Integrated System | Interface Type | Protocol | Data Exchanged | Direction | Failure Behavior |
|---|---|---|---|---|---|---|

#### Assumption

Carries forward the table `/idea` already produces, so an assumption tracked at idea stage keeps
its identity and lifecycle into the requirements documents rather than collapsing back to prose.

| ID | Assumption | Status | If false | Owner | Confirm by |
|---|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [named role] | [date] |

`If false` is mandatory — an assumption with no stated consequence is a note, not an assumption.

**`Owner` and `Confirm by` are mandatory wherever a register row cites the assumption as its
`Source`.** A requirement at `Status: Assumed` resting on an assumption with no named owner and no
date is an invented number, and it is the largest audit exposure a requirements document carries.
ISO/IEC/IEEE 29148:2018 requires traceability, not finality: a TBD with an owner and a date
conforms; a silent gap does not.

**Escalation:** The RAID log is Risks, Actions, Issues, Decisions — it has **no Assumptions
quadrant**. A falsified assumption therefore has no home in RAID and must be raised as a risk:
set `Status: Falsified`, run `/raid add risk`, and record the `R-NNN` in the `If false` cell.

#### Dependency

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

### ID Namespaces

Authorised prefixes. See ADR-0001 for the requirement prefixes and their extension.

| Prefix | Owns | Assigned by |
|---|---|---|
| `BO-N` | Business objectives | `/write-brd` |
| `BR-N` | Business requirements | `/write-brd` |
| `PRD-NNN` | Functional requirements / user stories | `/write-prd` |
| `CON-NNN` | Solution constraints — demand-side givens (regulatory, contractual, mandated integration) | `/write-prd` |
| `ORD-NNN` | Operational requirements | `/write-ord` |
| `AC-NNN` | Acceptance criteria | `/write-ac` |
| `OBJ-NNN` | Operational objectives — the outcome layer every ORD row traces to | `/write-ord` |
| `BRL-NNN` | Business rules — conditional, see § *Business rule* | `/write-ord` (or `/write-prd` where a PRD is produced) |
| `SCN-NNN` | Scenarios — requirement-level and catalogue, one namespace | `/write-ord` |
| `IMP-NNN` | Impacts — workflows and systems touched, with named owners | `/write-ord` |
| `REF-NNN` | Referred requirements — raised here, delivered elsewhere | `/write-ord` |
| `DAT-NNN` | Data elements — conditional, schema in `reporting.md` | `/write-ord` |
| `ASM-NNN` | Assumptions | whichever document records it |
| `DEP-NNN` | Dependencies | whichever document records it |
| `EVL-NNN` | Evaluation sets — schema in `ai.md` | `/write-ord` (the PRD cites, never mints — see below) |
| `MDL-NNN` | Model / provider dependencies — schema in `ai.md` | `/write-ord` (as above) |

`EVL-NNN` and `MDL-NNN` were added by ADR-0003 and apply only where `ai.md` is triggered.
**Both have exactly one assigning skill, like every other prefix here.** `/write-reqs` authors the
PRD before the ORD, so a PRD needing a set that does not exist yet writes `[EVL-TBD — <what must be
measured>]` and `/write-ord` writes the real ID back — the same mechanism as `Capability` and `Epic`.
Where no ORD is produced at all, the PRD holds the registers and assigns the IDs, and says so.

All are flat and sequential in order of first appearance, never encode a theme or characteristic,
and are never reused once retired. `BO-N` and `BR-N` are single-digit-sequential per BRD, matching
the form `/write-brd` emits — do not re-pad them to three digits.

**Do not use single-letter prefixes.** `/raid` owns `R-`, `A-`, `I-`, `D-` for Risks, Actions,
Issues and Decisions — `A-NNN` for assumptions would collide with Actions.

### Coverage Gaps — the collapse rule

A gap must stay visible, but a stub table per absent subsection buries the document. A
requirements document authored from thin source material can easily have more empty tables than
populated ones.

**Do not scaffold an empty table per absent subsection.** Instead:

- A subsection with **at least one** requirement gets its table, populated.
- A sub-characteristic with **no** requirement is omitted from the body entirely, and listed as one
  row in a single **Coverage Gaps** table at the end of the section.

**The collapse applies at sub-characteristic level only. All nine ISO/IEC 25010:2023 characteristics
appear in every ORD, without exception** — §3.1 through §3.9, each present even where it carries
nothing. A characteristic with nothing to state carries an explicit statement of that fact and its
status, never an omission. The two rules are not in tension: a characteristic is a heading a
reviewer checks for, and its absence is invisible; a sub-characteristic is a table, and thirty empty
ones bury the document.

| Absent subsection | Reason | Action |
|---|---|---|
| [e.g. 3.5.3 Replaceability] | No source material | Stakeholder workshop |

A requirement known to exist but unquantified is **not** a coverage gap — it is a populated row
carrying `[TBD — source: "quoted vague statement"]`.

### View Tables

Where a commitment is genuinely needed in two places — an SLA summary restating availability, an
incident-response table restating recovery targets — the second occurrence is a **view**, not a
second source of truth.

A view table restates the `ID` and the agreed value by reference and introduces **no new
numbers**. Head it explicitly:

> *View of Section 3. Values are authoritative in the referenced rows; this table adds no new commitments.*

Two tables carrying the same commitment at independently editable values is the defect this
prevents.

### Never

- Never add a fourth `Scenario` value. A capability that runs correctly and returns an unfavourable
  answer is a Sunny Day with `Outcome: Adverse` — condition and outcome are two axes, and collapsing
  them into one column is what a fourth value would do.
- Never leave a determination, measurement or eligibility requirement with only a Favourable Sunny
  Day scenario. What is true when the answer is adverse is a separate obligation.
- Never put `Delivery Agent`, `Operational Owner`, `Timing` or `Verification` in the ORD register —
  each is response-side, and stating one pre-empts the design review the document exists to inform.
- Never state a technical target where a business tolerance belongs (see `language.md`).
- Never collapse a KPP's threshold and objective into a single figure.
- Never carry an `Assumed` row whose assumption has no named owner and no confirm-by date.
- Never omit one of the nine ISO/IEC 25010 characteristics from an ORD — collapse sub-characteristics
  to the Coverage Gaps table, never the characteristic itself.
- Never let an ORD absorb business rules without declaring the deviation and naming why no functional
  requirements document holds them.
- Never write `Happy path`, `Happy Path`, `Error`, `Error Case` or `Edge` as a scenario value, and
  never head the column `Type`. The three values are `Sunny Day`, `Rainy Day` and `Edge Case`, and
  the column is `Scenario` — written exactly so, capitalised so, in every document and in every
  sentence of prose that names them. These are the words a stakeholder reads aloud; reverting one
  of them mid-document is the failure this rule exists to prevent.
- Never write a binding statement as free-text prose, in any section.
- Never give a table row a commitment without a stable ID.
- Never invent a column set where a canonical schema exists.
- Never restate a value in a second table — reference the ID and mark the table as a view.
- Never scaffold an empty table per absent subsection — use the Coverage Gaps table.
- Never use a single-letter ID prefix (collides with `/raid`).
- Never mint an ID from a prefix this table assigns to a different skill — write the `[TBD]` form and
  let the owning skill write it back.
- Never silently drop a gap to keep a document looking complete.


---

## `ai.md`

> Applies **in addition to** `language.md` and `tables.md` whenever a
> delivered component's behaviour is learned or generated rather than specified. Neither sibling is
> relaxed here. Read the scope boundary in `README.md` first — these rules govern
> generated document content, not skill instruction prose.

### When this file applies

**Trigger test:** a delivered component whose output for a given input is not fully determined by
written logic — a trained model, an LLM call, a retrieval-augmented pipeline, an agent, or a
third-party AI service consumed as an API. One such component anywhere in scope triggers the file
for the requirements that touch it; deterministic requirements in the same document are unaffected.

**Not triggered by AI used to build the solution.** `ai-first-engineering` governs AI as the
*author* of code. This file governs AI as the *subject* of the requirement. The requirement subject
is always the delivered system, never the toolchain that produced it.

Per ADR-0003 there is **no separate AI requirements document**. Everything below lands in the
existing BRD, PRD and ORD, in the section the class map assigns.

### The Rule

**Non-determinism changes the evidence a requirement needs. It never changes the grammar it is
written in.**

The declarative end-state form, the modal ban, the "the system" ban and the vagueness ban all apply
unchanged. Probabilistic behaviour is the most plausible excuse yet available for writing `may` into
a criterion — which is exactly why it is refused here. **Variability belongs in the threshold, never
in the verb.**

### The evaluative criterion

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
in `tables.md`. An unresolved `[EVL-TBD]` at the PRD gate is a visible hole, which is the
point; an invented `EVL-007` is not.

**Where no ORD is produced**, the PRD holds both registers itself and assigns the IDs — the rule
above prevents *concurrent* allocation, not allocation. Say so in the document rather than leaving a
reader to infer which skill owns the namespace.

**Where no evaluation set exists yet**, the `[TBD — source: "quoted vague statement"]` rule from
`language.md` applies unchanged. Never invent a threshold, a set size, or a scorer to
avoid writing TBD.

**The two TBD forms mark different holes; do not substitute one for the other.**

| Form | Means | Resolved by |
|---|---|---|
| `[TBD — source: "quoted vague statement"]` | the source never gave a threshold — there is nothing to measure yet | a stakeholder decision |
| `[EVL-TBD — <what must be measured, and on what>]` | the threshold is known, the **set** that proves it is not built or not yet numbered | `/write-ord`, writing the real `EVL-NNN` back |

Writing the first where the second is true hides a known measurement behind a stakeholder question
and it never gets built.

### Marking an AI-governed row

**Prefix `Business Tolerance` with `[AI]`** on every ORD register row this file governs, and
prefix the `Acceptance Criterion` cell the same way on a PRD criteria row. The trigger is
per-component, so an ORD holds governed and ungoverned rows side by side and a finished register
otherwise gives a reviewer no way to tell which is which — this ruleset becomes uncheckable at
exactly the point someone tries to check it.

- **`[AI]` stays a prefix; `KPP` is a column.** The two were once both prefixes, written
  `[KPP][AI]`. Under the demand-side register in `tables.md`, `KPP` has its own column
  because a KPP carries threshold and objective as two labelled values and a prefix cannot hold
  them. `[AI]` remains a prefix deliberately: it records which *ruleset governs the row's form*,
  which is not a property a column should imply is severity. **A row can be both** — the `KPP`
  column reads `[KPP]` and the tolerance begins `[AI]`.
- **An ORD authored before that change carries `[KPP][AI]` inline.** Read it as the same marking;
  do not rewrite the source document.
- **`[AI]` is not a priority and not a MoSCoW value.** It records which ruleset governs the row's
  form. A `[AI]` row is still `Must` / `Should` / `Could` / `Won't` like any other.
- **A row carrying `[AI]` and no `EVL-NNN` reference is incomplete** — that is precisely what the
  marker makes visible, and a reviewer is entitled to reject it on sight.

### Where AI requirement classes live

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
`language.md`. "Oversight is provided" names nobody and binds nobody.

### Canonical schemas

Both are registers. A requirement row still carries its own value in its own sentence and
references the register by ID — the § View Tables rule in `tables.md` applies, so a
threshold is never restated in two independently editable places.

#### Evaluation set register

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
  `tables.md`. `—` is a real answer meaning *considered, none apply* — it is not the same
  as leaving the cell blank, and the column exists so the question is asked rather than assumed.

#### Model dependency

| ID | Component | Provider | Model / version | Pinned | Deprecation notice | Fallback behaviour | Re-evaluation trigger |
|---|---|---|---|---|---|---|---|
| MDL-NNN | [what depends on it] | [provider] | [model id and version] | Yes / No | [notice period, or "none contracted"] | [what happens when unavailable] | [EVL-NNN re-run] |

A model version named inside a requirement row without a matching `MDL-NNN` row is an
untracked dependency. `Pinned: No` with `Deprecation notice: none contracted` is a risk — raise it
via `/raid add risk` rather than leaving it in the table alone.

### Shelf life

A requirement over learned behaviour degrades with no change to the code — data drift, model
deprecation, a provider's silent update. **Acceptance at go-live is not final acceptance.**

- Every `EVL-NNN` row carries its re-run trigger, and the re-verification cadence is an ORD register
  row in its own right, not a note in the support model.
- A drift threshold is quantified like any other requirement, with its measure named
  (for example a population-stability index band), never as "drift is monitored".
- **Every drift or quality alert names its runbook.** An alert with no documented response is
  observability, not an operational requirement.

### The scenario triad for AI

The three values in `tables.md` are unchanged — `Sunny Day`, `Rainy Day`, `Edge Case`.
For a generated-behaviour requirement they read as:

| Value | The component under |
|---|---|
| **Sunny Day** | In-distribution input, component available, confidence above threshold |
| **Rainy Day** | Component unavailable or timed out, confidence below threshold, refusal, fallback path taken |
| **Edge Case** | Out-of-distribution or adversarial input, prompt injection, unrepresented cohort, empty or maximum-length context |

A story whose criteria are all Sunny Day has been specified for the demo. For a generated-behaviour
component that warning is sharper than usual: the Sunny Day path is the one the vendor already
demonstrated.

### Standards of record

| Standard | Status here |
|---|---|
| ISO/IEC 25010:2023 | The ORD §3 taxonomy this file extends. Australian adoption: **AS/NZS ISO/IEC 25010:2025**. |
| ISO/IEC 25059:2023 | Extends the ORD's ISO/IEC 25010:2023 taxonomy — adds functional adaptability, robustness, user controllability, transparency, intervenability. Does not replace it. Second edition under member-body vote. Australian adoption: **AS ISO/IEC 25059:2024**. |
| ISO/IEC/IEEE 29148:2018 | Unchanged for the PRD. The good-requirement characteristics hold; only the evidence satisfying *verifiable* changes. |
| ISO/IEC 22989:2022 | Vocabulary. Adopt its terms rather than coining local ones — record them in the project glossary. |
| ISO/IEC 23894 | AI risk management. Feeds ORD § 9 and `/raid`. |
| ISO/IEC 5338 | AI system life-cycle processes. Feeds ORD § 5 and § 7. |
| EU AI Act — Regulation (EU) 2024/1689, as amended by (EU) 2026/1744 | Supplies requirement classes (Arts. 9–15, Annex IV), not document structure. Application dates are in the stamp below, verified 2026-08-24. |
| ISO/IEC 42001:2023 | Organisational management system, above the document layer. Out of scope for this file. |
| ISO/IEC 5259 series | Data quality for ML. A data-as-subject schema is deferred per ADR-0003. |

#### Regulatory dates — verification stamp

**Dates move; a rules file does not notice.** These are recorded once, here, with their provenance,
so no requirement document restates them and no author cites them believing they were checked today.

The research behind this file is **deliberately not published with these rules.** The workspace
`docs/` holds company-internal material and is not published with the framework, as the
`requirements-documents` pack is not. Its findings are restated here and in ADR-0003, which are
tracked; the source is not, by choice.

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

#### Australian adoptions and instruments

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

### Never

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
- Never move `[AI]` into the `KPP` column, and never collapse the two markings into one — they
  record different things: severity, and which ruleset governs the row's form.
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


---

## `reporting.md`

> Applies **in addition to** `language.md` and `tables.md` whenever a change
> introduces, alters or retires a **measure that is reported** — to a regulator, a counterparty, an
> auditor, or internally where a decision or an obligation turns on the figure. Neither sibling is
> relaxed here. Read the scope boundary in `README.md` first — these rules govern
> generated document content, not skill instruction prose.

### When this file applies

**Trigger test:** does the change create, change or remove a **number somebody reports**? One such
measure anywhere in scope triggers the file for the requirements that touch it; requirements that
carry no reported measure are unaffected.

It does **not** fire for a system that merely stores or displays data. The trigger is the reported
measure and the obligation behind it — the thing that must still be defensible when someone asks how
the figure was produced eighteen months later.

Per the same reasoning as ADR-0003 there is **no separate reporting requirements document**.
Everything below lands in the existing register, in the section the class map assigns.

### The Rule

**A reported measure is not specified until its population, its rules, its lineage and its
correction path are stated. The figure alone is a display; the four together are a measure.**

The failure this file exists to prevent is a requirement that names an output — *"a monthly
compliance report is produced"* — and leaves unstated which records it counts, which it excludes,
which version of the rules produced it, and what happens when it is later found wrong. Every one of
those is discovered during an audit rather than during design.

### The measure definition

A requirement over a reported measure is a declarative end state carrying four parts. Missing any
one, the figure is unreproducible.

| Part | Supplies | Never written as |
|---|---|---|
| **Population** | which records are in, which are out, and on what evidence | "all relevant records" |
| **Rule set and version** | the `BRL-NNN` rules that classify and calculate, and which version was in force | "as per the business rules" |
| **Lineage** | the source of each input and the identifier that survives to the output | "sourced from the data warehouse" |
| **Correction path** | what happens when a published figure is later found wrong | omitted, because it has not happened yet |

> ✗ `A monthly compliance report is produced`
> ✓ `The monthly compliance figure counts every service order closed in the calendar month, excluding orders cancelled by the customer, classified under the BRL-004 rule set version in force at closure, and each counted order is traceable to its source record by a stable identifier that survives restatement.`

**Do not nominate a system or dataset as authoritative unless the source material confirms that
status.** Which system is the book of record is a governance fact, not a drafting choice.

### Data quality — the anchor

**ISO/IEC 25012** (data quality model) is the taxonomy for data requirements, and it sits in the same
SQuaRE series as the ISO/IEC 25010:2023 characteristics the ORD's §3 is already keyed to.
**ISO/IEC 25024** supplies the measurement side. Use their characteristic names rather than coining
local ones, exactly as `ai.md` defers to ISO/IEC 22989:2022 for AI vocabulary.

A data requirement states a quality characteristic **of a named data element**, quantified, with the
consequence of breach — not a general aspiration that data is good.

### Where reporting and data requirement classes live

The class map. A row that does not appear here has no reporting-specific home and follows the normal
rules.

| Requirement class | Home |
|---|---|
| The reported measure itself — population, threshold, obligation behind it | ORD § 3.8.1 Functional Completeness |
| Accuracy, completeness, currentness of a named data element | ORD § 3.8.1, keyed to a `DAT-NNN` row |
| Reproduction of a historical figure under the rules in force at the time | ORD § 3.6.2 Analyzability |
| Lineage — source of each input, identifier surviving to the output | ORD § 3.6.2 Analyzability |
| Reconciliation — source, included, excluded, exception populations | ORD § 3.8.1 |
| Duplicate and omission control | ORD § 3.3.2 Integrity |
| Restatement and correction of a published figure | ORD § 3.6.1 Modifiability |
| Who may read the report, and at what granularity | ORD § 3.3.1 Confidentiality |
| Report availability and timeliness against the obligation | ORD § 3.1.1 Time Behavior |
| Retention of the figure and its supporting records | ORD § 3.3.3 Non-repudiation and Accountability |
| Definition and rule ownership, effective dating | ORD § 3.6.1, with the rules themselves as `BRL-NNN` |
| Exception visibility — what could not be determined, and why | ORD § 3.8.1 |

**Nothing here adds a §3 subsection.** Reporting requirements are ordinary operational requirements
whose *content* this file governs; they land in the 25010 subsections that already exist. A parallel
reporting section would restate the register.

### Canonical schema

#### Data element register

| ID | Data element | Used by | Quality characteristic | Tolerance | Source | Lineage | Owner |
|---|---|---|---|---|---|---|---|
| DAT-NNN | [named element] | [ORD-NNN, …] | [ISO/IEC 25012 characteristic] | [declarative, quantified] | [system or process of origin, where confirmed] | [how it reaches the output] | [named, or TBD with confirm-by] |

- **`Quality characteristic` uses ISO/IEC 25012's names.** There are fifteen and this is all of
  them — **accuracy, completeness, consistency, credibility, currentness, accessibility,
  compliance, confidentiality, efficiency, precision, traceability, understandability,
  availability, portability, recoverability**. A characteristic outside this list is a coined term;
  see the *Never* list. The standard splits them into inherent, system-dependent, and both — that
  split is **not** reproduced here, because the sources consulted disagree on where
  understandability sits and the standard text was not read. The split does not affect which name a
  `DAT-NNN` row carries; see the stamp below before citing conformance.
- **`Tolerance` is a business tolerance**, not a technical one: *"a closure timestamp is accurate to
  the calendar day, beyond which the monthly boundary is wrong"* — never *"timestamp precision
  ≤ 1s"*. `language.md` § *Demand, not design* applies unchanged.
- **`Source` is `[TBD]` until confirmed.** Nominating a system as the book of record on drafting
  authority is the most common way this register becomes wrong.

### Reconciliation

Where a measure is reported against an obligation, the register carries requirements establishing:
the **source population**; the **included**, **excluded** and **exception** populations; **duplicate
and omission control**; **record-level** and **aggregate** reconciliation; **variance treatment**;
and **restatement treatment**.

**A report is not represented as reconciled while unresolved variances remain**, unless an approved
tolerance explicitly permits it — and that tolerance is itself a register row with a named approver,
never an assumption.

### Competing methodologies

Where current operational practice differs from contractual, regulatory or documented reporting
practice, **both methodologies are preserved**. The document does not choose.

- Record each method and the decision criteria that distinguish them.
- Raise a decision item via `/raid add decision` and cite the `D-NNN` — this document never mints a
  decision ID.
- Identify the requirements and reported outcomes each method affects.
- Where interim direction has been given, record the approved interim method **and** the fact that
  it is interim.
- State the migration and historical-comparability consequence of each option.
- Where the difference is material to a reported figure, carry a comparison scenario under
  `tables.md` § *Scenario*.

**A methodology conflict is never recorded as an assumption.** An assumption is a thing believed
true pending confirmation; a live disagreement between two documented practices is a decision
somebody owns, and filing it as an assumption removes the owner.

### Standards of record

| Standard | Status here |
|---|---|
| **ISO/IEC 25012:2008** | Data quality model — fifteen characteristics. The taxonomy for `DAT-NNN` rows. Same SQuaRE series as ISO/IEC 25010:2023. Australian adoption: **AS/NZS ISO/IEC 25012:2013**, identical, reconfirmed 2024. |
| **ISO/IEC 25024:2015** | Data quality measurement. The measurement side of 25012. Australian adoption: **AS ISO/IEC 25024:2019** — **AS**, not AS/NZS. The series is not uniform; check each designation rather than pattern-matching off its sibling. |
| **ISO/IEC 20000-1:2018** | IT service management, third edition. **Clause 9.4 Service reporting** is the source of the service-reporting obligations behind report timeliness and availability rows — but the 2018 edition deliberately moved the detailed reporting requirements out of that clause and into the clauses where the reports are produced, so 9.4 is the hook and not the whole obligation. Amended by **ISO/IEC 20000-1:2018/Amd 1:2024**. Australian adoption: **AS/NZS ISO/IEC 20000.1:2019** — note the **dot** in the part number — reissued November 2024 incorporating Amendment No. 1. |
| **ISO/IEC/IEEE 29148:2018** | Unchanged. Only the evidence satisfying *verifiable* is elaborated here. |
| **OMG DMN 1.5** | Decision model and notation. §5.3.1 and clause 7 supply the decision / decision-logic separation the `BRL-NNN` register uses. 1.5 (August 2024) is the current formal version; 1.6 and 1.7 are beta and are not cited. |
| **OMG SBVR** | Semantics of business vocabulary and business rules. The vocabulary source where a rule needs one. |
| ISAE 3402 / ASAE 3402 | Assurance over service-organisation controls. **Not a requirements standard.** The reconciliation discipline above is drawn from control practice and is cited as practice, never as an obligation this file imposes. |
| DAMA-DMBOK, BABOK v3 | Practitioner bodies of knowledge. Useful as checklists; neither is cited as the authority for a requirement. |

#### Verification stamp

**Verified 2026-09-07 by Glen Sanders.** The four claims below were previously recorded as adopted
from knowledge and unchecked. Two are now confirmed against the publisher's own text; two rest on
national-body and distributor records because the ISO texts are paywalled and were not purchased.
Following `ai.md`'s convention, **what was not read is recorded as plainly as what was** —
this stamp narrows the gap and does not close it.

| Claim | Status | Checked against |
|---|---|---|
| ISO/IEC 25012 defines the data quality characteristic names used by `DAT-NNN` | **Verified — secondary sources only.** Fifteen characteristics; all names used in this file are among them | ISO catalogue abstract; a peer-reviewed application of 25012; the OMG DIDO wiki entry; iso25000.com |
| An AS/NZS adoption of ISO/IEC 25012 exists | **Verified — it does.** `ai.md`'s rule bites: **AS/NZS ISO/IEC 25012:2013**, identical adoption, current and reconfirmed 2024 | Standards Australia distributor record; corroborated by the scope statement of AS ISO/IEC 25024:2019, which names AS/NZS ISO/IEC 25012 as the source of the characteristics it measures |
| ISO/IEC 20000-1:2018 carries the service-reporting clauses attributed to it | **Verified — primary text.** Clause **9.4 Service reporting**, under clause 9 Performance evaluation. The foreword's change item (j) records that detailed reporting requirements were moved out of the service reporting clause into the clauses where the reports are produced | ISO's own redline preview of ISO/IEC 20000-1:2018 — table of contents and foreword |
| DMN's decision / decision-logic separation matches the `BRL-NNN` `Required Decision` column | **Verified — primary text.** DMN §5.3.1 defines a decision as *the act of determining an output value from a number of input values, using logic defining how the output is determined*; clause 7 defines how the decision requirements level and the decision logic level relate. The column states the first and excludes the second | OMG DMN 1.5 specification, §5.3.1 and clause 7 |

**What was not read.** ISO/IEC 25012:2008, ISO/IEC 25024:2015 and the body of ISO/IEC 20000-1:2018
are paywalled and were not purchased. Three consequences, none of them cosmetic:

1. **25012's normative definitions were not read** — only the characteristic *names* are
   corroborated. A `DAT-NNN` row naming a characteristic is safe from coining; a row asserting what
   that characteristic *means* is not yet grounded.
2. **The inherent / system-dependent / both split is unresolved.** Sources consulted disagree on
   whether *understandability* falls in the system-dependent group or the both group. The split is
   not reproduced in the `DAT-NNN` schema, so nothing in this file depends on it — but a document
   that reproduces the split is asserting something this stamp does not cover.
3. **Only 20000-1's front matter was read**, not clause 9.4's requirements. That the clause exists
   and is named *Service reporting* is confirmed; what it demands, in terms, is not.

**Still true, unchanged:** read the 25012 characteristic list before a document claims conformance
to 25012 or 25024.

**Two findings that were not claims and are recorded because they change what a document cites:**

- **ISO/IEC 20000-1:2018 has been amended** — `/Amd 1:2024`. A document citing the 2018 edition bare
  is citing a superseded state of the text.
- **The Australian designations are not uniform.** `AS/NZS ISO/IEC 25012:2013` and
  `AS/NZS ISO/IEC 20000.1:2019` are joint; `AS ISO/IEC 25024:2019` is Australian only. The
  20000 series uses a **dot** before the part number where the ISO original uses a hyphen. Each
  designation is checked, never inferred from its sibling.

- **Owner:** **Glen Sanders**, as maintainer of this ruleset.
- **Re-verify:** on any amendment or new edition of 25012, 25024, 20000-1 or DMN; before any
  document authored under this file claims conformance to 25012, 25024 or 20000-1; and at minimum
  annually. **Next due 2027-09-07.**

### Never

- Never state a reported measure without its population — "all relevant records" specifies nothing.
- Never state a measure without naming the rule set version that produced it.
- Never nominate a system or dataset as authoritative unless the source material confirms it.
- Never represent a report as reconciled while unresolved variances remain, absent an approved
  tolerance carried as its own row with a named approver.
- Never omit the correction path because the figure has not yet been wrong.
- Never record a methodology conflict as an assumption — it is a decision, and it has an owner.
- Never choose between competing methodologies without decision authority.
- Never mint a `D-NNN` here — `/raid` owns the decision namespace.
- Never coin a data quality term where ISO/IEC 25012 supplies one — there are fifteen names and
  the register bullet lists all fifteen.
- Never cite an ISO designation alone where an AS or AS/NZS adoption exists — an Australian auditor
  asks for the AS number, and the designations in this series are not uniform.
- Never cite ISO/IEC 20000-1:2018 without its Amendment 1:2024.
- Never state a technical data tolerance where a business one belongs (see `language.md`).
- Never add a §3 subsection for reporting — these are ordinary requirements in existing subsections.
- Never cite ISAE/ASAE 3402, DAMA-DMBOK or BABOK as the authority for a requirement.
