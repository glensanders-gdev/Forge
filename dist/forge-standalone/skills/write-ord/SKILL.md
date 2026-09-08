---
name: write-ord
version: 2.1.0
category: pipeline
description: Synthesize a call transcript, document, conversation context, or structured notes into a compliant demand-side Operational Requirements Document (ORD) — quantified business tolerances organised by ISO/IEC 25010:2023 quality characteristics, with operational objectives, scenarios, business rules and referred requirements. Use when the user runs /write-ord, provides a transcript or document to convert into an ORD, or wants to formalise operational requirements from a conversation.
---

# Write ORD

Synthesize source material into a structured **demand-side** Operational Requirements Document.
Runs in two phases with a mandatory confirmation gate between them.

**Demand-side means the ORD states quantified business tolerance and never the technical target that
satisfies it.** *"Service is restorable within one business day, beyond which obligation X is
breached"* is this document's business; *"RTO 4h"* is the design response's. The ORD precedes
solutioning — architecture, security, operations and service management answer it downstream and do
not contribute to it. Stating a technical target pre-empts the review the document exists to inform.

See [REFERENCE.md](REFERENCE.md) for the ISO/IEC 25010:2023 taxonomy, the demand-side scope rule,
the status taxonomy, the KPP guide and the full ORD template.

**Authoring standards — read before writing any requirement:**
- `language.md` — wording, voice, banned modals, demand-not-design
- `tables.md` — table-first presentation, canonical schemas, ID namespaces
- `ai.md` — **conditional.** Fires where a delivered component's output
  for a given input is not fully determined by written logic — a trained model, an LLM call, a
  retrieval-augmented pipeline, an agent, or a third-party AI service consumed as an API. Supplies
  the evaluative criterion, the `EVL-NNN` / `MDL-NNN` schemas, and the ISO/IEC 25059 class map.
- `reporting.md` — **conditional.** Fires where the change creates,
  alters or retires a measure somebody reports. Supplies the measure definition, the `DAT-NNN`
  schema and the ISO/IEC 25012 data-quality anchor.

Apply both trigger tests in Phase 1 — a wrong "no" silently skips a whole ruleset. They are
independent: a change can fire both, one, or neither.

These are authoritative and shared with `/write-prd`, `/write-reqs` and `/write-ac`. Never restate
them here.

Each standard named above is a part of `STANDARDS.md`, beside this file — a citation such as
`tables.md` means the part of that document carrying that name, not a separate file to find.

**If an authoring standard above cannot be read, stop and name it.** The register and criteria
schemas, the modal ban and the scenario values live there and nowhere else. Drafting them from
memory produces a document that looks conformant and is not, and no reviewer can see the
difference. An unreadable standard is a blocked run, never a degraded one.

---

## Phase 1 — AFK Ingest [AFK]

Runs unattended. Extracts and classifies all operational requirements from source material.

Extraction judgement — what to split, what to consolidate, what to strip from a source
statement — is in [REFERENCE.md](REFERENCE.md) § *Extraction*. The analysis lenses that decide
**what to look for** are in § *Elicitation lenses*, and each is gated by its own trigger.

### Inputs accepted

- Call transcript (paste or file path), meeting or interview notes
- Existing document (Word export, PDF text, markdown)
- Current conversation context
- Any combination of the above

Where available, also read: the BRD and its version, scope and out-of-scope statements, business
objectives, stakeholders, dependencies, known business rules, current-state processes, the target
date and the milestone it serves, and any Product Manager prioritisation already given.

**Missing inputs are recorded, never inferred** — as an entry-position row (§2.3), a gap, an
assumption with an owner and a confirm-by date, or a decision item.

### Phase 1 Process

0. **Check for a joint-authoring brief.** When invoked by `/write-reqs`, a brief accompanies the
   invocation carrying (a) the ORD-bound half of the classified source and (b) the NFR citations the
   PRD makes. Treat the brief's half as the **extraction scope** and do not re-extract functional
   needs already routed to the PRD. Absent a brief, this is a standalone run; proceed from step 1.
1. Read all provided source material in full.
2. Read the BRD if one exists (`docs/brd/`) — capture the `BO-N` objectives this ORD traces up to,
   and the `BR-N` business requirements each objective runs through. If absent, note it. **Do not
   read the PRD** — a standalone ORD is a *sibling* of the PRD, not its child. Joint authoring is
   the separate `/write-reqs` workflow.
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
10. **Extract business rules** (`BRL-NNN`) where classification, eligibility, calculation or
   reporting logic exists. Note whether a PRD is produced in this chain — if one is, the rules
   belong there and Appendix G is omitted.
11. Classify each extracted statement against the ISO/IEC 25010:2023 nine characteristics. Flag
    statements too vague to classify.
12. Identify gaps at **sub-characteristic** level — check every sub-characteristic in the
    REFERENCE.md taxonomy. Characteristic-level checking hides gaps inside a partially-covered
    characteristic. Also identify BRD objectives with no resulting operational requirement.
13. **Draft scenarios** (`SCN-NNN`) for each requirement — at minimum a Sunny Day. **Where the
    requirement is a determination, measurement or eligibility decision, draft both a Favourable and
    an Adverse Sunny Day row**: a capability that runs correctly and returns bad news is not a
    failure, and what must be true then is a separate obligation that is routinely left unstated.
    Flag any determination requirement carrying only a Favourable row.
14. Extract **assumptions and dependencies** as first-class items. Carry `/idea` assumptions forward
    with their Status. Every assumption cited as a requirement's `Source` needs a named owner and a
    confirm-by date.
15. Identify **Key Performance Parameters** — requirements whose failure means the capability is
    unfit for purpose, not merely degraded. State each as a business-failure threshold carrying
    **threshold and objective** as two labelled values.
16. **Run the applicable elicitation lenses** — REFERENCE.md § *Elicitation lenses*. Apply only
    the lenses whose trigger is present in the source; lens 1 (operational purpose) and lens 14
    (consistency) are unconditional. A lens finds a question, and its output is a register row only
    where the source carries the tolerance and its evidence — otherwise a `[TBD]`, a gap, an
    explicit assumption, a decision item, or a referred requirement. **A lens that finds nothing is
    reported as *not evidenced*, never as satisfied.**
17. **Apply both conditional trigger tests** — `ai.md` and `reporting.md`. Answer each explicitly in
    the Phase 1 Summary; do not leave either unasked. Judge the **delivered solution**, never the
    toolchain that builds it. Where `ai.md` fires, classify against the ISO/IEC 25059
    sub-characteristics too. Where `reporting.md` fires, check every class in its map and extract
    the `DAT-NNN` data elements.
18. **Detect competing methodologies** — where current operational practice differs from
    contractual, regulatory or documented reporting practice, preserve both, and raise it for the
    gate as a decision item. Never file a methodology conflict as an assumption.
19. **Run the consistency sweep** — REFERENCE.md § *The consistency sweep*. Consolidate
    duplicates into one authoritative statement. Never resolve a conflict: preserve both documented
    positions, name the affected requirements, and raise a decision item.
20. **Compute the document tier** — the weakest `Status` carried by any KPP-bearing requirement.
21. Present the Phase 1 Summary and pause.

### Phase 1 Summary Format

```
## ORD Ingest Summary — [System / Project Name]

### Source Material Processed
- [Each source, including the BRD if found]

### Entry Position
| # | Input | Status at assignment |
|---|---|---|
| E1–E9 | [per REFERENCE.md §2.3] | Received / Partial / Absent |

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

### Trigger — `ai.md`
**Fired:** Yes — [components] | No — [why]
[Where fired:] 25059 sub-characteristics engaged · EVL/MDL candidates

### Trigger — `reporting.md`
**Fired:** Yes — [the reported measures] | No — [why]
[Where fired:] data elements identified · reconciliation classes checked

### Scenarios
Requirements with only a Favourable Sunny Day scenario: [list — each needs an Adverse row, or a
reason it is not a determination]

### Business Rules
| BRL# | Rule group | Required decision | Status | Owner |
|---|---|---|---|---|
Functional requirements document produced in this chain? [Yes → rules go to the PRD / No → Appendix G, deviation declared]

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
Listed once in §3.10 — not scaffolded as an empty table each. All nine characteristics still appear.
BRD objectives with no resulting requirement: [list, or "none"]

### Assumptions and Dependencies
| Carried from | Assumptions | Dependencies | Missing owner or confirm-by |
|---|---|---|---|

### Vague Statements Requiring Clarification
- "[Quote]" — needs: [missing detail]

### Proposed System Name
[Inferred, or flagged unknown]

---
Confirm to proceed to Phase 2, or provide corrections and gap-fills before I write the ORD.
```

---

## Phase 2 — HITL Write [HITL]

Runs after the human confirms the Phase 1 summary. Writes the ORD using the template in
[REFERENCE.md](REFERENCE.md).

### Phase 2 Process

1. Incorporate all corrections and gap-fills from the Phase 1 confirmation.
2. Write the ORD following REFERENCE.md's template. **All nine characteristics appear at §3.1–3.9**;
   a characteristic with nothing to state says so explicitly. §6 and §8 are numbered and left empty.
3. **Assign stable IDs** — `ORD-NNN`, `OBJ-NNN`, `SCN-NNN`, `IMP-NNN`, `REF-NNN`, `BRL-NNN`,
   `ASM-NNN`, `DEP-NNN`, flat and sequential in order of first appearance, never reused. The ID
   never encodes the characteristic — the subsection heading supplies it. **This document owns
   `EVL-NNN` and `MDL-NNN`**; resolve every `[EVL-TBD]` the PRD left behind and write the real ID
   back into the PRD criterion.
4. **Write every requirement per the shared rules.** A complete row is a declarative
   `Business Tolerance` carrying its own quantified value, an active verb-first
   `Requirement Title`, a `Ver`, a `Status`, a named `Owner`, and a `Source`. The up-link to its
   objective and its BRD objective lives once, at Appendix A — never as a register column. A KPP carries
   threshold and objective as two labelled values. Where source material gives no value, write
   `[TBD — source: "quoted vague statement"]` — never invent one, and never leave a cell blank in
   place of a TBD: a blank is indistinguishable from an oversight, a TBD with an owner and a date
   conforms to 29148.
5. **Every binding statement in Sections 3–5, 7 and 9 is a row with an `ORD-NNN` ID.** Section 7 is
   a **view**: it cites existing IDs and introduces no new values.
6. **Write §1.6, §2.5 and §2.6.** §1.6 carries the operational problems, each tracing to a `BO-N`
   and each named by the `OBJ-NNN` that closes it. §2.5 is the target operational state — a
   **view of §2.4**, outcomes only, no mechanism; a sentence that would change when architecture
   picks a different option does not belong. §2.6 is the actor register, governance roles excluded.
   All three **append**: §1.1–1.5 and §2.1–2.4 keep their numbers. Record the extensions per
   REFERENCE.md § *Deviations from the requirements-documents pack*.
7. **Run the form self-check before saving.** Every register row: `Requirement Title` active and
   verb-first; `Business Tolerance` noun-first, passive, carrying its own quantified value; no
   modal; no "the system"; no `can [verb]`; no technical target. Check against REFERENCE.md
   § *Worked register extract*, including its wrong-form table. Report rows checked and rows
   corrected in the coverage summary.
8. **Add a supporting view only where it improves comprehension** — REFERENCE.md § *Supporting
   views*. Every view cites authoritative IDs and adds no value of its own; an entitlement matrix
   carries a legend defining each decision value. **The lenses exist to reduce overlooked
   consequences, not to raise page count** — a document is not more complete for being longer.
   Where an Executive Summary is written, it restates no value a row carries, and it is omitted
   where §1.1 and §2.1 already carry the narrative.
9. **Record the appendices.** A (traceability, with `Proposed AC` — proposed, never assigned; `/write-ac`
   mints `AC-NNN`), B (assumptions), C (referred requirements), D (conformance, left pending until
   the design response is issued), E (interface detail), F (scenario catalogue), G (business rules —
   only where no functional requirements document is produced, with the deviation declared),
   H (data elements — only where `reporting.md` fires).
10. **Check traceability at Appendix A**, which is its single home — the register carries `Source`
   only. Flag any row with no objective **and** no source as **orphan scope**, and any BRD objective
   with no resulting register row as a **coverage gap**. Do not silently resolve either.
11. **State the document tier** in the header — the weakest `Status` on any KPP-bearing requirement.
12. Save to `docs/ord/[system-name]-ORD.md`.
13. Present a coverage summary: sub-characteristics fully / partially specified or listed in §3.10;
    traceability completeness; the document tier and what would raise it; counts of assumptions,
    dependencies, referred requirements and open decisions.

### Phase 2 Output

- ORD document at `docs/ord/[system-name]-ORD.md`
- Coverage summary in the terminal, including the document tier

---

## Rules

**The *Never* lists in `language.md` and `tables.md` bind this skill in full and are not restated
here** — the modal ban, the technical-target ban, the "the system" ban, the blank-cell and invented-
threshold bans, KPP threshold/objective, the nine characteristics, the fourth scenario value, the
`Delivery Agent` / `Operational Owner` / `Timing` / `Verification` exclusions, the view rule, and ID
reuse all live there. Restating them here would put the same rule in two editable places, which is
how the two drift. The rules below are write-ord's own.

**Process**

- Never write the ORD without Phase 1 confirmation — the gate is mandatory.
- Never ask the user questions during Phase 1 — extract, classify, then present.
- Never read or trace to a PRD — a standalone ORD is a sibling of the PRD. Joint authoring is
  `/write-reqs`.
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

- Never renumber around §6 and §8 — they stay numbered and empty, with their content referred.
- Never insert a subsection. §1.6, §2.5 and §2.6 append; §1.1–1.5 and §2.1–2.4 keep their numbers.
  Inserting desynchronises `review-ord`'s pinned pack extract, which this skill does not own.
- Never write "solution vision", and never let §2.5 name a mechanism, product, platform, protocol
  or integration pattern. If a sentence would change when architecture picks a different option, it
  is not a target operational state.
- Never give §1.6 a problem an ID or a threshold — `OBJ-NNN` holds the measurable form, and a
  problem register is that content inverted into a second editable place.
- Never write a design disposition into `IMP-NNN.Treatment`. The enum is `Addressed` /
  `No change required` / `Out of scope` and it is closed.
- Never state an impact exclusion in §1.3 prose as well as in `Treatment` — §1.3 is a view for
  impacts, and keeps prose only for exclusions that have no row.
- Never put a governance role in the actor register, and never give that register an ID prefix.
- Never let the Executive Summary describe the operating state — that is §2.5's job, and the two
  become one paragraph written twice.
- Never omit a requirement that falls outside scope — refer it (Appendix C) with a named recipient.
  An omitted requirement is indistinguishable from one nobody had.
- Never mint an `AC-NNN` — Appendix A carries a `Proposed AC`, and `/write-ac` owns the namespace.
- Never mint a `D-NNN` — `/raid` owns decisions. Raise them and cite the ID. Where no RAID log
  exists, carry `[D-TBD]` with the owner and what must be decided; never drop the row.
- Never let a supporting view carry a value, a symbol or an asterisk it does not define.
- Never let an Executive Summary restate a value a row carries, or survive where §1.1 and §2.1
  already carry the narrative.
- Never lengthen the document because more lenses were run. The lenses reduce overlooked
  consequences; they do not raise page count.
- If no system name can be determined, flag it in Phase 1 and use `[SYSTEM-NAME-TBD]`.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Source material is a raw audio transcript with filler words | Clean filler before extracting; note transcript quality in Phase 1 Summary |
| Source has no operational content (e.g. a sales deck) | Stop. Report: "No operational requirements found in source material. An ORD requires performance, support, or operational constraint content." |
| Source states technical targets throughout (RTO, uptime %, latency) | Extract the business tolerance behind each and record the rewrite in the Phase 1 Summary. Where the tolerance cannot be recovered, list it as a gap for the gate — never carry the technical figure through as the requirement |
| All characteristics are gaps | Proceed — all nine still appear, each carrying an explicit statement, and every sub-characteristic is listed in §3.10. Note the ORD is a shell requiring stakeholder workshops. Do not pad it with empty tables |
| No business owner named for any requirement | Every row is `Provisional` at best, and `Assumed` where no documentary source exists. State the tier and the E2/E3 entry-position gap. Do not invent an owner |
| A KPP can reach only `Assumed` inside the window | Flag it at the gate as the one item warranting escalation — it is the demand the design response most needs bounded |
| Invoked by `/write-reqs` with a joint-authoring brief | Treat the brief's ORD-bound half as the extraction scope. Own the NFRs the PRD cites; still never read the PRD. Business rules go to the PRD, so Appendix G is omitted. Suppress the standalone next-steps block |
| KPP cannot be identified from source material | Ask at the Phase 1 gate. Do not write "KPPs not yet designated" on your own authority |
| ORD already exists at the target path | Stop. "An ORD already exists at docs/ord/. Confirm overwrite or provide a new name." |
| No RAID log exists in the project | Record the matter in full at §9.2 (decisions) or §9.1 (risks) with `[D-TBD]` or `[R-TBD]` in the ID cell, plus a named owner and a required-by date. A placeholder is not a mint; a dropped row is a lost decision |
| An authoring standard cannot be read | Stop and name the file. Do not draft the register, the scenarios or any criterion from memory — the output would be indistinguishable from a conformant one |
| Requirements conflict (e.g. same measure defined two ways) | Preserve both, record each method's decision criteria, raise `/raid add decision`, and identify the affected requirements. Never resolve it without decision authority |
| No BRD found | Note "No BRD found." Proceed — trace each requirement to its `OBJ-NNN` and to its proximate source (contract, incident record, named stakeholder) instead of a BRD objective |
| BRD objective produces no register row, or a row has no objective and no source | Flag as a coverage gap or orphan scope. Do not silently resolve |
| Source states no MoSCoW | Write `TBD` and list it at the gate — priority is the Product Manager's decision, never a drafting choice |
| Staffing, training, policy or infrastructure requirements raised | Record in Appendix C with a resolver group and a named recipient. Never write them into §6 or §8, and never drop them |
| Source names statuses or a lifecycle but no transitions | Extract the states, raise the missing transitions as gaps, and ask at the gate. Distinguish rollback after failed processing from reversal after successful processing — a source stating one has not stated the other |
| Source states only the individual case where bulk processing is in scope | Extract the individual requirement. Raise bulk validation, partial bulk failure, bulk summary and manual fallback as gaps. Never carry the individual behaviour across |
| Source gives an engineering threshold and no business tolerance | Keep the technical wording as `Source` evidence, carry `[TBD — source: "…"]` as the tolerance, and raise it at the gate. Never promote the figure to the requirement |
| The same threshold appears in two channels at different values | A consistency finding, not a confirmation. Preserve both, name the affected requirements, and raise a decision item |
| One party's action changes another party's service, data, billing or rights | Name the derived consequence and take it to the gate for the affected business owner's explicit confirmation. Never infer the authority from a role name |
| An entitlement matrix is supplied with `Yes*`, `No*` or undefined symbols | The asterisk is an unwritten condition. Ask what it means at the gate; write it into the `BRL-NNN` or `ORD-NNN` row the cell cites, never into the matrix |
| A lens has no trigger in the source | Do not run it, do not report it, and do not record it as a coverage gap — an inapplicable lens is not a gap, the same rule the *(AI)* subsections follow |
| A lens is run and finds nothing | Report "not evidenced". Never report it as satisfied — the two are different findings and only one is safe to act on |
| Source states an impact but no treatment | `Treatment` is `[TBD]`. Ask at the gate. Never infer `No change required` from silence — that is the disposition most expensive to get wrong |
| Source states a design disposition — "migrated", "decommissioned", "extended" | Refuse it as a treatment. Record the wording as `Source` evidence, set `Treatment` from the scope enum, and refer the design question (Appendix C) |
| A role name is the only evidence of authority | Record the actor and its operational role. Leave authority `[TBD]` — attendance, participation, approval and ownership are never inferred from a name |
| Source has no BRD and no `BO-N` to trace §1.6 to | §1.6 is the ORD's own origin record. Trace each problem to its proximate source — contract, incident record, named stakeholder — and note the absence at E1 |
| §2.5 cannot be written without naming a mechanism | The source has given a solution, not a target state. Write what is true for the business regardless of the mechanism; refer the rest (Appendix C) and flag it at the gate |
| Form self-check finds a row failing `language.md` | Correct it and count it. Report rows checked and rows corrected — a self-check reporting zero corrections on a first draft was not run |
| Statement marked out of scope but written as an active commitment | Consistency-sweep finding. Do not delete and do not honour it — raise it at the gate and record the human's answer |
