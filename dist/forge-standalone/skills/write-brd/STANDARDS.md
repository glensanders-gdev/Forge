# Authoring Standards

The standards `/write-brd` cites, gathered into one document so the skill works where
there is no filesystem to read them from. Each part keeps the name of the file it came
from: a citation such as `tables.md` means the part below with that name.

- **`README.md`** — Requirements Rules
- **`language.md`** — Requirements Language
- **`tables.md`** — Requirements Tables
- **`ai.md`** — Requirements — AI Solutions
- **`reporting.md`** — Requirements — Reporting and Data
- **`GATE-PROTOCOL.md`** — Gate Review Protocol
- **`STANDARD.md`** — write-brd — standard extract

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


---

## `GATE-PROTOCOL.md`

---
name: review-brd-gate-protocol
description: Shared review protocol for the two handoff gates in the requirements-documents pack — verdict vocabulary, evidence rule, outcome derivation and precedence, refusal-and-authority handling, and the report format. Read when running /review-brd or /review-ord.
---

## Gate Review Protocol

The machinery both gates share. `review-brd` and `review-ord` cite this file rather than carrying
two copies that drift.

**What this file is not.** It holds no criterion. Every BH and OH item, the `[TBD]` treatment table
and the four outcomes are defined in the pack and read from it at review time. This file states only
how a review is *conducted and reported* — which is tooling, and has no home in the pack.

---

### Sourcing the criteria

Two sources, in this order. The skill names which files it needs; this is where they come from.

1. **The live pack, where it is held** — `$FORGE_REQ_PACK/reference/…`, else
   `requirements-documents/reference/…` searching up from the working directory. **Authoritative.**
2. **`CRITERIA.md` beside the skill** — the same criteria, extracted from the pack by
   `tools/build-review-criteria.py` and shipped with the skill so a review runs on a machine that
   does not hold the pack. It is a **generated file**: pinned, stamped with the pack version, and
   never hand-edited.

**Name the pack version in every report**, from whichever source supplied it. A verdict is only
meaningful against a named bar — that is the pack's own thesis applied to the review of it.

**Where both are present and disagree, the pack wins and the extract is stale.** Say so in the
report and regenerate; a silent divergence between them is precisely the defect this pairing exists
to prevent.

**Never review from recollection.** A gate applied from memory drifts from the published one
silently, and the drift is invisible in the output. Where neither source is readable, stop.

### Verdict vocabulary

Four verdicts, from the pack's `[TBD]` treatment table and the verdicts its worked assessment
actually uses. Use these words exactly; a fifth verdict is a sign the treatment table was not read.

| Verdict | The item carries |
|---|---|
| **Met** | A value |
| **Met, with a declared gap** | `[TBD]` with a named owner **and** a date. Met for the bar — and the gap propagates |
| **Unowned gap** | Outstanding, with **nobody to carry it**. Neither met nor owned |
| **Absent** | Nothing at all, or `[TBD]` missing the owner, the date, or both. A hole, not a gap |

**The propagation rule is part of the verdict, not a footnote.** A declared gap that passes the bar
and then disappears is worse than a refusal, because it looks like a pass. Every *Met, with a
declared gap* verdict names where the gap must reappear downstream — the empty traceability row, the
unanswered objective — and a review that cannot name that has not finished the verdict.

**The two limits, wherever declared gaps are counted.** The pack states both at the BRD gate, in
objective terms: at least one objective is fully quantified, and the gap does not sit on the
objective the change is funded against. Without them the bar is unfailable, because every absence
converts to `[TBD] + owner + date`. Apply them where the pack scopes them; where a downstream item
is not an objective, say the limits are stated upstream rather than asserting they bind here.

### Evidence rule

**Every verdict cites where it was read** — the section, the row, the requirement ID — or names
precisely what is absent. A verdict with no citation is an assertion, and an assertion is what an
independent reviewer exists to replace.

### Outcome derivation

The outcome follows from the verdicts. Test in this order and stop at the first that fires:

| Order | Condition | Outcome |
|---|---|---|
| 1 | Any **bar** item is *Absent* | The refusal outcome — *Not accepted for ORD development* / *Not ready for handoff* |
| 2 | Any item, bar or supporting, is an *Unowned gap* | The unowned-gap outcome |
| 3 | Any item is outstanding with an owner and a date, or carries a declared gap | The recorded-gaps outcome |
| 4 | Otherwise | The clean outcome — *Accepted* / *Ready for handoff* |

**This order is the pack's, not this file's.** Both gates state the precedence — the refusal first,
then the unowned gap, then recorded gaps — and both state that the recorded-gaps outcome covers a
declared gap wherever it sits, **including on the bar**. Read those two statements at the gate rather
than trusting this table; where they disagree with it, they win and this file is the defect.

### Refusal and authority

The refusal outcome is the one outcome in the pack that requires authority: the Tier 1 control
*"right to declare an ORD not-ready and refuse handoff"* at §8, which the standard states is **not
currently held**.

Where that right is not held, report the refusal as **recorded rather than exercised**: name the
absent bar items, state that the document proceeds, and state that the accumulation of these records
across cycles is the evidence for establishing the control. A gate that implies an authority nobody
holds is theatre; a refusal that was warranted, declared and overridden is the argument for the
control.

### Report format

```markdown
## [BRD|ORD] Review — [document ID and title]

**Assessed against:** [standard path] · **Reviewer:** [named, and whether they authored it]

### Verdicts

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | [section or row, and what makes it that verdict] |

### Outcome

> **[Outcome name].** [The verdicts that forced it, by the derivation order above.]
> [Where a declared gap passed the bar: where it must reappear downstream.]
> [Where the outcome is a refusal: the authority note above.]

### The five checks

| Check | Finding |
|---|---|
| Baseline gap | [answered, or *not answerable at this hop* with the reason] |

### What this review does not cover

[Anything the gate does not reach — content quality, altitude beyond the items, downstream fit.]
```

**Report what the verdicts did not do, where it matters.** A recorded gap drives the maturity tier
only where it reaches a KPP-bearing requirement. Recording a gap and tier-driving it are two
different things, and the pack names conflating them as how a gate becomes theatre.

### The five checks

Read from `reference/traceability-matrix.md` at review time — baseline, coverage, conformance,
translation and verifiability gaps. Answer each, or mark it not-yet-answerable at this hop with the
reason. A check reported clean because it could not be run is worse than one reported unanswerable.

---

### Never

- Never carry a criterion in this file. It holds protocol; the pack holds the bar.
- Never emit a score, a percentage or a pass rate — four outcomes and a verdict per item.
- Never report a check clean that could not be run at this hop.
- Never let a declared gap pass without naming where it reappears downstream.


---

## `STANDARD.md`

> **Generated file. Never hand-edit.** Produced by `tools/build-review-criteria.py`
> from the requirements-documents pack, which is the single source of truth for
> everything below. Editing this file puts it out of step with the pack; regenerate
> instead.

**Pack version:** v1.11 · **Pack commit:** `d2f74eca4885`
**Generated:** 2026-09-07 · **Content hash:** `2f1b62fc3836b797`

**Quote the version in every BRD authored from this extract.**
A reader needs to know which revision was applied — a verdict, and a document
authored to a bar, are only meaningful against a named one, and that is the pack's
own thesis applied to itself.

**Where the live pack is present, it wins.** This extract exists so the skill runs
for someone who does not hold the pack. It is a pinned copy, not an authority: where
it and the pack disagree, the pack is right and this file is stale.

---

<!-- from reference/brd-standard.md -->

## BRD Standard

**Standard of record:** BABOK v3 · **Audience:** Business Analysts, Product Owners, Product
Managers, Sponsors, Management

A Business Requirements Document states **why** money is being spent and **how it will be known
that it paid off** — before anyone decides what to build.

---

### Why this exists

Business Requirements Documents are written inconsistently, and the common failures are expensive:

- **No measurable business objective** — the BRD describes a desire ("improve checkout") but no
  target, so success can never be claimed or disproven.
- **Solution smuggled into the business case** — the BRD names a feature ("build saved cards")
  instead of an outcome, pre-empting the solution documents and biasing the design.
- **No stakeholder register** — the people who approve, fund, or are affected are not identified,
  so sign-off stalls.
- **No line of sight to delivery** — a built feature cannot be traced back to the business
  objective that justified it.

The BRD is also the **entry criterion** for the operational document that follows it. A BRD with no
quantified objective and no cost-of-failure case leaves the ORD with nothing to derive a tolerance
from — see [Entry criteria](#entry) and the E1–E9 list.

### The standard

The BRD has no single ISO. The authoritative anchor is the IIBA's **BABOK v3** (Business Analysis
Body of Knowledge). It defines a **requirements taxonomy** — Business, Stakeholder, Solution,
Transition — that determines which document owns which requirement. The BRD owns the **Business**
requirements and frames the **Stakeholder** ones. **Solution** requirements are handed down: the
operational half to the ORD, as quantified business tolerance.

**The functional half has no document in this chain.** The taxonomy names it, the
[PRD standard](#prd) defines its shape, and it is not adopted here — so functional detail is
inferred during Epic decomposition rather than elicited. That absence is not a gap in the BRD's
responsibilities, but it does change what happens to a business rule the BRD correctly declines to
carry: see [what leaves the chain](#traceability).

#### What changes, concretely

| Today | Under the standard |
|---|---|
| Each author invents a structure | One fixed BRD template |
| "Improve checkout" with no target | SMART business objectives with baselines and targets |
| Solution named in the business case | Outcomes only; operational demand lives in the ORD, the design in the SOAP |
| Stakeholders unclear | Stakeholder register with approval roles |
| Delivered work cannot be justified | Objective → ORD → SOAP → Capability AC traceability |

#### The ask

1. **Adopt BABOK v3** as the BRD anchor, using the template on this page.
2. **Require SMART business objectives** with baseline and target on every BRD.
3. **Require a cost-of-failure case** wherever the change carries operational exposure — this is
   what makes an operational tolerance derivable downstream.
4. **Keep solutions out of the BRD** — the BRD states outcomes; the ORD owns the operational
   demand detail, and the SOAP owns the technical answer.
5. **Name an owner** for the standard (recommended: Lead Business Analyst or Programme sponsor).

---

### BABOK v3 — the requirements taxonomy

BABOK v3 classifies every requirement into one of four types. This taxonomy is the most useful tool
for deciding **which document a requirement belongs in**.

| BABOK type | What it captures | Lives in |
|---|---|---|
| **Business** | Higher-level goals, objectives and outcomes of the enterprise. The "why" | BRD |
| **Stakeholder** | Needs of a specific stakeholder or group — the bridge from business goal to solution | BRD |
| **Solution — Functional** | What the solution must *do* (behaviour, capabilities) | **No document in this chain.** Inferred at Epic decomposition. Defined shape: [PRD standard](#prd), unadopted |
| **Solution — Non-functional** | How well the solution must *perform and run* (quality attributes) | ORD, as business tolerance |
| **Transition** | Temporary capabilities to move from current to future state (migration, training, cutover). Retired after go-live | BRD or implementation plan |

> **The split that matters is one line in this taxonomy.** A *Solution* requirement is either
> **functional** or **non-functional**. The BRD holds neither kind of detail — it holds the Business
> outcome they serve. Of the two, only the non-functional half has a document to land in, which is
> why an elicited business rule has to be **recorded and routed** rather than simply passed on.

#### A good business objective is… (SMART)

| Letter | Means |
|---|---|
| **S**pecific | Names one concrete outcome, not a vague aspiration |
| **M**easurable | Has a metric, a baseline and a target number |
| **A**chievable | Realistic within budget, capability and time |
| **R**elevant | Ties to a strategic goal the sponsor cares about |
| **T**ime-bound | States by when it is achieved |

The most common BRD failure is **Measurable**: an objective with no baseline or target can never be
proven met. SMART objectives are how a BRD earns its sign-off — and they are what the ORD's
tolerances trace back to.

---

### The BRD anatomy — required sections

Every BRD carries these sections. Sections marked **★** are the ones most often missing and most
important to enforce.

| § | Section | Purpose |
|---|---|---|
| 1 | **Document control** | Version, author, sponsor, approval status, date |
| 2 | **Executive summary** | The business case in one paragraph, readable by an executive who reads nothing else |
| 3 | **Business need / problem** | The problem in business terms — cost, risk, lost revenue, compliance. No solution |
| 4 | **★ Business objectives and success measures** | SMART objectives with baseline and target. The BRD's measurability |
| 5 | **★ Stakeholders** | Stakeholder register — who approves, who funds, who is affected, and their role |
| 6 | **Current vs future state** | Where the business is now and the target operating state, in business terms |
| 7 | **Business scope (in / out)** | Which business areas, processes or segments are in and out. Not feature scope |
| 8 | **★ Business requirements** | High-level needs (BABOK Business and Stakeholder types) — what the enterprise needs, not how |
| 9 | **Constraints, assumptions and dependencies** | Budget, regulatory and time constraints; what must hold true; external dependencies |
| 10 | **Risks** | Business risks to the objective and their mitigations |
| 11 | **★ Cost–benefit and cost of failure** | Expected return against cost, **and the cost of the objective not being met** — the input every operational tolerance is derived from |
| 12 | **★ Traceability** | Business objective → ORD operational requirement, and onward to the SOAP and Capability AC. Proves every build traces to a justification |
| App. A | **Process and system scope** | The L1–L3 process areas and the systems in scope, each with a named owner. Seeds the ORD's impact register |

> **The five ★ sections close the gaps most BRDs miss**: SMART objectives, a real stakeholder
> register, business-level requirements kept free of solution detail, a cost-of-failure case, and
> traceability down to the ORD. Enforce these and the rest follows.

**Appendix A is what makes the ORD sizeable at assignment.** The impact counts that set S/M/L in the
lead-time standard are read off it. A BRD with no process or system scope leaves the size to be
guessed and re-sized later.

---

### Writing business objectives, not solutions

A business objective states the *outcome* the enterprise wants. The discipline that keeps a BRD
clean is: **describe the change in a business metric, never the feature that achieves it.**

**Objective form:**

```
Move [business metric] from [baseline] to [target] by [date], so that [strategic outcome].
```

#### Solution vs outcome — the test

| Written as a solution (wrong for a BRD) | Written as an outcome (right) |
|---|---|
| "Build an automated rebate engine." | "Reduce complaints arising from missed appointments from 1,840 to below 900 per quarter by FY27 Q2." |
| "Add a self-service password reset page." | "Cut password-related support tickets by 30% within a year." |
| "Migrate to the new payments provider." | "Lower payment processing cost per transaction by 15% by FY-end." |

> **Rule:** if an objective names a screen, feature, system or technology, it has leaked solution
> detail. Rewrite it as the measurable outcome. The operational tolerance belongs in the ORD and
> the technical figure in the SOAP; functional detail has no document here and is registered rather
> than passed on.

#### The cost-of-failure statement

An objective states what is gained. A **cost-of-failure statement** states what is lost, and it is
the input the ORD converts into a tolerance:

```
If [business metric] is not held, the consequence is [named consequence]
at [quantified cost], because [obligation, contract or mechanism].
```

Without it, an ORD tolerance is either traceable to nothing or invented. This is the single most
common upstream cause of a low-maturity ORD.

---

### Where the BRD sits in the chain

The BRD sits highest and holds **no requirement detail**. Everything below it is a transformation
performed by someone who did not author the input.

```
BRD  →  ORD  →  SOAP  →  Capability AC  →  Epic AC
why     what the      how it will      what will      what will
        business      be met           be accepted    be built
        requires
```

| Altitude | Artefact | Holds | Authored by |
|---|---|---|---|
| Why — the outcome | **BRD** | Business objectives, stakeholders, business case, cost of failure | Business analysis |
| How well it must serve the business — operational demand | **ORD** | Quantified business tolerance across the nine ISO/IEC 25010 characteristics, and the impact register | ORD convenor |
| How the demand is met — the technical answer | **SOAP** | Availability figures, RTO/RPO, latency budgets, capacity, infrastructure, support model | Solution architecture |
| What will be accepted | **Capability AC** | Acceptance criteria derived from the SOAP | Product Manager |
| What will be built | **Epic AC** | Build-level acceptance criteria | Technology BA |

**The ORD is a demand document, not a design one.** It states what the business can tolerate;
architecture's response — the Solution on a Page — derives the technical figure that satisfies it.
See [Roles at the boundary](#roles).

**One artefact is missing from this chain, and the BRD feels it first.** There is no functional
requirements document between the BRD and the Capability. A business rule the BRD correctly declines
to carry has nowhere to go, so it is inferred later during Epic decomposition — or, if elicited
during ORD work, held in the referred requirements register as an interim record.

#### The decision that actually recurs: tolerance or figure?

Once a requirement is detailed, it is a *Solution* requirement, so the BRD is no longer a candidate.
For the operational half, the live question is whether the statement is a **business tolerance** —
the ORD's — or a **technical figure** — the SOAP's.

| Requirement detail | Classification | Lands in |
|---|---|---|
| "Authorisation delay beyond 3 seconds causes measurable cart abandonment, at $X per point" | Business tolerance, performance efficiency | **ORD** §3.1.1 |
| "Payment authorisation P99 ≤ 800 ms" | Technical target | **SOAP** — architecture's answer to the tolerance above |
| "Checkout unavailability in peak trading costs $X per hour and breaches merchant obligation Y" | Business tolerance, reliability | **ORD** §3.2.1 |
| "99.99% monthly availability" | Technical target | **SOAP** |
| "PCI-DSS applies; a breach carries penalty X and loss of acquiring" | Compliance obligation | **ORD** §3.3.6 |
| "Card data tokenised, no PAN at rest" | Technical control | **SOAP** |
| "A customer acting on a generated summary that misstates their entitlement breaches obligation Y, at $X per occurrence" | Business tolerance, accuracy of generated output | **ORD** §3.8 |
| "Summary quality scores ≥ 4.0 of 5 mean on a held-out evaluation set, no single case below 2.5" | Technical target — the evaluation instrument | **SOAP** |
| "Customer pays in one tap with a saved card" | Functional behaviour | **No document** — inferred at Epic decomposition, or registered as a referred requirement |
| "Refunds over $500 require supervisor approval" | Business rule | **No document** — as above |
| "Tier 2 support staffed at 4 FTE, follow-the-sun" | Staffing | **Referred requirements register** |

> **The test when a detail resists placement.** **Existence:** does architecture's answer to this
> document already exist? If not, a technical figure in the ORD is an antipattern regardless of how
> well it traces — a well-justified RTO is still architecture's to set. **The test reaches an evaluation
> instrument unchanged:** a set that does not yet exist cannot carry a pass mark here, because the
> pass mark *is* the answer. The population the measure is taken over, and the consequence of
> breaching it, are the demand side and belong in the ORD.

> **Net:** the BRD deliberately holds no detail. The decision made day to day is **tolerance or
> figure** — and, for anything functional, **which register receives it**, since no document will.

---

### The handoff gate — is this BRD ready for ORD development? ★

The BRD's author owns this gate. It is the exit criterion for the BRD and the entry criterion for
the ORD, and it is stated here rather than in the ORD standard because a document's readiness is
its author's to establish, not its recipient's to adjudicate after the fact.

**Assessed before ORD development is assigned, not after.** The ORD's own entry criteria (E1–E9)
record what arrived; this gate establishes whether what arrived is enough to start.

**What puts an item on the bar, and what does not.** An item is on the bar where its absence makes
the next document **unwritable** — not merely less mature. Everything whose absence the maturity
tier can absorb is a supporting item. That rule is what keeps the two lists from being a matter of
taste, and it is the same rule [§7.1](#handoff) applies one hop downstream.

#### How a `[TBD]` is treated — read this before the bar

The pack's rule against inventing a threshold means a BRD arrives with declared gaps, and a gate
that treats every gap as an absence refuses every real document. A gate that treats every gap as
satisfied refuses none. Neither is useful, so the treatment is stated rather than left to judgement:

| The item carries | Treatment |
|---|---|
| A value | **Met** |
| `[TBD]` with a **named owner and a date** | **Declared gap.** The item is met *for the bar*; the gap propagates — the objective it sits on carries no tolerance, and its traceability row stays visibly empty |
| `[TBD]` with no owner, or no date, or neither | **Absent.** Not a gap, a hole. It fails the bar |
| Nothing at all | **Absent** |

**Two limits, and without them the bar is unfailable.** A declared gap is not a free pass:

1. **At least one objective is fully quantified** — baseline, target and date, no `[TBD]`. It is
   what the ORD derives its first tolerances from. A BRD whose every objective is `[TBD]` fails
   BH-1 however well-owned the gaps are.
2. **The gap does not sit on the objective the change is funded against.** Where the business case
   rests on the objective that is unquantified, the case is unquantified, and no downstream document
   can repair that.

> **The point of the propagation rule.** A declared gap that passes the bar and then disappears is
> worse than a refusal, because it looks like a pass. Every gap admitted here **must** reappear as
> an empty traceability row and an unanswered objective downstream — see BO-4, which does exactly
> that at §12 of the worked example and again on the [traceability matrix](#traceability).

#### The bar — four items, and their absence is a refusal

These four are what an ORD cannot be written without. Each maps to a load-bearing element the ORD
consumes immediately.

| # | Required | Consumed by | Absent means |
|---|---|---|---|
| **BH-1** | A named business objective carrying a **baseline, a target and a date**. Assessed per objective; the two limits above govern how many may be declared gaps | Every tolerance traces here. It is what establishes *why* two billing cycles rather than three | Every ORD requirement is orphan scope, and no tolerance is auditable |
| **BH-2** | Each objective stated as an **outcome, not a solution** — no feature, system, vendor or asserted figure | Leaves the ORD something to add | The BRD has pre-empted the ORD. The figure is asserted rather than derived, and the architecture review becomes ratification |
| **BH-3** | **Constraints and dependencies carrying operational weight** — regulatory obligations, contractual commitments, platform dependencies, named specifically | Seeds Security, Compatibility and Reliability | The ORD author invents them or misses them |
| **BH-4** | A **cost-of-failure case** for each objective carrying operational exposure | The input every tolerance is derived from | A tolerance traced to no consequence is an invented figure, however well it is written. The single most common upstream cause of a low-maturity ORD |

> **BH-1 to BH-3 are the three load-bearing elements at [§3.4](#entry); BH-4 is the fourth, and it
> is the one most often assumed to be optional.** A complete BRD is not the bar — these four are.
> A BRD carrying only these and nothing else is enough to start on.

#### Supporting items — absent, these are recorded and drive the tier

Their absence does not stop ORD development. It determines the maturity tier committable on the
fixed date, and each is recorded under [§3.3](#entry) at assignment.

| # | Required | Absent means |
|---|---|---|
| **BH-5** | **Stakeholder register** naming who approves, who funds and who is affected | The author is least placed to compile it. A late list does not cost the days it was late — it costs the back half of the ORD |
| **BH-6** | The **approving GMs named**, one per business unit in scope | Unknown approvers surface at sign-off rather than at the start |
| **BH-7** | **Business scope, in and out**, with the out-list explicit | Silent scope growth, and the ORD extends the operational boundary beyond what was authorised |
| **BH-8** | **Appendix A — process and system scope**, each row carrying a named owner | The ORD is not sizeable at assignment, so it is sized on a guess and re-sized later. Half the impact register has to be reconstructed from stakeholder recall, at stakeholder cost |
| **BH-9** | A **traceability skeleton** — each objective against the tolerance expected to quantify it, or an explicit blank | A funded objective with no operational demand stated is invisible until nobody delivers it |
| **BH-10** | **Business requirements stated at business altitude** — no workflow, system or figure | Solution detail leaks downstream and the ORD inherits an answer instead of a question |

#### The four outcomes

| Outcome | Condition | What follows |
|---|---|---|
| **Accepted** | BH-1 – BH-10 met, no declared gaps | ORD development starts. The entry position record carries no outstanding items |
| **Accepted with recorded gaps** | BH-1 – BH-4 met; one or more items outstanding, **each with a named owner and a date** — a declared gap on a bar item, a supporting item outstanding, or both | ORD development starts. The gaps are recorded at [§3.3](#entry) and determine the committed maturity tier where they reach a KPP-bearing requirement |
| **Accepted with an unowned gap** | BH-1 – BH-4 met; an outstanding item has **no owner to carry it** | ORD development starts. The item is recorded at [§3.3](#entry) and **raised with the approving GMs at sign-off rather than referred, because a referral needs a recipient.** It stays open until someone accepts it — and that it stayed open is the finding |
| **Not accepted for ORD development** | Any of BH-1 – BH-4 absent, per the `[TBD]` rule above | Returned to the author with the absent items named. **The ORD task is a BRD task in disguise** — see the antipatterns at [§3.4](#entry) |

**Where more than one row applies, the outcome is the most serious of them** — the refusal first,
then the unowned gap, then recorded gaps. The worked assessment below carries declared gaps at BH-1
and BH-4 *and* an unowned one at BH-8, and lands on the third outcome rather than the second.

**The second row covers a declared gap wherever it sits, including on the bar.** A bar item carrying
`[TBD]` with an owner and a date is met *for the bar* under the rule above, but the document is not
gap-free — so it is neither the first outcome nor a refusal. Reading the row as supporting-items-only
left that document matching no outcome at all.

**The third outcome is the one most documents land on, and it exists because the second could not
hold it.** An item outstanding *with* an owner is a scheduling problem. An item outstanding with
**nobody to own it** is a finding about the organisation rather than about the document, and
collapsing the two loses the more serious of them.

**Requesting the detail before ORD development proceeds is the correct response, not an
escalation.** An ORD written from a BRD missing its bar produces figures nobody can defend, and
the cost of that lands after architecture has designed against them.

> **This outcome depends on a right the standard says is currently absent, and that is worth
> stating plainly rather than glossing.** The [ORD Intake and Maturity Standard](#purpose) is a
> **declaring** standard, not a blocking one — every other mechanism in it produces a record rather
> than exercising a veto, precisely because a record is available to someone holding no authority.
> *Not accepted for ORD development* is the one outcome in this pack that requires authority: the
> Tier 1 control **"right to declare an ORD not-ready and refuse handoff"** at
> [§8](#controls), listed there as a control **to be established**.
>
> **Where that right is not yet held**, the outcome is *recorded* rather than exercised: the ORD
> proceeds, the absent bar items are recorded at [§3.3](#entry), and the committed tier reflects
> them. That record is the evidence for establishing the control — a refusal that was warranted,
> declared, and overridden is a stronger argument than the same right requested on day one.

---

### Worked example — BRD-2026-041, Missed Appointment Rebate (Acme Communications)

**Document:** BRD-2026-041 · **Status:** Approved · **Priority:** P1
**Executive sponsor:** Chief Customer Officer · **Author:** Business Analysis
**Horizon:** FY26 H2 – FY27 Q2 · **Standard:** BABOK v3

> **One worked example runs the pack's live chain.** This BRD is the upstream document for the
> [worked example ORD](#example) and for the [traceability matrix](#traceability). Its objectives,
> constraints and scope are the ones that ORD's tolerances trace back to, so the three can be read
> as one chain rather than three unrelated illustrations. Copy the shape, not the figures.
>
> **One page stands outside it, deliberately.** The [PRD standard](#prd) carries a self-contained
> example, because the chain documented here has no functional requirements column to run one
> through. That exception is the gap, not an inconsistency.

#### 2 · Executive summary

Acme Communications is contractually obliged to credit a customer whose installation appointment is
missed. That credit is issued today only when the customer complains. The result is a complaint
volume of **1,840 per quarter** that exists largely to claim money already owed, and an unquantified
population of customers who are owed a credit and never received one. This programme makes the
rebate determination automatic, reducing complaints below 900 per quarter by FY27 Q2 and closing the
compliance exposure that the complaint-driven process conceals.

#### 3 · Business need — the position today

| | Today | Consequence |
|---|---|---|
| Rebate trigger | Issued **only when a customer complains** | A customer who does not complain does not receive a credit clause 14.3 obliges Acme to pay |
| Complaint volume | 1,840 per quarter (FY25 Q4 baseline, INC-4471 theme analysis) | Contact-centre load generated by customers claiming money already owed |
| Attendance record | Attendance and non-attendance are **not recorded distinguishably** | A missed appointment cannot be determined from field data; the customer is the detection mechanism |
| Rebate determination | Manual, on receipt of a complaint | Determination depends on an agent reconstructing the appointment history within the call |
| Contract change | Clause 14.3 amended twice since 2023; each amendment required a software release | The rebate amount and qualifying window lag the contract they implement |
| Unclaimed exposure | Not measured | `[TBD — source: "that credit is issued only when a customer complains"]` — Regulatory Affairs to quantify |

**The last row is left open on purpose.** The exposure is real and its size is not known, and
inventing a figure to avoid an empty cell is the failure this standard exists to prevent. It is
carried as a visible gap with a named owner rather than as a number nobody can defend.

#### 4 · Business objectives and success measures ★

| ID | Objective (SMART) | Baseline | Target | By |
|---|---|---|---|---|
| BO-1 | Reduce complaints arising from missed installation appointments | 1,840 / quarter (FY25 Q4) | < 900 / quarter | FY27 Q2 |
| BO-2 | Issue the rebate owed under clause 14.3 without the customer making contact | 0% issued unprompted | ≥ 95% of determined rebates | FY27 Q2 |
| BO-3 | Bring the rebate amount and qualifying window into effect within one billing cycle of a contract change | Release-dependent; two amendments since 2023 | ≤ 1 billing cycle, no release | FY27 Q2 |
| BO-4 | Close the unclaimed-rebate exposure carried under clause 14.3 | `[TBD — Regulatory Affairs, due 2026-08-15]` | `[TBD]` | FY27 Q2 |
| BO-5 | Answer a regulatory enquiry into any appointment's rebate position within one business day | Manual reconstruction, duration not measured | ≤ 1 business day | FY27 Q2 |

**BO-4 is unquantified and stays in the register.** An objective with a `[TBD]` and an owner is a
tracked gap; the same objective omitted is invisible. It is the objective most likely to change the
business case, which is why it is not deferred out of the document.

#### 5 · Stakeholders ★

| Stakeholder | Interest | Role |
|---|---|---|
| Chief Customer Officer | Complaint volume and customer trust | Executive sponsor; approves spend |
| GM Customer Care | Complaint handling, customer channel | **Approves the ORD**; owns the operational consequence |
| GM Field Operations | Attendance capture and contractor data | **Approves the ORD** |
| GM Billing | Rebate application, billing-cycle boundary | **Approves the ORD** |
| Regulatory Affairs | Clause 14.3 interpretation, enquiry response | Consulted; owns BO-4's quantification and OQ-01 |
| Contract Manager, Field Services | Attendance-data timeliness under the field services agreement | Consulted; constrains scope |
| Solution Architecture | The design that answers the ORD | Authors the SOAP |
| Product Manager | What will be accepted | Authors the Capability acceptance criteria |
| Affected customers | Receiving the credit they are owed | Affected; not consulted directly |

**Three GMs approve the ORD, and none of them approves this document.** The obligation is
contractual and the consequence lands across three business units, so the operational tolerance is
committed by the units that carry it rather than by the sponsor who funds the change.

#### 6 · Current vs future state

**Current:** the customer is the detection mechanism. A missed appointment is discovered when the
customer calls, determined by an agent reconstructing history mid-call, and credited manually.
Customers who do not call are not credited.

**Future:** a missed appointment is determined from data captured during the field job, the rebate
is applied within the contracted window without customer contact, and the complaint path carries
only genuine exceptions.

#### 7 · Business scope

**In:** appointment completion, rebate determination, rebate application and customer notification,
across Field Operations, Customer Care and Billing. **At go-live: residential installation
appointments.**

**Out:** business and assurance appointments — **phased to a later release**, and the reason BO-1's
target is set against residential volume only. Also out: contact-centre staffing, hosting and
infrastructure, and commercial renegotiation of the field services agreement.

#### 8 · Business requirements ★

- **BR-1:** A customer whose installation appointment is missed receives the contracted rebate
  without contacting Acme.
- **BR-2:** A customer establishes their own rebate position through a channel they already use.
- **BR-3:** The rebate amount and qualifying window track the consumer contract without a software
  release.

> Note the altitude. None of these names a workflow, a system or a figure. "Attendance capture in
> the workforce management platform" and "within two billing cycles" appear nowhere here — the first
> is the SOAP's answer, the second is the ORD's tolerance.

#### 9 · Constraints, assumptions and dependencies

| | Statement | Operational weight |
|---|---|---|
| Constraint | Consumer contract cl. 14.3 — rebate payable within two billing cycles of the missed appointment | Sets the tolerance the ORD quantifies |
| Constraint | Consumer contract cl. 14.5 — no duplicate credit; cl. 14.6 — seven-year retention | Bound determination and auditability |
| Constraint | Field services agreement §9 — contractor attendance data supplied within 24 hours | Bounds how current any determination can be |
| Constraint | Billing cycle boundary — monthly, per customer | Fixed. Not a design choice, and it bounds every tolerance expressed in cycles |
| Assumption | Contractors submit attendance through the existing channel without process change | If wrong, a commercial variation lands on the critical path |
| Dependency | Contractor portal data-quality remediation (Field Systems programme) | **At risk.** Determination rests on attendance data of known imperfect quality |

#### 10 · Risks

| Risk | Business consequence | Mitigation |
|---|---|---|
| Rebates determined from imperfect attendance data | A small number of credits issued where an operative did attend | Accepted — over-issue cost sits materially below the complaint cost BO-1 quantifies |
| Clause 14.3's "two billing cycles" is interpreted from confirmation rather than from the appointment | Every tolerance expressed in cycles moves | Regulatory Affairs interpretation due 2026-08-15 (OQ-01) |
| Rebate eligibility rules are inferred rather than elicited | Rules reach build unchecked with the business | **Unmitigated in this chain** — no functional requirements document exists to receive them |

#### 11 · Cost–benefit and cost of failure ★

**Benefit.** Complaint volume falls by an estimated 940 per quarter at target, against the fully
loaded handling cost of a contact. Validated by Finance.

**Cost of failure**, and it is what the ORD's tolerances are derived from:

| If this is not held | Consequence | Source |
|---|---|---|
| The rebate is not applied within two billing cycles | Breach of consumer contract clause 14.3, per affected customer | Consumer contract v11 |
| Determination stops when an attendance source is interrupted | 2,300 jobs went unreconciled in a 19-hour contractor portal outage | INC-5012 |
| The rebate is issued only on complaint | Unquantified population owed a credit and never paid | `[TBD — Regulatory Affairs, due 2026-08-15]` |

**Without this section the ORD has nothing to quantify against.** A tolerance traced to no
consequence is an invented figure, however well it is written.

#### 12 · Traceability ★

| Objective | Business req | Quantified as (ORD tolerance) |
|---|---|---|
| BO-1, BO-2 | BR-1 | ORD-03 **[KPP]** — rebate applied within two billing cycles |
| BO-1 | BR-1 | ORD-04 **[KPP]** — determination survives a 24-hour source interruption |
| BO-2 | BR-1 | ORD-15 — a missed appointment is determinable without re-keying |
| BO-2 | BR-2 | ORD-13 — rebate position established through an existing channel |
| BO-3 | BR-3 | ORD-10 — rebate parameters changed without a release |
| BO-5 | BR-2 | ORD-12 — rebate position reportable within one business day |
| BO-4 | — | **No tolerance yet.** Blocked on the `[TBD]` at §11 |

**BO-4's empty row is the useful one.** An objective with no operational tolerance is either not
operationally relevant or not yet quantified — and which of the two it is has to be recorded, not
inferred. The full chain onward to the SOAP and the acceptance criteria is on the
[traceability matrix](#traceability).

#### Appendix A · Process and system scope ★

The L1–L3 process areas and the systems in scope, each with a named owner. **This is what makes the
ORD sizeable at assignment** — the impact counts that set S/M/L are read off it, and it seeds the
ORD's impact register.

| Kind | In scope | Owner |
|---|---|---|
| L1–L3 process | Order-to-Activate — appointment booking, field dispatch, attendance capture | Process owner, Field Operations |
| L1–L3 process | Bill-to-Cash — rebate determination and application | Process owner, Billing |
| L1–L3 process | Customer contact and complaint handling | Process owner, Customer Care |
| System | Workforce management platform | Application owner, Field Operations |
| System | Billing engine | Application owner, Billing |
| System | CRM / customer record | Application owner, Customer Care |
| System | Contractor portal | Application owner, Field Operations |
| System | Customer notification service | **Unowned — open** |

**The unowned system is recorded, not resolved.** The notification service appears in the estate
with its owning team vacant. That is a finding about Acme's ownership records rather than about this
change, and it is raised at sign-off — a referral needs a recipient, and there is not one.

**Sizing read from this appendix:** three business units, five objectives, **eight stakeholders** —
the §5 register's nine rows less the affected-customer group, which is not consulted directly — and
nine impacted workflows and systems once the ORD's register is populated
(three L1–L3 process areas resolving to four L4 workflows, plus five systems) — **Medium**.

#### The handoff gate, applied to this document

Run against the [gate above](#brd). This is what a real assessment looks like — not a clean sheet.

| # | Verdict | Evidence |
|---|---|---|
| BH-1 | **Met, with one declared gap** | BO-1, BO-2, BO-3 and BO-5 each carry a baseline, a target and FY27 Q2. **BO-4 carries `[TBD]` with Regulatory Affairs and 2026-08-15** — a declared gap under the rule above: owned, dated, and not the objective the case rests on, with BO-1 fully quantified. It propagates rather than vanishing — §12 leaves its row empty, and so does the [traceability matrix](#traceability) |
| BH-2 | **Met** | No objective or business requirement names a system, workflow or figure. This BRD's §8 states three outcomes |
| BH-3 | **Met** | §9 — consumer contract cl. 14.3 / 14.5 / 14.6, field services agreement §9, and the billing-cycle boundary, each with its operational weight stated |
| BH-4 | **Met, with one declared gap** | §11 — three consequences, two sourced to the contract and INC-5012. The third is BO-4's, `[TBD]` with Regulatory Affairs and 2026-08-15; it is the same gap as BH-1's, propagating from the objective to its cost case |
| BH-5 | **Met** | §5, nine rows with interest and role |
| BH-6 | **Met** | Three GMs named — Customer Care, Field Operations, Billing |
| BH-7 | **Met** | §7, with the out-list explicit and the phasing reason stated |
| BH-8 | **Unowned gap** | Appendix A is complete **except the customer notification service, which has no owning team.** There is nobody to carry it, so it is neither met nor owned — the case the third outcome exists for |
| BH-9 | **Met** | §12, with BO-4's row explicitly blank rather than omitted |
| BH-10 | **Met** | BR-1 – BR-3 hold no workflow, system or figure |

> **Outcome: Accepted with an unowned gap.** The bar is met — BH-1 and BH-4 carry one declared gap
> between them, owned by Regulatory Affairs and dated. BH-8 is the unowned one: it is carried
> forward into the ORD as entry criterion **E9 — Partial** and as **IMP-07**, raised with the
> approving GMs at sign-off rather than referred, and it stays open until someone accepts it.
> **That it stayed open is the finding** — about Acme's ownership records, not about this change.
>
> **Note what neither gap did.** Neither moved the maturity tier. The
> [worked example ORD](#example) commits **Tier B** because both KPPs are Provisional — the tier is
> the weakest status carried by any KPP-bearing requirement, and an unowned system in the estate is
> not one. A recorded gap drives the tier only where it reaches a KPP. Recording it and tier-driving
> it are two different things, and conflating them is how a gate becomes theatre.

---

*Standard of record: BABOK v3. Companion pages: the [ORD Intake and Maturity Standard](#purpose)
for operational demand, the [worked example ORD](#example) for what BRD-2026-041's objectives become
as tolerances, the [traceability matrix](#traceability) for the chain end to end, and the
[PRD standard](#prd) for the functional half — defined, and not adopted in this chain.*

---

<!-- from reference/ord-intake-standard.md -->

**Step 1 — size the change from the BRD.**

| Size | Indicators | Effort |
|---|---|---|
| **S — Small** | One business unit; 1–3 business objectives; change to an existing service; ≤4 stakeholders; **≤5 impacted workflows and systems combined**; no cross-program dependency; rules already settled | ~4 effort days |
| **M — Medium** | 2–3 business units; 4–6 objectives; ≤8 stakeholders; **6–15 impacted workflows and systems**; one or two cross-program dependencies; some rules to resolve | ~6 effort days |
| **L — Large** | Multiple business units or programs; novel capability; material regulatory or contractual exposure; >8 stakeholders; **more than 15 impacted workflows and systems, or systems owned by different programs**; cross-program conflicts requiring adjudication | ~9 effort days |

**On the impact counts.** They are indicative bands in the same spirit as the stakeholder and objective counts, not measured thresholds. At assignment the count is an estimate read off the BRD's L1–L3 scope; it firms up during document analysis on effort days 2–3, which is the first point at which the register is populated rather than guessed. **A count that lands in a different band than the one assumed is a re-size trigger**, not a variance to absorb: re-read §4.1 and §4.7.3 from the days remaining, and record the change under §3.3. Owner count matters as much as item count — fifteen workflows under two process owners is a smaller elicitation than six under six.

These are **collection effort only** — the §4.5 sequence. Refinement is deducted separately (§4.3) rather than carried inside them, because it behaves differently and is present on some engagements and not others.
