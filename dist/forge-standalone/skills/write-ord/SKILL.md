---
name: write-ord
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
   tolerance, recovery, compliance, interfaces, security, observability.
4. **Rewrite each as a business tolerance as you extract.** Where the source states a technical
   target, capture the underlying business tolerance and record the technical figure as the
   source's wording, not as the requirement. Where the tolerance behind it cannot be recovered from
   the source, that is a gap for the gate — not a licence to keep the technical figure.
5. **Tag provenance and status as you extract.** Record the source evidence (contract clause,
   obligation, incident record, or Business Unit / Function / Name), the named business owner, and
   the `Status` — `Committed`, `Provisional` or `Assumed` — per REFERENCE.md § *Requirement status
   taxonomy*. Also capture, where stated: MoSCoW priority and the operational objective served.
6. **Extract the operational objectives** (`OBJ-NNN`) — outcome, baseline, target, target date.
   Every requirement traces to one. A missing baseline or target is a `[TBD]`, never an invention.
7. **Extract the impact register** (`IMP-NNN`) — the L4 workflows and current-estate systems the
   change touches, each with a named owner. Identification only; what they *become* is the response's.
8. **Extract referred requirements** (`REF-NNN`) — content raised during elicitation that this ORD
   will not deliver: functional detail, staffing, training, policy, commercial or process-design
   work. Record the resolver group and the named recipient. `Resolver group: None in chain` is a
   real answer and the row stays open.
9. **Extract business rules** (`BRL-NNN`) where classification, eligibility, calculation or
   reporting logic exists. Note whether a PRD is produced in this chain — if one is, the rules
   belong there and Appendix G is omitted.
10. Classify each extracted statement against the ISO/IEC 25010:2023 nine characteristics. Flag
    statements too vague to classify.
11. Identify gaps at **sub-characteristic** level — check every sub-characteristic in the
    REFERENCE.md taxonomy. Characteristic-level checking hides gaps inside a partially-covered
    characteristic. Also identify BRD objectives with no resulting operational requirement.
12. **Draft scenarios** (`SCN-NNN`) for each requirement — at minimum a Sunny Day. **Where the
    requirement is a determination, measurement or eligibility decision, draft both a Favourable and
    an Adverse Sunny Day row**: a capability that runs correctly and returns bad news is not a
    failure, and what must be true then is a separate obligation that is routinely left unstated.
    Flag any determination requirement carrying only a Favourable row.
13. Extract **assumptions and dependencies** as first-class items. Carry `/idea` assumptions forward
    with their Status. Every assumption cited as a requirement's `Source` needs a named owner and a
    confirm-by date.
14. Identify **Key Performance Parameters** — requirements whose failure means the capability is
    unfit for purpose, not merely degraded. State each as a business-failure threshold carrying
    **threshold and objective** as two labelled values.
15. **Apply both conditional trigger tests** — `ai.md` and `reporting.md`. Answer each explicitly in
    the Phase 1 Summary; do not leave either unasked. Judge the **delivered solution**, never the
    toolchain that builds it. Where `ai.md` fires, classify against the ISO/IEC 25059
    sub-characteristics too. Where `reporting.md` fires, check every class in its map and extract
    the `DAT-NNN` data elements.
16. **Detect competing methodologies** — where current operational practice differs from
    contractual, regulatory or documented reporting practice, preserve both, and raise it for the
    gate as a decision item. Never file a methodology conflict as an assumption.
17. **Compute the document tier** — the weakest `Status` carried by any KPP-bearing requirement.
18. Present the Phase 1 Summary and pause.

### Phase 1 Summary Format

```
## ORD Ingest Summary — [System / Project Name]

### Source Material Processed
- [Each source, including the BRD if found]

### Entry Position
| # | Input | Status at assignment |
|---|---|---|
| E1–E9 | [per REFERENCE.md §2.3] | Received / Partial / Absent |

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

### Impacts and Referred Requirements
| IMP# | Impact | Kind | Owner | Referred |
| REF# | Requirement | Kind | Resolver group | Referred to |

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
6. **Record the appendices.** A (traceability, with `Proposed AC` — proposed, never assigned; `/write-ac`
   mints `AC-NNN`), B (assumptions), C (referred requirements), D (conformance, left pending until
   the design response is issued), E (interface detail), F (scenario catalogue), G (business rules —
   only where no functional requirements document is produced, with the deviation declared),
   H (data elements — only where `reporting.md` fires).
7. **Check traceability at Appendix A**, which is its single home — the register carries `Source`
   only. Flag any row with no objective **and** no source as **orphan scope**, and any BRD objective
   with no resulting register row as a **coverage gap**. Do not silently resolve either.
8. **State the document tier** in the header — the weakest `Status` on any KPP-bearing requirement.
9. Save to `docs/ord/[system-name]-ORD.md`.
10. Present a coverage summary: sub-characteristics fully / partially specified or listed in §3.10;
    traceability completeness; the document tier and what would raise it; counts of assumptions,
    dependencies, referred requirements and open decisions.

### Phase 2 Output

- ORD document at `docs/ord/[system-name]-ORD.md`
- Coverage summary in the terminal, including the document tier

---

## Rules

- Never write the ORD without Phase 1 confirmation — the gate is mandatory.
- Never state a technical target where a business tolerance belongs. No RTO, RPO, latency figure,
  availability percentage, instance count or protocol choice. Supply the demand; the design response
  supplies the target.
- Never invent requirements not present in or inferable from the source material — use TBD instead.
- Never leave a requirement hedged. Quantification alone is not enough: "should respond within 3
  seconds" is quantified and still fails. Quantify *and* write it as a declarative end state.
- Never leave a cell blank where the value is unknown — write `[TBD]` with an owner and a confirm-by
  date. A blank field is untracked absence; 29148 tolerates a tracked TBD and not a silent gap.
- Never carry a requirement at `Status: Assumed` whose assumption has no named owner and no
  confirm-by date. That is an invented number, and it is the document's largest audit exposure.
- Never collapse a KPP's threshold and objective into a single figure.
- Never mark every Must as a KPP — MoSCoW, `KPP` and `Status` are three orthogonal axes.
- Never default a MoSCoW priority. Priority is the Product Manager's decision; recommend one only
  when asked, and never present a recommendation as an approved decision.
- Never omit one of the nine ISO/IEC 25010 characteristics. Collapse *sub*-characteristics to the
  §3.10 Coverage Gaps table; never scaffold an empty table per absent subsection.
- Never renumber around §6 and §8 — they stay numbered and empty, with their content referred.
- Never put `Delivery Agent`, `Operational Owner`, `Timing` or `Verification` in the register. Each
  is response-side. Timing lives at the objective; the verification instrument is recorded at
  Appendix D when the design response is issued.
- Never leave a determination, measurement or eligibility requirement with only a Favourable Sunny
  Day scenario — state what is true when the answer is adverse.
- Never add a fourth `Scenario` value. Condition and outcome are two axes.
- Never mint an `AC-NNN` — Appendix A carries a `Proposed AC`, and `/write-ac` owns the namespace.
- Never mint a `D-NNN` — `/raid` owns decisions. Raise them and cite the ID. Where no RAID log
  exists, carry `[D-TBD]` with the owner and what must be decided; never drop the row.
- Never file a methodology conflict as an assumption — it is a decision, and it has an owner.
- Never carry business rules without declaring the deviation and naming why no functional
  requirements document holds them.
- Never nominate a system or dataset as authoritative unless the source material confirms it.
- Never express a binding statement as free-text prose in Sections 3–5, 7 or 9.
- Never put a commitment in a comment or a narrative section.
- Never restate a value that already exists as a row — Section 7 and every other summary is a
  **view** citing existing IDs.
- Never self-serve the "KPPs not yet designated" note. If no KPP is identifiable, raise it at the
  Phase 1 gate and record the human's answer — the designation is a human decision.
- Never reuse a retired ID. Never use a single-letter prefix — it collides with `/raid`.
- Never record an assumption without an `If false` consequence, and never leave a falsified
  assumption unescalated — set `Status: Falsified` and raise it via `/raid add risk`, or carry
  `[R-TBD]` where no RAID log exists.
- Never omit a requirement that falls outside scope — refer it (Appendix C) with a named recipient.
  An omitted requirement is indistinguishable from one nobody had.
- Never read or trace to a PRD — a standalone ORD is a sibling of the PRD. Joint authoring is
  `/write-reqs`.
- Never ask the user questions during Phase 1 — extract, classify, then present.
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
