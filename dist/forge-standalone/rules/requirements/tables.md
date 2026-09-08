# Requirements Tables

> Governs how requirements are *presented* in generated documents. Pairs with
> [language.md](language.md), which governs how they are worded.

## The Rule

**Every binding statement is a row in a table with a stable ID. Prose carries narrative only.**

A statement is **binding** if someone could later be held to it. The test: *could this be
cited in a review, an audit, an SLA dispute, or an acceptance test?* If yes, it is a row.

This is deliberately narrower than "tabularise everything". Prose sections earn their place and
are made worse by tabulation — background, mission context, system overview, and day-in-the-life
operational scenarios stay as prose. What they must never do is introduce a commitment that does
not also appear as a row somewhere.

## Canonical Schemas

Use these exactly. A document that invents a column set drifts from its sibling, which is the
failure this file exists to prevent.

### Requirement register — the demand-side ORD

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
*"RTO 4h"* is the design response to it. See [language.md](language.md) § *Demand, not design*.

- **`Requirement Title` is active and verb-first** — `Restore service within one business day` —
  while `Business Tolerance` is noun-first and passive. That split is the existing rule in
  [language.md](language.md) § *Voice by Altitude*, applied at one altitude: titles command,
  criteria state. It is not a summary of the tolerance and never carries a value of its own.
- **`Business Tolerance` carries its own quantified value.** No separate threshold column — under
  [language.md](language.md) the requirement is a declarative end state, so the number is part of
  the sentence. Prefix **[AI]** where [ai.md](ai.md) governs the row.
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

### Operational objective

The outcome layer between a BRD objective and an operational requirement. Every register row traces
to one.

| ID | Objective | Baseline | Target | Target Date | Traces to |
|---|---|---|---|---|---|
| OBJ-NNN | [operational outcome, never the solution] | [current measurable position] | [required outcome] | [date or milestone] | [BO-N via BR-N] · [ORD-NNN, …] |

`Baseline`, `Target` and `Target Date` are measures under ISO/IEC 25022 / 25023. Where any of the
three is unavailable, write `[TBD — source: "quoted vague statement"]` and leave the gap visible.
**Never invent a baseline** — an objective whose baseline is guessed cannot show improvement.

### Scenario

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
- Each row stays a declarative statement under [language.md](language.md). A Rainy Day row states
  what *is* true when the dependency fails, never what might happen.
- A story or requirement whose scenarios are all `Sunny Day` has been specified for the demo, not
  for production.

### Business rule

Where classification, eligibility, calculation or reporting logic exists. **Business rules are
functional content**; an ORD carrying them is a declared deviation from its own scope, taken only
where no functional requirements document is produced in the chain — see [README.md](README.md)
§ *Scope boundary*. Say so in the document rather than letting the ORD absorb functional content
silently.

| ID | Rule Group | Required Decision | Status | Owner | Effective Date | Affects |
|---|---|---|---|---|---|---|
| BRL-NNN | Classification / Inclusion / Exclusion / Calculation / Exception / Reconciliation / Restatement | [the business decision the rule makes] | Confirmed / Provisional / Unresolved | [named, or TBD with confirm-by] | [where supplied] | [ORD-NNN, …] |

- **`Required Decision` states the decision, not the logic.** Follow OMG **DMN**'s separation:
  the decision is what must be determined; the decision logic is how. An ORD carries the first.
- **This register records business policy, never implementation design.**
- An `Unresolved` rule affecting a KPP-bearing requirement is raised via `/raid add decision`.

### Impact register

What the change touches and who owns it. Identification and accountability — never target state.

| ID | Impact | Kind | Treatment | Owner | Referred |
|---|---|---|---|---|---|
| IMP-NNN | [named L4 workflow or system in the current estate] | Process / System | Addressed / No change required / Out of scope | [named owner] | [REF-NNN or —] |

Naming the as-is estate is identification; naming the to-be estate is design. A row says what is
touched, who owns it, and whether **this document** addresses it — and says nothing about what
becomes of it. **Where tier numbers are cited, name the scheme they belong to** — an unqualified
"L4" resolves differently in APQC, eTOM and a house scheme.

**`Treatment` is a scope disposition, and the enum is closed.** Three values, no others:

| Value | Means |
|---|---|
| `Addressed` | This document carries requirements for the impact |
| `No change required` | The impact was identified and assessed as needing nothing |
| `Out of scope` | Identified, and deliberately excluded from this document |

**A design disposition is not a treatment.** *Migrated*, *decommissioned*, *extended*, *replaced*,
*rebuilt* — each names what becomes of the impact, which is the response's answer and not the
demand's. A row carrying one has crossed the line this register exists to hold.

**`Referred` is the pointer, `Treatment` is the disposition, and neither substitutes for the
other.** A referred impact still carries a treatment — usually `Out of scope`, because referral is
what happens *after* this document excludes it. Reading a populated `Referred` cell as a treatment
loses the distinction between an exclusion that went somewhere and one that did not.

**Where a document states an exclusion for a named impact, this cell is the authoritative value**
and any prose scope statement is a view of it. Prose keeps the exclusions that are not impacts —
populations, geographies, timeframes — which have no row to be authoritative in.

`Treatment` is additive. A register predating it reads `[TBD]` in that cell and is not retrofitted;
the value is written when the document is next reissued.

### Operational actor

Who and what the operational process runs through. **Identification, like the impact register** —
never authority the source did not state, and never a target operating model.

| Actor | Kind | Operational role | Owner |
|---|---|---|---|
| [named person-role, system or organisation] | User / System / Party | [what it does in the operational process] | [named owner, or TBD with confirm-by] |

- **`Kind` is `User` / `System` / `Party`.** `Party` is an external organisation — a retail service
  provider, a contractor, a regulator. Without it a cross-party consequence has no subject to name,
  and cross-party consequence is the class most often left derived and unconfirmed.
- **This table carries no ID, and that is deliberate.** The actor name is the key. An actor row
  identifies a subject; it commits nothing, so nothing traces *to* it — which is the test the
  § *Statements that carry no ID* rule applies, and this row sits outside that list rather than
  extending it. A prefix here would buy reference precision and cost a namespace every sibling
  skill must avoid colliding with.
- **Governance roles are not actors.** The SME who informed the document, the business owner who
  approves it and the convenor who wrote it belong in the document header and the entry-position
  record. A table mixing *the billing platform* with *the SME who reviewed this* serves neither
  purpose.
- **Notification is a view, not a column.** Who is told what, and when, cites the requirement rows
  that carry it.
- `Owner` accepts `[TBD]` with a confirm-by date. Where no stakeholder list arrives at assignment,
  a `[TBD]` per actor is what makes the absence countable; one entry-position row is not.

### Referred requirement

Content raised during elicitation that this document will not deliver. No row is classified against
a 25010 characteristic and no row becomes a requirement of this document.

| ID | Requirement | Raised by | Kind | Related impact | Resolver group | Referred to | Date | Status |
|---|---|---|---|---|---|---|---|---|
| REF-NNN | [what was raised] | [name] | Functional / Wrong resolver / Out of scope | [IMP-NNN] | [group, or **None in chain**] | [named recipient] | [date] | Referred / Accepted / **Referred, not accepted** |

An omitted requirement is indistinguishable from one nobody had; a referred requirement with a named
recipient is a handoff. **`Resolver group: None in chain` is a real answer** and the row stays open —
it is the visible form of a gap in the delivery chain, not a defect in the document.

### PRD story criteria

A PRD story is deliberately narrative — "As a … I want … so that …" carries intent and the business
outcome, which a register row cannot. Its **acceptance criteria** are rows:

| ID | Acceptance Criterion | Scenario |
|---|---|---|
| PRD-NNN.N | [declarative statement of what is true once delivered] | Sunny Day / Rainy Day / Edge Case |

- Criterion IDs are `PRD-NNN.N` within their story, so `/write-ac` maps each `AC-NNN` to a precise
  criterion rather than a whole story.
- A criterion over learned or generated behaviour is prefixed **[AI]** in the `Acceptance Criterion`
  cell and follows [ai.md](ai.md) as well as this file.
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
  statement under [language.md](language.md) — a Rainy Day criterion states what *is* true when the
  dependency fails, never what *might* happen.
- **A determination or eligibility story carries two Sunny Day criteria** — one where the answer is
  favourable and one where it is adverse. The capability succeeding and returning bad news is not a
  Rainy Day, and stating only the favourable case leaves the larger obligation unwritten. See
  § *Scenario* above for the `Outcome` axis; a PRD story may carry the column or say it in the
  criterion, but it states both cases either way.

### Statements that carry no ID

Two kinds of binding row are deliberately ID-less, because nothing ever traces *to* them:

- **Exclusions** (PRD § Out of Scope) — cited in scope disputes, never referenced by another row.
- **Coverage gaps** (ORD § 3.10) — a record of absence; the ID would belong to a requirement that
  does not exist.

Everything else that binds carries an ID. Do not extend this list to avoid assigning one.

### Interface detail

Per-interface technical attributes, keyed to a register row by `ORD#`. Specification, not
commitment — the binding statement is the register row, so this carries no priority or timing.

| ORD# | Integrated System | Interface Type | Protocol | Data Exchanged | Direction | Failure Behavior |
|---|---|---|---|---|---|---|

### Assumption

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

### Dependency

| ID | Depends on | Type | Owner | Needed by | Status |
|---|---|---|---|---|---|
| DEP-NNN | [named system, team, or deliverable] | Internal / External / Vendor | [role] | [date or milestone] | Open / Met / At risk |

## ID Namespaces

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
| `DAT-NNN` | Data elements — conditional, schema in [reporting.md](reporting.md) | `/write-ord` |
| `ASM-NNN` | Assumptions | whichever document records it |
| `DEP-NNN` | Dependencies | whichever document records it |
| `EVL-NNN` | Evaluation sets — schema in [ai.md](ai.md) | `/write-ord` (the PRD cites, never mints — see below) |
| `MDL-NNN` | Model / provider dependencies — schema in [ai.md](ai.md) | `/write-ord` (as above) |

`EVL-NNN` and `MDL-NNN` were added by ADR-0003 and apply only where [ai.md](ai.md) is triggered.
**Both have exactly one assigning skill, like every other prefix here.** `/write-reqs` authors the
PRD before the ORD, so a PRD needing a set that does not exist yet writes `[EVL-TBD — <what must be
measured>]` and `/write-ord` writes the real ID back — the same mechanism as `Capability` and `Epic`.
Where no ORD is produced at all, the PRD holds the registers and assigns the IDs, and says so.

All are flat and sequential in order of first appearance, never encode a theme or characteristic,
and are never reused once retired. `BO-N` and `BR-N` are single-digit-sequential per BRD, matching
the form `/write-brd` emits — do not re-pad them to three digits.

**Do not use single-letter prefixes.** `/raid` owns `R-`, `A-`, `I-`, `D-` for Risks, Actions,
Issues and Decisions — `A-NNN` for assumptions would collide with Actions.

## Coverage Gaps — the collapse rule

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

## View Tables

Where a commitment is genuinely needed in two places — an SLA summary restating availability, an
incident-response table restating recovery targets — the second occurrence is a **view**, not a
second source of truth.

A view table restates the `ID` and the agreed value by reference and introduces **no new
numbers**. Head it explicitly:

> *View of Section 3. Values are authoritative in the referenced rows; this table adds no new commitments.*

Two tables carrying the same commitment at independently editable values is the defect this
prevents.

## Never

- Never add a fourth `Scenario` value. A capability that runs correctly and returns an unfavourable
  answer is a Sunny Day with `Outcome: Adverse` — condition and outcome are two axes, and collapsing
  them into one column is what a fourth value would do.
- Never leave a determination, measurement or eligibility requirement with only a Favourable Sunny
  Day scenario. What is true when the answer is adverse is a separate obligation.
- Never write a design disposition into `Treatment` — *migrated*, *decommissioned*, *extended* and
  *replaced* each name what becomes of an impact, which is the response's answer and not the
  demand's. The enum is three values and it is closed.
- Never read a populated `Referred` cell as a treatment, and never leave a referred impact without
  one — referral is what happens after an exclusion, not the exclusion itself.
- Never give the operational actor table an ID prefix, and never put a governance role in it.
- Never put `Delivery Agent`, `Operational Owner`, `Timing` or `Verification` in the ORD register —
  each is response-side, and stating one pre-empts the design review the document exists to inform.
- Never state a technical target where a business tolerance belongs (see [language.md](language.md)).
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
