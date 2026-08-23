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

### Requirement register

Every operational requirement, in every section. The subsection heading supplies the ISO/IEC 25010
characteristic, so there is no characteristic column.

| BRD# | ORD# | Requirement Description | MoSCoW | Timing | Source | Delivery Agent | Verification | Capability | Epic | Comments |
|---|---|---|---|---|---|---|---|---|---|---|
| [BO-N / BR-N or —] | ORD-NNN | [declarative end state, carrying its own value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

- **`BRD#` holds the IDs the BRD actually emits** — `BO-N` for a business objective, `BR-N` for a
  business requirement, per the namespace table below. **Never `BRD-NN`**: no skill produces that
  form, so a row carrying it traces to nothing. `BRD-NNNN` remains valid as a *document* reference
  (e.g. `BRD-2026-041`) and is not an item ID.
- **The threshold lives inside `Requirement Description`, not in its own column.** Under
  [language.md](language.md) the requirement is a declarative end state, so the number is part of
  the sentence: *"Service availability is 99.9% per calendar month."* A separate Threshold column
  would restate it, which the view rule below forbids.
- **`Verification` is required.** `/write-ac` rejects an operational criterion with no measurement
  method, so a blank here breaks the downstream skill.
- **`Capability` and `Epic` are written back by `/write-ac`**, not filled at authoring time. They
  are `—` until it runs.
- **`Comments` never holds a commitment.** It is a refinement scratch column; if a statement binds,
  it belongs in `Requirement Description`.
- Mark a Key Performance Parameter by prefixing `Requirement Description` with **[KPP]**.
- Mark a row governed by [ai.md](ai.md) by prefixing `Requirement Description` with **[AI]**; where
  both apply the order is **[KPP][AI]**, always. See [ai.md](ai.md) § *Marking an AI-governed row*.

**MoSCoW and [KPP] are orthogonal.** A KPP is a program-failure threshold; a Must is required for
this release. Most KPPs are Musts; most Musts are not KPPs. Keep both.

**`Should` and `Could` as MoSCoW values are not a `language.md` violation.** That rule bans hedging
verbs inside requirement *text*; a controlled enum in a priority column is unambiguous. Do not
"correct" it.

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

| ID | Assumption | Status | If false | Owner |
|---|---|---|---|---|
| ASM-NNN | [declarative statement] | Unvalidated / Validated / Falsified | [consequence] | [role] |

`If false` is mandatory — an assumption with no stated consequence is a note, not an assumption.

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
- A subsection with **no** requirement is omitted from the body entirely, and listed as one row
  in a single **Coverage Gaps** table at the end of the section.

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
