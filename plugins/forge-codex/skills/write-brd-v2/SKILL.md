---
name: "write-brd-v2"
description: "Author a concise, outcome-focused Business Requirements Document that secures alignment and funding for a change — why change is required, what success looks like, and the boundaries of the initiative — without describing solution design. Grills one question at a time where context is thin, writes the BRD to docs/brd/, and points §8 Stakeholder Requirements and §9 Traceability at the separate -SR.md file $write-stakeholder writes. Shaped to clear the BH-1 – BH-4 bar, checked by $review-brd-v2. Use when a lean funding-alignment BRD is needed from an idea, brief, transcript or conversation, or when $write-brd-v2 is run."
metadata:
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write BRD v2

Create a concise, outcome-focused Business Requirements Document.

The BRD exists to **secure alignment and funding for change**. It defines why change is required,
what success looks like, and the boundaries of the initiative. It does not describe solution design.

Execution mode: **[HITL]** — elicit one question at a time, then write behind a confirmation gate.

**Where this sits** (context for the author, not part of the output):

| Step | Activity | Skill |
|---|---|---|
| 1 | BRD created | **this skill** |
| 2 | Stakeholder requirements and traceability, in a separate `-SR.md` file the BRD points to | `$write-stakeholder` |
| 3 | Business solution requirements — functional and non-functional | `$write-prd`, `$write-ord` |
| 4 | Technical specifications — SOAP, SAR, technical epics | downstream |
| — | Readiness review — after this skill for stakeholder readiness, after step 2 for ORD readiness | `$review-brd-v2` |

Stakeholder needs are usually not known at this stage. They are added later by `$write-stakeholder`.

**Authoring standards** — `standards/language.md` and `standards/tables.md` govern
wording and table form. Where this skill sets a BRD-specific form (the objective table, the `[TBD]`
rule), this skill wins and says so.

---

## Completion criteria

The BRD is complete when:

- A decision maker understands the problem and intended outcome in **under five minutes**.
- Every section contributes unique information. No statement appears in more than one section.
- Scope boundaries are explicit.
- Objectives are measurable, and each one carrying operational exposure has a cost of failure.
- Design principles provide solution guardrails without prescribing implementation.
- The document explains **why** change is required, never **how** the solution is built.

---

## Process

### 0. Gather context

Read every source supplied in full — idea, brief, transcript, notes, existing documents, the
conversation. Extract what each section below needs **before** asking anything.

Then fill the gaps by asking **one question at a time**, highest-impact gap first: the outcome, then
objectives and their figures, then scope, then constraints. After 5–7 exchanges, synthesise and check
in before continuing (see Failure Modes).

**Completion:** every section below has content, or a `[TBD]` that carries an owner and a date.

### 1. Define the Current State

Describe how work operates today.

**Completion:** the current operating model is understandable. No future-state or solution content
appears here.

### 2. Define the Problem

State why the current state is unacceptable as **one summarising sentence** at business altitude —
what the enterprise loses, not where the symptom was noticed. Then list the specific pain points as
simple dot points, drawn from:

inefficiencies · duplication · customer impacts · operational impacts · compliance impacts · cost
impacts

**Completion:** the reader understands why change is required, and the problem exists independent of
any proposed solution.

> **Altitude test.** A problem sentence naming a system, a screen or a team's tooling describes a
> symptom. Ask what the enterprise loses — that answer is the problem; the symptom is a pain point.

### 3. Define the Need

Describe the business **capability** required. Never describe screens, integrations, workflows or
technical approaches.

**Completion:** the need describes a capability, not an implementation.

### 4. Define the Outcome

Describe what success looks like once the need is met.

**Completion:** the outcome is observable and aligns directly to the problem.

### 5. Define Objectives

Create measurable business objectives. They focus the project and confirm its success.

| ID | Objective | Baseline | Target | By |
|---|---|---|---|---|

- **Each objective states an outcome**, never a solution, and is measurable. If it names a feature,
  system, vendor or technology, rewrite it as the business metric it moves.
- **`By`** is the target date — a date, a month or a quarter.
- **Sort by `By`**, then by relative importance.
- **IDs are `BO-N`** — `BO-1`, `BO-2` — single-digit sequential per `standards/tables.md`, never re-padded.
- **Unique and independent.** Never carry the inverse of an existing objective — not both "decrease
  invalid submissions" and "increase valid submissions".
- **Atomic.** One measure per objective. An "and" that joins two record types, business concepts or
  metrics is two objectives.
- Consider targets for: reduction · consolidation · adoption · visibility · compliance · cost or
  revenue · metrics and performance.
- **At least one objective is fully quantified** — baseline, target and date with no `[TBD]` — and
  the objective the change is funded against carries no `[TBD]`. Without these two, the BRD cannot
  clear BH-1 at `$review-brd-v2` however well-owned its gaps are.

**Completion:** every objective has a baseline, a target and a timeframe, and success can be assessed
objectively.

### 6. Define the Cost of Failure

For each objective carrying operational exposure — a customer, contractual, regulatory, financial or
operational consequence if it is missed — state what is lost.

| Objective | If not met | Basis |
|---|---|---|
| BO-N | [the consequence, quantified where the source quantifies it] | [contract clause, regulation, incident, named obligation] |

- This is **forward-looking** — what is lost if the objective is missed. The problem's pain points
  are what is lost today. Never restate one in the other.
- An objective with no exposure carries no row. Say why at the confirmation gate.

**Completion:** every objective with exposure has a row with a basis, or a `[TBD]` with an owner and a
date.

### 7. Define Scope and Boundaries

The single source of truth for initiative boundaries. It describes the initiative, never the BRD
document's contents.

Include capabilities, processes, teams, systems, customers and domains. Exclude project documentation
content.

**In Scope**

| Area | Boundary / Treatment | Owner |
|---|---|---|

**Out of Scope**

| Area | Boundary / Treatment |
|---|---|

- `Owner` names who owns that process, team or system in scope. Unknown is `[TBD]` with an owner and a
  date; nobody to own it is **Unowned — open**.
- **Phasing.** Where the change is delivered in phases, state which phase this BRD covers, and list
  each deferred item in Out of Scope with the phase named. One BRD per phase is recommended for a
  large change, because one objective row carries one target and one date.

**Completion:** a reader can determine whether a capability, process or system is included without
consulting another section.

### 8. Define Design Principles and Constraints

Two different things, held in two tables.

**Design principles** describe how solutions are evaluated and the desired qualities of the operating
model. They may not be known up front.

| ID | Principle |
|---|---|

- IDs are `DP-N`. Each principle is one sentence under 20 words.
- Good examples: single approach · OOTB first · no Delivery Partner or Retail Service Partner impact ·
  minimise manual effort and swivel-chair context shifting · clear accountabilities with minimum
  handoffs · reuse existing information · rationalise duplicate capabilities.
- Never describe detailed functionality or process. A principle that prescribes implementation is
  moved to Scope or cut.

**Constraints** are givens the change cannot move. Ask against all six categories and record every
answer, including **None found** — a category never asked is indistinguishable from one answered
empty unless the answer is written down.

| Category | Constraint | Source |
|---|---|---|
| Regulatory and statutory | [the given, or **None found**] | [regulation, clause] |
| Contractual | | |
| Time | | |
| Financial | | |
| Organisational | | |
| Prior commitment | | |

Constraints carry no local ID — the source identifies them.

**Completion:** principles guide solution decisions without prescribing implementation, and every
constraint category carries an answer.

### 9. Define Assumptions

Conditions believed true but not yet verified.

| ID | Assumption | Validation owner | Impact if false | Confirm by | Status |
|---|---|---|---|---|---|

- IDs are `ASM-NNN`. `Validation owner` is the domain or business unit owning validation, preferably a
  named individual.
- `Status` is **Unvalidated**, **Validated** or **Falsified**, defaulting to Unvalidated.
- A **Validated** assumption becomes a constraint — move the row to the constraint table with the
  validation as its source.
- A **Falsified** assumption's exposure is raised in the RAID log, and its `R-NNN` is written in
  `Impact if false`.

**Completion:** removing any assumption would materially affect the initiative.

### 10. Define Dependencies

External requirements needed for success.

| ID | External Dependency | Owner | Required For | Needed by | Status |
|---|---|---|---|---|---|

- IDs are `DEP-NNN`. `Owner` is the domain or business unit providing it, preferably a named
  individual.
- `Status` is **Open**, **Met** or **At risk**. A dependency no longer needed is deleted, not kept as
  a status.

**Completion:** every dependency sits outside the initiative's direct control.

### 11. Define Stakeholders

The approving GMs, and the teams, stakeholders and SMEs with a material decision or influence on the
requirements.

**Approving GMs** — one row per business unit in scope:

| Team/Business Function | GM Name | Approval Date |
|---|---|---|

**Stakeholders:**

| Team/Business Function | Role | Operational Owner | SME/Representative | Engagement |
|---|---|---|---|---|

- `Role` is **Sponsor**, **Consulted** or **Affected**.
- `Engagement` is **Engaged**, **Not yet engaged**, **Unavailable until [date]** or **No SME
  nominated**. A blank is not a value.
- The operational owner is typically an Executive Manager or Senior Manager.
- Ask whether the change reaches each department — customer-facing, operations, product, finance,
  legal and regulatory, technology and data — and record each one it reaches. Never infer a person
  from an org chart; an unknown name is a `[TBD]`.
- Every business unit in In Scope has an approving GM row. A unit with no row is the gap to fix.

**Completion:** every stakeholder with a material decision or influence on the requirements is
identified, or declared as a `[TBD]`.

### 12. Confirm, then write

Present a one-screen summary — objectives with their figures, the cost-of-failure rows, scope, open
`[TBD]`s with owners — and wait for confirmation. Then write `docs/brd/[change-name]-BRD.md` in the
output structure below, assigning the Doc ID `BRD-YYYY-NNN` now. Write §8 and §9 as pointers to
`docs/brd/[change-name]-SR.md` — the BRD never holds stakeholder requirements itself.

Before saving, run the verification gate. After saving, name `$write-stakeholder` as the next step and
`$review-brd-v2` as the readiness review — it checks the BRD alone now, and both files once the
`-SR.md` file exists.

---

## Rules

### Single source of truth

A concept appears once. If it already exists in an objective, a scope row, a principle, a
constraint, an assumption or a dependency, it is not restated elsewhere — refer to it by ID.

- **Scope owns boundaries.** Never create a requirement solely to control scope.
- **Principles own constraints on design.** Never create a requirement solely to influence the
  solution.
- **Objectives own outcomes.** Never duplicate an objective as a business requirement.

### No solution design

Exclude integrations, APIs, workflows, system interactions, data mappings, UI design and
implementation approaches — unless one is necessary to explain scope.

### No project management content

Exclude risks, issues, RAID management, delivery plans, implementation tasks and definitions of done.
They belong outside the BRD. A risk is raised in the RAID log and cited by its `R-NNN` only where an
assumption or dependency rests on it.

### Remove requirement sprawl

A business requirement that merely restates an objective, a scope statement or a design principle is
removed.

### Sourced content only

- **Never invent a figure, a consequence, an owner or a date to fill a cell.** Write
  `[TBD — @owner, YYYY-MM-DD]` instead, where `@owner` is who closes the gap and the date is when.
- A `[TBD]` with no owner is written **`[TBD — Unowned]`** — that is a finding, not a blank.
- A `[TBD]` missing its date is a hole. Ask for the date before writing it.
- Never add narrative or reasoning behind the output. Never name or cite informal sources — meeting
  transcripts, chats, emails — and never add hyperlinks or footnotes to them. Formal sources that
  bind the change (a contract clause, a regulation, a policy) are cited in the `Source` or `Basis`
  cell where they belong.

---

## Output structure

```markdown
---
status: Draft
doc_id: BRD-YYYY-NNN
Executive Sponsor:
Author:
Target Horizon:
Indicative Go Live: dd mmm yyyy
Phase: [n of m, or "single release"]
Version: "0.1"
tags:
---
# <Project Name> Business Requirements Document

## 1 Executive Summary
**Current State:**
**Problem:**
**Impacts:**
**Need:**
**Outcome:**
**Decision Sought:**

## 2 Objectives
### 2.1 Business Objectives
### 2.2 Cost of Failure

## 3 Stakeholders
### 3.1 Approving GM Register
### 3.2 Business Owners & SMEs

## 4 Scope and Boundaries
### 4.1 In Scope
### 4.2 Out of Scope

## 5 Design Principles & Constraints
### 5.1 Design Principles
### 5.2 Constraints

## 6 Assumptions

## 7 Dependencies

## 8 Stakeholder Requirements
Held in `[change-name]-SR.md` §1–§2, written by $write-stakeholder.

## 9 Traceability
Held in `[change-name]-SR.md` §3 — SR to BO, and BO to the ORD tolerance expected to quantify it.
```

- **Problem** is the one summarising sentence. **Impacts** is the dot-point pain points.
- **Decision Sought** is the decision this BRD asks for and over what scope — typically funding or
  endorsement to proceed. If it cannot be filled, the document is a briefing paper, not a BRD; say so.

---

## Verification gate

Before saving, check each line and fix what fails. Never save a BRD that fails a line silently.

| Check | Fails when |
|---|---|
| **Measurable** | An objective lacks a baseline, target or `By` — "an objective without metrics is a wish" |
| **Quantified core** | No objective is fully quantified, or the funded objective carries a `[TBD]` |
| **Outcome, not solution** | An objective names a feature, system, vendor or technology |
| **Atomic, not inverse** | An objective joins two measures, or inverts another objective |
| **Cost of failure** | An objective with exposure has no §2.2 row |
| **Principles stay principles** | A principle prescribes implementation — move it to Scope or cut it |
| **Constraints asked** | A constraint category has no answer |
| **GM coverage** | A business unit in §4.1 has no §3.1 row |
| **State it once** | A figure or statement appears in two sections |
| **No invented values** | A cell holds a figure, owner or date the source did not supply |
| **`[TBD]` complete** | A `[TBD]` lacks `@owner` and a date, and is not marked `Unowned` |

---

## Failure Modes

| Condition | Behaviour |
|---|---|
| No context exists, or too little to write | Start from scratch — assume nothing about the project or the knowledge base. Grill the user one question at a time to build the context |
| The grill reveals several projects | Ask: "This feels bigger than one project. Should I split this into separate project files, or keep it in one for now?" |
| An answer contradicts existing knowledge or an earlier answer | Flag it: "Our note says X, but you're saying Y — which is right? I'll update the record." |
| Many questions asked without synthesis | After 5–7 exchanges, check in: "Here's what I've gathered so far — does this match?" before continuing |
| The outcome is unclear — the talk is all problem or all solution | Challenge it: "We've not nailed down the outcome for the business. What would a sponsor expect to be achieved?" |
| The source is a solution pitch — a vendor, a feature, a design | Extract the outcome behind it. Where no business outcome exists at all, say there is no business case to document yet |
| Every objective is `[TBD]`, or the funded one is | Say so before writing — the BRD will not clear `$review-brd-v2`'s bar, and no downstream document repairs an unquantified case |
| No cost of failure is derivable for an objective with exposure | Ask for it as an open question. Never invent a consequence, and never drop the objective |
| No approving GM is known for a unit in scope | Write the row with `[TBD — @owner, date]`. Never infer the approver from an org chart |
| The source carries risks | Route them to the RAID log. Never write a risk table into the BRD |
| The source carries stakeholder needs | Hold them for `$write-stakeholder`, which writes them to the `-SR.md` file. Never write them into the BRD |
| A BRD already exists at the target path | Stop: "A BRD already exists at docs/brd/. Confirm overwrite or provide a new name." |
