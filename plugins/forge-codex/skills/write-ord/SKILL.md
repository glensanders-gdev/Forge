---
name: "write-ord"
description: "Synthesize a call transcript, document, conversation context, or structured notes into a business-focused, demand-side Operational Requirements Document (ORD) — executive summary first, quantified business tolerances organised by ISO/IEC 25010:2023 quality characteristics, with decisions, assumptions and dependencies as first-class registers, and business rules and reporting requirements in their own appendices. Use when the user runs $write-ord, provides a transcript or document to convert into an ORD, or wants to formalise operational requirements from a conversation."
metadata:
  version: 3.0.0
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write ORD

Synthesize source material into a structured **demand-side** Operational Requirements Document.
Runs in two phases with a mandatory confirmation gate between them.

**Two files are written, one reviewed.** The ORD is for its human reviewer; beside it goes an **LLM
companion**, `docs/ord/[system-name]-ORD.llm.md`, generated from the saved ORD for a language model
to consume. Run with `--llm-only [ORD path]` **[AFK]** to regenerate the companion from an existing
ORD without running either phase.

**Business-focused means the core ORD explains what outcome is required — not how it is controlled.**
Business rules (§13) explain how decisions are made; the Reporting Requirements Appendix (§14)
explains what reporting consumers need; the design response explains how it is implemented. Every
requirement passes one test: *could an executive understand it without understanding reporting,
governance, architecture or implementation?* If not, simplify it and move the detail to an appendix.

**Demand-side means the ORD states quantified business tolerance and never the technical target that
satisfies it.** *"Service is restorable within one business day, beyond which obligation X is
breached"* is this document's business; *"RTO 4h"* is the design response's. The ORD precedes
solutioning — architecture, security, operations and service management answer it downstream and do
not contribute to it. Stating a technical target pre-empts the review the document exists to inform.

See [REFERENCE.md](REFERENCE.md) for the demand-side scope rule, the status taxonomy, the KPP guide
and the deviation map, and for the index to [TAXONOMY.md](TAXONOMY.md) (ISO/IEC 25010 and 25059),
[ELICITATION.md](ELICITATION.md) (lenses and extraction) and [TEMPLATE.md](TEMPLATE.md) (the ORD
template and worked register extract).

**Authoring standards — read before writing any requirement:**
- `standards/language.md` — wording, voice, banned modals, demand-not-design
- `standards/tables.md` — table-first presentation, canonical schemas, ID namespaces
- `standards/ai.md` — **conditional.** Fires where a delivered component's output
  for a given input is not fully determined by written logic — a trained model, an LLM call, a
  retrieval-augmented pipeline, an agent, or a third-party AI service consumed as an API. Supplies
  the evaluative criterion, the `EVL-NNN` / `MDL-NNN` schemas, and the ISO/IEC 25059 class map.
- `standards/reporting.md` — **conditional.** Fires where the change creates,
  alters or retires a measure somebody reports. Supplies the measure definition, the `DAT-NNN`
  schema and the ISO/IEC 25012 data-quality anchor.

- `standards/llm-companion.md` — the form of the LLM companion written beside
  the ORD in Phase 2.

Apply both trigger tests in Phase 1 — a wrong "no" silently skips a whole ruleset. They are
independent: a change can fire both, one, or neither.

These are authoritative and shared with `$write-prd`, `$write-reqs` and `$write-ac`. Never restate
them here.

**If an authoring standard above cannot be read, stop and name it.** The register and criteria
schemas, the modal ban and the scenario values live there and nowhere else. Drafting them from
memory produces a document that looks conformant and is not, and no reviewer can see the
difference. An unreadable standard is a blocked run, never a degraded one.

---

## Phase 1 — AFK Ingest [AFK]

Runs unattended. Extracts and classifies all operational requirements from source material.

Extraction judgement — what to split, what to consolidate, what to strip from a source
statement — is in [ELICITATION.md](ELICITATION.md) § *Extraction*. The analysis lenses that decide
**what to look for** are in § *Elicitation lenses*, and each is gated by its own trigger.

### Inputs accepted

- Call transcript (paste or file path), meeting or interview notes
- Existing document (Word export, PDF text, markdown)
- Current conversation context
- Any combination of the above

Where available, also read: the BRD and its version, scope and out-of-scope statements, business
objectives, stakeholders, dependencies, known business rules, current-state processes, the target
date and the milestone it serves, and any Product Manager prioritisation already given.

**Missing inputs are recorded, never inferred** — as an entry-position row (§12), a gap, an
assumption with an owner and a confirm-by date, or a decision item.

### Phase 1 Process

0. **Check for a joint-authoring brief.** When invoked by `$write-reqs`, a brief accompanies the
   invocation carrying (a) the ORD-bound half of the classified source and (b) the NFR citations the
   PRD makes. Treat the brief's half as the **extraction scope** and do not re-extract functional
   needs already routed to the PRD. Absent a brief, this is a standalone run; proceed from step 1.
1. Read all provided source material in full.
2. Read the BRD if one exists (`docs/brd/`) — capture the `BO-N` objectives this ORD traces up to,
   and the `BR-N` business requirements each objective runs through. If absent, note it. **Do not
   read the PRD** — a standalone ORD is a *sibling* of the PRD, not its child. Joint authoring is
   the separate `$write-reqs` workflow.
3. Extract every statement implying an operational need — performance, availability, support
   tolerance, recovery, compliance, interfaces, security, observability. **Capture the operational
   purpose with each** — the outcome it serves, the problem it prevents, the consequence if unmet,
   and who benefits. Purpose lands in the objective it traces to and in the breach clause the
   tolerance already carries; it never becomes a second commitment or a rationale column, and a
   requirement is never restated as a user story.
4. **Rewrite each as a business tolerance as you extract.** Where the source states a technical
   target, capture the underlying business tolerance and record the technical figure as the
   source's wording, not as the requirement. Where the tolerance behind it cannot be recovered from
   the source, that is a gap for the gate — not a licence to keep the technical figure.
5. **Tag provenance and status as you extract.** Record the source evidence (contract clause,
   obligation, incident record, or Business Unit / Function / Name), the named business owner, and
   the `Status` — `Committed`, `Provisional` or `Assumed` — per REFERENCE.md § *Requirement status
   taxonomy*. Also capture, where stated: MoSCoW priority and the operational objective served.
6. **Extract the operational problem statements and the operational objectives.** Problems are
   the operational drill-down of the BRD's §3 — specific, and stated so the solution is unknown.
   No ID and no threshold: an `OBJ-NNN` holds the measurable form. Each problem traces to a `BO-N`;
   each `OBJ-NNN` (outcome, baseline, target, target date) names the problem it closes. Every
   requirement traces to an objective. A missing baseline or target is a `[TBD]`, never an
   invention. A problem naming a mechanism, product or component has become a solution — rewrite it.
7. **Extract the impact register** (`IMP-NNN`) — the L4 workflows and current-estate systems the
   change touches, each with a named owner and a `Treatment`. The enum is closed —
   `Addressed` / `No change required` / `Out of scope` — and it answers what *this document* does
   about the impact, never what becomes of it. *Migrated*, *decommissioned* and *extended* are
   design dispositions and are refused. Unstated treatment is `[TBD]`, not a guess.
8. **Extract the operational actor register** — the users, systems and external parties the
   operational process runs through, each with its role and owner. `Kind` is `User` / `System` /
   `Party`; `Party` is the subject a cross-party consequence names. No ID — the actor name is the
   key. **Governance roles are not actors**: the SME who informed the document and the business
   owner who approves it go to the header and to E2/E3. Where no stakeholder list arrived, `Owner`
   carries `[TBD]` with a confirm-by date per actor.
9. **Extract referred requirements** (`REF-NNN`) — content raised during elicitation that this ORD
   will not deliver: functional detail, staffing, training, policy, commercial or process-design
   work. Record the resolver group and the named recipient. `Resolver group: None in chain` is a
   real answer and the row stays open.
10. **Extract business rules** (`BRL-NNN`) — every classification, eligibility, cut-off,
   calculation, restatement, reconciliation, exception, retention or rule-versioning statement —
   into the three groups in `standards/tables.md` § *Business rule*: Classification, Reporting, Governance.
   **Where a source statement mixes an outcome with its control logic, split it**: the outcome
   becomes the requirement, the logic becomes the rule it cites. Each rule carries an owner, a
   status and the requirements it affects. Where a `$write-reqs` brief shows the PRD already states a
   rule, cite the PRD's ID rather than restating it.
   **Extract decisions and related initiatives** too: every unresolved business decision becomes a
   decision item (never an assumption inside a requirement), and every adjacent programme the source
   names is tested against `standards/tables.md` § *Related initiative* — dependency, related initiative,
   referred requirement or out-of-scope item.
11. Classify each extracted statement against the ISO/IEC 25010:2023 nine characteristics. Flag
    statements too vague to classify.
12. Identify gaps at **sub-characteristic** level — check every sub-characteristic in the
    TAXONOMY.md taxonomy. Characteristic-level checking hides gaps inside a partially-covered
    characteristic. Also identify BRD objectives with no resulting operational requirement.
13. **Draft scenarios** (`SCN-NNN`) for each requirement — at minimum a Sunny Day. **Where the
    requirement is a determination, measurement or eligibility decision, draft both a Favourable and
    an Adverse Sunny Day row**: a capability that runs correctly and returns bad news is not a
    failure, and what must be true then is a separate obligation that is routinely left unstated.
    Flag any determination requirement carrying only a Favourable row.
14. Extract **assumptions and dependencies** as first-class items. Carry `$idea` assumptions forward
    with their Status. Every assumption cited as a requirement's `Source` needs a named owner and a
    confirm-by date.
15. Identify **Key Performance Parameters** — requirements whose failure means the capability is
    unfit for purpose, not merely degraded. State each as a business-failure threshold carrying
    **threshold and objective** as two labelled values.
16. **Run the applicable elicitation lenses** — ELICITATION.md § *Elicitation lenses*. Apply only
    the lenses whose trigger is present in the source; lens 1 (operational purpose) and lens 14
    (consistency) are unconditional. A lens finds a question, and its output is a register row only
    where the source carries the tolerance and its evidence — otherwise a `[TBD]`, a gap, an
    explicit assumption, a decision item, or a referred requirement. **A lens that finds nothing is
    reported as *not evidenced*, never as satisfied.**
17. **Apply both conditional trigger tests** — `standards/ai.md` and `standards/reporting.md`. Answer each explicitly in
    the Phase 1 Summary; do not leave either unasked. Judge the **delivered solution**, never the
    toolchain that builds it. Where `standards/ai.md` fires, classify against the ISO/IEC 25059
    sub-characteristics too. Where `standards/reporting.md` fires — reporting, KPIs, SLAs, performance metrics
    or compliance reporting are affected — check every class in its map, **identify the reporting
    consumers** by class (regulatory, contractual, operational, management, executive, audit) even
    where their process does not change, draft a measure definition per reported measure, and
    extract the `DAT-NNN` attributes, dimensions and data elements with `Availability` —
    `Unconfirmed` unless the source confirms the element exists. Where any element is `New` or
    `Unconfirmed`, raise a candidate reporting-data requirement at the gate.
18. **Detect competing methodologies** — where current operational practice differs from
    contractual, regulatory or documented reporting practice, preserve both, and raise it for the
    gate as a decision item. Never file a methodology conflict as an assumption.
19. **Run the consistency sweep** — ELICITATION.md § *The consistency sweep*. Consolidate
    duplicates into one authoritative statement. Never resolve a conflict: preserve both documented
    positions, name the affected requirements, and raise a decision item.
20. **Apply the executive-altitude test** to every extracted tolerance — `standards/tables.md` § *Requirement
    register*. A tolerance that fails it is rewritten to its outcome, with the detail routed to a
    `BRL-NNN` rule or a §14 definition. List each rewrite in the summary.
21. **Compute the document tier** — the weakest `Status` carried by any KPP-bearing requirement.
22. Present the Phase 1 Summary and pause.

### Phase 1 Summary Format

```
## ORD Ingest Summary — [System / Project Name]

### Source Material Processed
- [Each source, including the BRD if found]

### Entry Position
| # | Input | Status at assignment |
|---|---|---|
| E1–E9 | [per TEMPLATE.md §12] | Received / Partial / Absent |

### Operational Problems
| Problem | Traces to BO-N | Closed by OBJ# |
|---|---|---|
Problems stated as a solution rather than a problem: [list, or "none"]

### Operational Objectives
| OBJ# | Objective | Baseline | Target | Target Date | Traces to |
|---|---|---|---|---|---|

### BRD Objectives (origin of scope)
| BO-N | Business need | Covered by this ORD? |
|---|---|---|

### Extracted Requirements by ISO/IEC 25010 Characteristic
| Characteristic | Requirements | KPP candidates | Committed / Provisional / Assumed | Vague |
|---|---|---|---|---|

**Document tier:** [weakest status on any KPP-bearing requirement]

### Demand-side rewrites
| Source wording (technical target) | Business tolerance extracted |
|---|---|
[or "none — source stated demand throughout"]
Technical figures whose underlying tolerance could not be recovered: [list, or "none"]

### Trigger — `standards/ai.md`
**Fired:** Yes — [components] | No — [why]
[Where fired:] 25059 sub-characteristics engaged · EVL/MDL candidates

### Trigger — `standards/reporting.md`
**Fired:** Yes — [the reported measures] | No — [why]
[Where fired:] data elements identified · reconciliation classes checked

### Scenarios
Requirements with only a Favourable Sunny Day scenario: [list — each needs an Adverse row, or a
reason it is not a determination]

### Business Rules (§13)
| BRL# | Group | Rule type | Required decision | Rule | Status | Owner | Affects |
|---|---|---|---|---|---|---|---|
Rules cited from a PRD in the chain: [list, or "none"]

### Executive-altitude rewrites
| Source wording (control detail) | Outcome requirement | Detail routed to |
|---|---|---|
[or "none — source stated outcomes throughout"]

### Reporting (where `standards/reporting.md` fired)
| Consumer | Class | Measures used | What moves for them |
|---|---|---|---|
Consumer classes not evidenced in the source: [list — questions for the gate, never inferred]
Data elements `New` or `Unconfirmed`: [list] → candidate reporting-data requirement: [yes / no]

### Decisions
| D-NNN | Decision required | Affects | Owner | Status |
|---|---|---|---|---|

### Dependencies, Related Initiatives, Referred and Out-of-Scope
| Item | Classified as | Why (test from tables.md) |
|---|---|---|

### Impacts, Actors and Referred Requirements
| IMP# | Impact | Kind | Treatment | Owner | Referred |
| REF# | Requirement | Kind | Resolver group | Referred to |

Impacts with no stated treatment: [list — each is a `[TBD]`, never a guess]
Design dispositions found in the source ("migrated", "decommissioned"): [list, or "none"]

| Actor | Kind | Operational role | Owner |
|---|---|---|---|
Actors with no named owner: [count] · Governance roles routed to header / E2 / E3: [list]

### Operational Lens Findings
*Only lenses whose trigger was present are listed. Each row is a finding, not a requirement.*

| Lens | Finding | Destination | Answered by the source? |
|---|---|---|---|
| [lens name] | [what was found, or "not evidenced"] | [ORD row / TBD / gap / ASM / decision / REF] | Yes / No |

Lenses not run (no trigger present): [list]
Requirements whose operational purpose could not be established from the source: [list, or "none"]

### Consistency Sweep
| Finding | Statements involved | Treatment |
|---|---|---|
[or "no duplicates, conflicts, inconsistent state names or superseded statements found"]

### Competing Methodologies
| Methods in conflict | Affected requirements | Decision needed |
[or "none identified"]

### Coverage Gaps
Sub-characteristics with no source material: [list]
Listed once in §7.10 — not scaffolded as an empty table each. All nine characteristics still appear.
BRD objectives with no resulting requirement: [list, or "none"]

### Assumptions and Dependencies
| Carried from | Assumptions | Dependencies | Missing owner or confirm-by |
|---|---|---|---|

### Vague Statements Requiring Clarification
- "[Quote]" — needs: [missing detail]

### Proposed System Name
[Inferred, or flagged unknown]

### Executive Summary — draft points
Problem · outcome · what is changing · what is not changing · major unresolved decisions — one line
each, for the human to correct before Phase 2.

---
Confirm to proceed to Phase 2, or provide corrections and gap-fills before I write the ORD.
```

---

## Phase 2 — HITL Write [HITL]

Runs after the human confirms the Phase 1 summary. Writes the ORD using the template in
[TEMPLATE.md](TEMPLATE.md).

### Phase 2 Process

1. Incorporate all corrections and gap-fills from the Phase 1 confirmation.
2. Write the ORD following TEMPLATE.md. **All eighteen sections appear, in order**;
   a section with nothing to state says so in one line. **All nine characteristics appear at
   §7.1–7.9**; a characteristic with nothing to state says so explicitly. §4.2 always names
   staffing, infrastructure and the support model as out of scope.
3. **Assign stable IDs** — `ORD-NNN`, `OBJ-NNN`, `SCN-NNN`, `IMP-NNN`, `REF-NNN`, `BRL-NNN`,
   `ASM-NNN`, `DEP-NNN`, flat and sequential in order of first appearance, never reused. The ID
   never encodes the characteristic — the subsection heading supplies it. **This document owns
   `EVL-NNN` and `MDL-NNN`**; resolve every `[EVL-TBD]` the PRD left behind and write the real ID
   back into the PRD criterion.
4. **Write every requirement per the shared rules.** A complete row is a declarative
   `Business Tolerance` carrying its own quantified value, an active verb-first
   `Requirement Title`, a `Ver`, a `Status`, a named `Owner`, and a `Source`. The up-link to its
   objective and its BRD objective lives once, at §11 — never as a register column. A KPP carries
   threshold and objective as two labelled values. Where source material gives no value, write
   `[TBD — source: "quoted vague statement"]` — never invent one, and never leave a cell blank in
   place of a TBD: a blank is indistinguishable from an oversight, a TBD with an owner and a date
   conforms to 29148.
5. **Every binding statement in §7.1–§7.12 is a row with an `ORD-NNN` ID**, and every decision,
   assumption, dependency, referred requirement and business rule is a row in its own register.
   §7.13 is a **view**: it cites existing IDs and introduces no new values.
6. **Write §2–§6 for the business reader.** §3 carries the operational problems, each tracing to a
   `BO-N` and each named by the `OBJ-NNN` that closes it. §2.4 is the target operational state — a
   **view of §6**, outcomes only, no mechanism; a sentence that would change when architecture
   picks a different option does not belong. §4.4 is the actor register, governance roles excluded.
   State the structural deviation in the header's `Conformance` line.
6a. **Write §13 and §14.** §13 carries every `BRL-NNN`, grouped Classification / Reporting /
   Governance, each with owner, status and affected requirements. §14 is populated where
   `standards/reporting.md` fired — consumers, measure definitions, data elements, and transparency, audit
   and acceptance evidence — and otherwise carries one line saying it did not fire.
7. **Run the form self-check before saving.** Every register row: `Requirement Title` active and
   verb-first; `Business Tolerance` noun-first, passive, carrying its own quantified value; no
   modal; no "the system"; no `can [verb]`; no technical target; **passes the executive-altitude
   test**, with no classification, cut-off, reconciliation or evidence mechanism in the row. Check against TEMPLATE.md
   § *Worked register extract*, including its wrong-form table. Report rows checked and rows
   corrected in the coverage summary.
8. **Add a supporting view only where it improves comprehension** — TEMPLATE.md § *Supporting
   views*. Every view cites authoritative IDs and adds no value of its own; an entitlement matrix
   carries a legend defining each decision value. **The lenses exist to reduce overlooked
   consequences, not to raise page count** — a document is not more complete for being longer.
8a. **Write §1 Executive Summary last**, from the register that exists: the problem, the outcome,
   what is changing, what is not changing, and the major unresolved decisions with their owners. It
   cites IDs and restates no value a row carries.
9. **Record the registers and supplementary appendices.** §8 decisions (with `Resolution`), §9
   assumptions, §10 dependencies, related initiatives and referred requirements — four
   classifications, never one table. §11 traceability, with `Proposed AC` — proposed, never
   assigned; `$write-ac` mints `AC-NNN`. §12 entry position. §15 scenarios, §16 interface detail,
   §17 conformance (left pending until the design response is issued), §18 change history.
10. **Check traceability at §11**, which is its single home — the register carries `Source`
   only. Every requirement traces to its objective, business requirement and business objective;
   every business rule names its owner, status and affected requirements, and §11's `Business
   rules` column agrees with each rule's `Affects`. Flag any row with no objective **and** no source
   as **orphan scope**, and any BRD objective with no resulting register row as a **coverage gap**.
   Do not silently resolve either.
11. **State the document tier** in the header — the weakest `Status` on any KPP-bearing requirement.
12. Save to `docs/ord/[system-name]-ORD.md`.
13. **Generate the LLM companion** from the saved ORD by running
    `python3 scripts/llm_companion.py docs/ord/[system-name]-ORD.md --generator "$write-ord 3.0.0"`,
    per `standards/llm-companion.md`. It writes `docs/ord/[system-name]-ORD.llm.md` only when every row
    reconciles and every value arrived verbatim. On a refusal, report the reason; never write the
    companion by hand instead.
14. Present a coverage summary: sub-characteristics fully / partially specified or listed in §7.10;
    traceability completeness; the document tier and what would raise it; counts of assumptions,
    dependencies, related initiatives, referred requirements, business rules and open decisions;
    executive-altitude rewrites; and the companion line with its row and
    record counts.

### Phase 2 Output

- ORD document at `docs/ord/[system-name]-ORD.md`
- LLM companion at `docs/ord/[system-name]-ORD.llm.md`
- Coverage summary in the terminal, including the document tier

---

## Rules

**The *Never* lists in `standards/language.md` and `standards/tables.md` bind this skill in full and are not restated
here** — the modal ban, the technical-target ban, the "the system" ban, the blank-cell and invented-
threshold bans, KPP threshold/objective, the nine characteristics, the fourth scenario value, the
`Delivery Agent` / `Operational Owner` / `Timing` / `Verification` exclusions, the view rule, and ID
reuse all live there. Restating them here would put the same rule in two editable places, which is
how the two drift. The rules below are write-ord's own.

**Process**

- Never write the ORD without Phase 1 confirmation — the gate is mandatory.
- Never ask the user questions during Phase 1 — extract, classify, then present.
- Never hand the companion to review or sign-off in place of the ORD, and never edit it by hand —
  when the ORD changes, regenerate it with `--llm-only`. Never save a companion whose rows and
  records do not reconcile; name the rows missing or duplicated instead.
- Never read or trace to a PRD — a standalone ORD is a sibling of the PRD. Joint authoring is
  `$write-reqs`.
- Never skip a conditional trigger test. A wrong "no" silently skips a whole ruleset; both answers
  are stated in the Phase 1 Summary.
- Never report a lens as satisfied when it was not evidenced, and never run a lens whose trigger is
  absent — an inapplicable lens is not a gap.

**Authorship, not invention**

- Never invent requirements not present in or inferable from the source material — use TBD instead.
  This binds every lens output equally: thresholds, business rules, report populations, exclusions,
  calculation methods, source systems, owners, delivery agents, support teams, queue names, SLAs and
  OLAs, retry limits, escalation paths, retention periods, lifecycle transitions, status values,
  billing effects, regulatory interpretations, and diagnostic logic.
- Never default a MoSCoW priority. Priority is the Product Manager's decision; recommend one only
  when asked, and never present a recommendation as an approved decision.
- Never self-serve the "KPPs not yet designated" note. If no KPP is identifiable, raise it at the
  Phase 1 gate and record the human's answer — the designation is a human decision.
- Never convert an engineering threshold into a business tolerance without source evidence. Preserve
  the technical wording as `Source` evidence and raise the missing tolerance at the gate.
- Never carry an unquantified period. "Real time", "promptly", "x days" and "agreed SLA" are
  unquantified until the source defines them, and a defined period is incomplete without its
  calendar basis.
- Never infer a lifecycle transition, an authority, an attendance or an ownership the source does
  not state, and never assume bulk behaviour from the individual case.
- Never leave a derived cross-party consequence unconfirmed — name it and take it to the gate for
  the business owner.

**Consolidation and conflict**

- Never resolve a conflict without decision authority. Consolidate duplicates into one authoritative
  row; preserve both positions where they genuinely compete and raise a decision item.
- Never file a methodology conflict as an assumption — it is a decision, and it has an owner.
- Never split a source statement because it is long. Split only where actor, trigger, outcome,
  owner, priority, source, verification condition, status or business consequence differs.

**Structure**

- Never drop, merge or reorder a section of the eighteen. A section with nothing to state says so in
  one line; numbering never closes up around it.
- Never write a section from the requirements-documents pack's order into a 3.x ORD — the pack map
  is in REFERENCE.md § *Deviations*, and a hybrid matches neither.
- Never omit the Executive Summary, and never write it before the register exists. Never let it
  restate a value a row carries, or describe the operating state — that is §2.4's job.
- Never let a register row fail the executive-altitude test. Simplify it and move the detail to §13
  or §14 — never delete the detail to make the row short.
- Never write a classification, cut-off, calculation, reconciliation, exception, retention or
  versioning mechanism into §7 — it is a `BRL-NNN` in §13, cited by the row.
- Never omit §13. Every ORD carries the Business Rules Appendix, grouped Classification / Reporting /
  Governance, with the functional-content declaration in its lead.
- Never add a reporting section to the body — reporting outcomes are §7 rows, and their detail is
  §14.
- Never treat a reporting consumer as out of scope because their process does not change — a figure
  they rely on moving is an impact on them.
- Never assume a reporting platform already holds a new attribute, dimension or data element.
- Never put dependencies, related initiatives, referred requirements and out-of-scope items in one
  table — each has its own register and test.
- Never reword or drop the header's `**Structure:** write-ord 3.x` marker line — `$review-ord`
  matches it verbatim to read the document against the 3.x section map.
- Never reword the §5.2 definitions — copy them verbatim from `standards/tables.md`. Never record a descoped
  item as `Won't`: descoping is a §4.2 exclusion with a §18 entry.
- Never leave an unresolved decision or an assumption embedded in a requirement's wording — it is a
  §8 or §9 row the requirement cites.
- Never write "solution vision", and never let §2.4 name a mechanism, product, platform, protocol
  or integration pattern. If a sentence would change when architecture picks a different option, it
  is not a target operational state.
- Never give a §3 problem an ID or a threshold — `OBJ-NNN` holds the measurable form, and a problem
  register is that content inverted into a second editable place.
- Never write a design disposition into `IMP-NNN.Treatment`. The enum is `Addressed` /
  `No change required` / `Out of scope` and it is closed.
- Never state an impact exclusion in §4.2 prose as well as in `Treatment` — §4.2 cites the ID, and
  keeps prose only for exclusions that have no row.
- Never put a governance role in the actor register, and never give that register an ID prefix.
- Never omit a requirement that falls outside scope — refer it (§10.3) with a named recipient.
  An omitted requirement is indistinguishable from one nobody had.
- Never mint an `AC-NNN` — §11 carries a `Proposed AC`, and `$write-ac` owns the namespace.
- Never mint a `D-NNN` — `$raid` owns decisions. Raise them and cite the ID. Where no RAID log
  exists, carry a numbered `[D-TBD-N]` with the owner and what must be decided, cite it by number
  from every row it governs, and never drop the row.
- Never let a supporting view carry a value, a symbol or an asterisk it does not define.
- Never lengthen the document because more lenses were run. The lenses reduce overlooked
  consequences; they do not raise page count.
- If no system name can be determined, flag it in Phase 1 and use `[SYSTEM-NAME-TBD]`.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Source material is a raw audio transcript with filler words | Clean filler before extracting; note transcript quality in Phase 1 Summary |
| Source has no operational content (e.g. a sales deck) | Stop. Report: "No operational requirements found in source material. An ORD requires performance, support, or operational constraint content." |
| Source states technical targets throughout (RTO, uptime %, latency) | Extract the business tolerance behind each and record the rewrite in the Phase 1 Summary. Where the tolerance cannot be recovered, list it as a gap for the gate — never carry the technical figure through as the requirement |
| All characteristics are gaps | Proceed — all nine still appear, each carrying an explicit statement, and every sub-characteristic is listed in §7.10. Note the ORD is a shell requiring stakeholder workshops. Do not pad it with empty tables |
| No business owner named for any requirement | Every row is `Provisional` at best, and `Assumed` where no documentary source exists. State the tier and the E2/E3 entry-position gap. Do not invent an owner |
| A KPP can reach only `Assumed` inside the window | Flag it at the gate as the one item warranting escalation — it is the demand the design response most needs bounded |
| Invoked by `$write-reqs` with a joint-authoring brief | Treat the brief's ORD-bound half as the extraction scope. Own the NFRs the PRD cites; still never read the PRD. §13 is still written: rules the brief places in the PRD are cited by their PRD ID, not restated. Suppress the standalone next-steps block |
| KPP cannot be identified from source material | Ask at the Phase 1 gate. Do not write "KPPs not yet designated" on your own authority |
| ORD already exists at the target path | Stop. "An ORD already exists at docs/ord/. Confirm overwrite or provide a new name." |
| No RAID log exists in the project | Record the matter in full at §8.1 (decisions) or §8.2 (risks) with a numbered `[D-TBD-N]` or `[R-TBD-N]` in the ID cell, plus a named owner and a required-by date. A placeholder is not a mint; a dropped row is a lost decision |
| An authoring standard cannot be read | Stop and name the file. Do not draft the register, the scenarios or any criterion from memory — the output would be indistinguishable from a conformant one |
| Requirements conflict (e.g. same measure defined two ways) | Preserve both, record each method's decision criteria, raise `$raid add decision`, and identify the affected requirements. Never resolve it without decision authority |
| No BRD found | Note "No BRD found." Proceed — trace each requirement to its `OBJ-NNN` and to its proximate source (contract, incident record, named stakeholder) instead of a BRD objective |
| BRD objective produces no register row, or a row has no objective and no source | Flag as a coverage gap or orphan scope. Do not silently resolve |
| Source states no MoSCoW | Write `TBD` and list it at the gate — priority is the Product Manager's decision, never a drafting choice |
| Staffing, training, policy or infrastructure requirements raised | Record in §10.3 with a resolver group and a named recipient, and keep the §4.2 exclusion. Never write them as requirements, and never drop them |
| Source names statuses or a lifecycle but no transitions | Extract the states, raise the missing transitions as gaps, and ask at the gate. Distinguish rollback after failed processing from reversal after successful processing — a source stating one has not stated the other |
| Source states only the individual case where bulk processing is in scope | Extract the individual requirement. Raise bulk validation, partial bulk failure, bulk summary and manual fallback as gaps. Never carry the individual behaviour across |
| Source gives an engineering threshold and no business tolerance | Keep the technical wording as `Source` evidence, carry `[TBD — source: "…"]` as the tolerance, and raise it at the gate. Never promote the figure to the requirement |
| The same threshold appears in two channels at different values | A consistency finding, not a confirmation. Preserve both, name the affected requirements, and raise a decision item |
| One party's action changes another party's service, data, billing or rights | Name the derived consequence and take it to the gate for the affected business owner's explicit confirmation. Never infer the authority from a role name |
| An entitlement matrix is supplied with `Yes*`, `No*` or undefined symbols | The asterisk is an unwritten condition. Ask what it means at the gate; write it into the `BRL-NNN` or `ORD-NNN` row the cell cites, never into the matrix |
| A lens has no trigger in the source | Do not run it, do not report it, and do not record it as a coverage gap — an inapplicable lens is not a gap, the same rule the *(AI)* subsections follow |
| A lens is run and finds nothing | Report "not evidenced". Never report it as satisfied — the two are different findings and only one is safe to act on |
| Source states an impact but no treatment | `Treatment` is `[TBD]`. Ask at the gate. Never infer `No change required` from silence — that is the disposition most expensive to get wrong |
| Source states a design disposition — "migrated", "decommissioned", "extended" | Refuse it as a treatment. Record the wording as `Source` evidence, set `Treatment` from the scope enum, and refer the design question (§10.3) |
| A role name is the only evidence of authority | Record the actor and its operational role. Leave authority `[TBD]` — attendance, participation, approval and ownership are never inferred from a name |
| Source has no BRD and no `BO-N` to trace §3 to | §3 is the ORD's own origin record. Trace each problem to its proximate source — contract, incident record, named stakeholder — and note the absence at E1 |
| §2.4 cannot be written without naming a mechanism | The source has given a solution, not a target state. Write what is true for the business regardless of the mechanism; refer the rest (§10.3) and flag it at the gate |
| Form self-check finds a row failing `standards/language.md` | Correct it and count it. Report rows checked and rows corrected — a self-check reporting zero corrections on a first draft was not run |
| A source statement mixes an outcome with its control logic | Split it: the outcome is the §7 row, the logic a `BRL-NNN` in §13 the row cites. List the split under *Executive-altitude rewrites* |
| Reporting is affected but the source names no consumer | Raise each consumer class at the gate as a question. Never infer a consumer, and never conclude there are none |
| A measure needs an attribute or dimension with no evidence it exists | `DAT-NNN` with `Availability: Unconfirmed`, and a candidate reporting-data requirement at the gate. Never assume the reporting platform holds it |
| An adjacent programme is named and its relationship is unclear | Apply the four tests in `standards/tables.md` § *Related initiative*. Where none decides it, list it at the gate — never default it to a dependency |
| An existing ORD in the 2.x structure is to be revised | Do not restructure silently. Ask at the gate whether to migrate it to the 3.x structure using the REFERENCE.md section map, or to revise in place under 2.x |
| Statement marked out of scope but written as an active commitment | Consistency-sweep finding. Do not delete and do not honour it — raise it at the gate and record the human's answer |
