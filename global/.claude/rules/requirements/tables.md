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
| [BRD-NN or —] | ORD-NNN | [declarative end state, carrying its own value] | Must | [when live] | [BU, Function, Name] | [Department] | [how proven] | [CAP-NN or —] | [EPIC-NN or —] | |

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

**MoSCoW and [KPP] are orthogonal.** A KPP is a program-failure threshold; a Must is required for
this release. Most KPPs are Musts; most Musts are not KPPs. Keep both.

**`Should` and `Could` as MoSCoW values are not a `language.md` violation.** That rule bans hedging
verbs inside requirement *text*; a controlled enum in a priority column is unambiguous. Do not
"correct" it.

> **PRD requirements do not yet use this schema.** `/write-prd` keeps user stories with
> Given/When/Then criteria pending a decision on that form. Until then the PRD's requirement store
> is the exception to the table-first rule, and it is a known gap — not a licence for free text
> elsewhere.

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

**Escalation:** Forge's RAID log is Risks, Actions, Issues, Decisions — it has **no Assumptions
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
| `PRD-NNN` | Functional requirements / user stories | `/write-prd` |
| `ORD-NNN` | Operational requirements | `/write-ord` |
| `AC-NNN` | Acceptance criteria | `/write-ac` |
| `ASM-NNN` | Assumptions | whichever document records it |
| `DEP-NNN` | Dependencies | whichever document records it |

All are flat and sequential in order of first appearance, never encode a theme or characteristic,
and are never reused once retired.

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

- Never write a binding statement as free-text prose, in any section.
- Never give a table row a commitment without a stable ID.
- Never invent a column set where a canonical schema exists.
- Never restate a value in a second table — reference the ID and mark the table as a view.
- Never scaffold an empty table per absent subsection — use the Coverage Gaps table.
- Never use a single-letter ID prefix (collides with `/raid`).
- Never silently drop a gap to keep a document looking complete.
