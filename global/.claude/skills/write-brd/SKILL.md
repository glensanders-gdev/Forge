---
name: write-brd
category: pipeline
standalone: true
description: Author a Business Requirements Document to the pack's BABOK v3 standard — SMART objectives carrying baseline, target and date, outcomes rather than solutions, and a cost-of-failure case for each objective carrying operational exposure — then self-assess it against the BH-1 – BH-10 handoff gate that decides whether ORD development can start. Runs AFK ingest, HITL write, then the gate. The standard is read at authoring time, never recalled. Use when a BRD is needed from a request brief, idea, transcript or notes, when /write-brd is run, or when an ORD task turns out to be a BRD task in disguise.
---

# Write BRD

Author the document that states **why** money is being spent and how it will be known that it paid
off — then establish whether it clears **the bar** for ORD development.

Execution mode: Phase 1 **[AFK]** · Phase 2 **[HITL]** behind a confirmation gate · Phase 3 **[AFK]**.
The standard owns the anatomy, both forms and the gate; this skill locates it and applies it.

**Authoring standards** — `~/.claude/rules/requirements/language.md` and
`~/.claude/rules/requirements/tables.md`, shared with `/write-prd`, `/write-ord` and `/write-ac`,
never restated here. **Where they meet the pack, the pack wins on BRD-specific forms:** the SMART
objective is verb-first by the pack's own form, and a `[TBD]` carries **a named owner and a date**
rather than `language.md`'s source quote — the gate reads both, and a `[TBD]` missing either is a
hole that fails the bar.

`~/.claude/rules/requirements/ai.md` applies **conditionally** — where a delivered component's
behaviour is learned or generated rather than specified, this document records the **risk
classification decision** once, per that ruleset's class map, and every downstream document reads it
from here.

---

## Phase 1 — Ingest and classify [AFK]

1. **Source the standard, never recall it.** Per [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md)
   § *Sourcing the criteria* — the live pack's `reference/brd-standard.md` where held, otherwise the
   stamped extract in [STANDARD.md](STANDARD.md). Name the pack version in the summary. Read the
   anatomy and its five **★** sections, both forms, the solution-vs-outcome test, the gate, and
   **BRD-2026-041** as the reference implementation — it carries a declared gap, an unowned one and
   an empty traceability row, which is what a real BRD looks like.
2. **Read every source in full** — a<!--forge-only--> `/front-gate`<!--/forge-only--> Request Brief, `~/.claude/ideas/active/*/idea.md`,
   transcripts, notes, existing documents, conversation context.
3. **Classify every statement by the BABOK v3 taxonomy.** Business and Stakeholder statements are
   this document's. A Solution statement is not, and is **routed rather than dropped** — the
   standard's *tolerance or figure* table names each destination. Functional detail has no document
   in this chain, so it is registered or it is lost.
4. **Draft each objective to the objective form, then run the solution-vs-outcome test.** An
   objective naming a feature, system, vendor or asserted figure has pre-empted the ORD; rewrite it
   as the measurable outcome the enterprise wants.
5. **Pair each objective carrying operational exposure with a cost-of-failure statement**, sourced to
   a contract clause, an incident, or a named obligation. Every downstream tolerance derives from it,
   and it is the item most often assumed optional.
6. **Read the size off Appendix A's inputs** — business units, objectives, stakeholders, and impacted
   workflows and systems combined — against the size table. This is what makes the ORD sizeable at
   assignment.
7. **Present the Phase 1 summary** in [REFERENCE.md](REFERENCE.md) and pause. Extract and classify
   first; ask nothing before the summary.

**Completion:** every extracted statement is placed in a BRD section or routed with its destination
named; every objective carries a baseline, a target and a date, or a `[TBD]` with a named owner and a
date; and every figure the source did not state is an open question at the gate rather than a number.

## Phase 2 — Write [HITL]

1. Incorporate the corrections and gap-fills from the Phase 1 confirmation.
2. **Write every section of the anatomy**, in the standard's order, to
   `docs/brd/[change-name]-BRD.md`. Objectives are `BO-N`, business requirements `BR-N`, assumptions
   and dependencies `ASM-NNN` / `DEP-NNN` per `tables.md`. Carry `/idea` assumptions forward with
   their Status rather than as prose; every assumption states `If false`.
3. **Keep an unquantified objective in the register.** One carrying `[TBD]` with an owner and a date
   is a tracked gap; the same objective omitted is invisible.
4. **Write §12 as a traceability skeleton** — each objective against the tolerance expected to
   quantify it, or an **explicit blank**. A blank row is the useful one; an omitted row is a gap
   nobody can see.
5. **Give every Appendix A row a named owner.** Where the estate has none, write **Unowned — open**;
   recording it is the finding, and resolving it is not this document's to do.
6. Present the coverage summary — objectives quantified against declared gaps, cost-of-failure
   statements against objectives carrying exposure, routed statements and their destinations, and the
   size read.

**Completion:** the document is saved, every ★ section is populated or carries a declared gap, and
no cell holds a figure the source did not supply.

## Phase 3 — Run the gate [AFK]

Assess the document just written against **BH-1 – BH-10**, applying the verdict vocabulary, the
evidence rule and the outcome derivation in [GATE-PROTOCOL.md](../review-brd/GATE-PROTOCOL.md), and
emit the protocol's report format adapted per [REFERENCE.md](REFERENCE.md).

**The standard puts this gate in the author's hands** — a document's readiness is its author's to
establish, not its recipient's to adjudicate afterwards. It is **not** the independent review: §8
names a reviewer who did not author the document as its highest-value Tier 1 control, and a
self-assessment cannot be one. Name `/review-brd` as the pass this one does not replace.

**Completion:** all ten items carry a verdict citing the section it was read from or naming what is
absent, one of the four outcomes is derived by precedence, and every declared gap names where it must
reappear downstream.

---

## Rules

- **Never invent a figure, a consequence, an owner or a date to fill a cell.** A `[TBD]` with a named
  owner and a date is a declared gap and passes the bar; a value nobody can defend is the failure the
  standard exists to prevent, and a `[TBD]` missing either half is a hole that fails it.
- **Never restate the standard in this skill's prose.** The pack is the source of truth, and
  `STANDARD.md` is a generated extract — hand-editing it is how the pack stops being authoritative.
- **Never drop a Solution requirement because no document receives it** — route and register it.
- Objectives and business requirements state outcomes. Anything naming a workflow, system, vendor or
  figure belongs to the ORD, the SOAP, or the referred register, and is routed there.
- Never write Phase 2 without the Phase 1 confirmation, and never ask a question during Phase 1.
- Never emit a score or a percentage at Phase 3 — ten verdicts and one of four outcomes.
- Never present the Phase 3 assessment as an independent review, or let it stand in for one.
- Where the standard and this skill disagree, the standard wins — say so, because a disagreement is a
  defect in this skill.

## Failure Modes

| Condition | Behaviour |
|---|---|
| Neither the live pack nor `STANDARD.md` is readable | Stop. Authoring from a recalled standard drifts silently, and the drift is invisible in the output |
| Source is a solution pitch — a vendor, a feature, a design | Extract the outcome behind it. Where the source states no business outcome at all, stop and report there is no business case to document |
| No cost-of-failure derivable for an objective carrying exposure | Raise it at the Phase 1 gate as an open question. Never invent a consequence, and never quietly drop the objective |
| Every objective carries `[TBD]`, or the gap sits on the objective the change is funded against | Report at the Phase 1 gate before writing. The two limits fail BH-1 however well-owned the gaps are, and no downstream document repairs an unquantified business case |
| No approving GM identifiable | Record BH-6 absent and surface it. Never infer an approver's name |
| An Appendix A row has no owning team | Write **Unowned — open**. It is the unowned-gap outcome at Phase 3, not a blank cell |
| Phase 3 derives *Not accepted for ORD development* | Name the absent bar items and offer to return to Phase 2. No authority question arises — refusing your own document needs no right |
| A BRD already exists at the target path | Stop. "A BRD already exists at docs/brd/. Confirm overwrite or provide a new name." |
| `/write-ord` is asked for and no BRD exists | Say so and offer this skill — an ORD task against a missing BRD is a BRD task in disguise |
