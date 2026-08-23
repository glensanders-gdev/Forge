---
name: "write-reqs"
description: "Author a PRD and an ORD together from one source — classify needs into functional (PRD) and operational (ORD), delegate each document end-to-end to $write-prd and $write-ord via a binding authoring brief (each keeping its own confirmation gate), then own the bidirectional BRD↔PRD↔ORD cross-link neither sibling can complete alone. Use when the user runs $write-reqs, or wants both a PRD and an ORD from a single grill, transcript, or BRD rather than authoring either standalone."
metadata:
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write Reqs

Author a **PRD and ORD as a matched pair** from one source. Per ADR-0001 the BRD is the single
origin and the two documents are siblings — `$write-reqs` is the only place their shared ID
namespace and full bidirectional traceability are owned. It **orchestrates** the two standalone
skills end-to-end via the handoff-with-brief pattern, each keeping its own confirmation gate; it
never reproduces their templates or quality rules.

**The two halves keep their own schemas.** A PRD story is narrative with declarative criteria rows;
an ORD requirement is a register row. They are not merged and their tables are not reconciled — the
only thing joining them is the ORD's **Appendix B — PRD Cross-Link**, held once and read in both
directions rather than mirrored as a column in each document.

One source → one classification → two briefs → two documents (two gates) → one gated cross-link.

**Authoring standards** — shared with both siblings, never restated here:
`~/.codex/forge/rules/requirements/language.md` and `~/.codex/forge/rules/requirements/tables.md`, plus
`~/.codex/forge/rules/requirements/ai.md` **conditionally** — where a delivered component's behaviour is
learned or generated rather than specified. Classification (Phase 1) settles the trigger once for
both halves, so the siblings never disagree about whether that ruleset is in force.

## Phase 1 — AFK Joint Classification [AFK]

Route the source into two clean halves so the siblings never fight over or drop a need. No gate
here — each document is confirmed at its own gate in Phase 2.

1. Read the BRD if present (`docs/brd/`) — each business objective is the origin of scope. If
   absent, note it; needs trace to their proximate source instead.
2. Read all other source material (grill summary, transcript, research, prototype, conversation).
3. Classify every need by nature: functional / "what the system does" → PRD; operational / NFR /
   "how it runs" (performance, availability, security, support, recovery) → ORD. Split a
   dual-nature need into a linked PRD story + ORD requirement — never hand the same whole need to
   both.
4. **Settle the AI trigger once, for both halves.** Apply the trigger test in
   `rules/requirements/ai.md` — is any delivered component's behaviour learned or generated rather
   than specified? Record the answer in the split below and pass it in both briefs, so neither
   sibling re-decides it and they cannot disagree. Judge the **delivered solution**, never the
   toolchain that builds it. Where it fires, name the affected components: the trigger is
   per-component, so deterministic needs in the same source are unaffected.
5. Tag provenance per need (BRD objective ID, or proximate source).
6. Collect assumptions and dependencies once, centrally — they are shared, not per-document.
   Carry forward any `$idea` assumptions with their Status rather than restating them.
7. Print the split as orientation and proceed to Phase 2:

```
## Reqs split — [System / Feature]   (orientation — confirm at each document's gate)
PRD-bound (functional):  N needs
ORD-bound (operational): N needs
Cross-links foreseen:    N
Assumptions / dependencies carried: N / N
AI trigger (rules/requirements/ai.md): [fired — components: ... | not fired]
BRD objectives with no coverage in either: [list or none]
Unclassified (blocks authoring): [list or none]
```

### The authoring brief

Each sibling is invoked with a brief. **The brief is binding** — the sibling treats it as its
extraction scope, not as a hint. Without this, each sibling re-extracts from the full source in
its own Phase 1 and the classification above is silently discarded.

```
## Authoring brief — [PRD | ORD] half of [System / Feature]

Invoked by:   $write-reqs (joint authoring)
Scope:        Author the [PRD | ORD] only, from the needs listed below. Do not re-extract
              from the full source. Needs routed to the sibling are out of scope for this
              document.
BRD:          [path, or "none — trace each need to its proximate source"]

Needs (N):
  - [need] — provenance: [BRD-NN | source quote | named stakeholder]

Cross-document context:
  [ORD brief] NFRs the PRD must not hold and this ORD owns: [list]
  [ORD brief] Retain Appendix B — PRD Cross-Link. This is joint authoring, so the
              appendix the template omits for a standalone ORD is required here.
              Leave its PRD# cells unset; $write-reqs fills them in Phase 3.
  [PRD brief] Operational needs routed to the ORD — do not restate them, and do not
              carry their figures: [list]

Shared records: assumptions [ASM-NNN…], dependencies [DEP-NNN…]

On completion: return the document path and the ID range assigned. Suppress your standalone
              next-steps block — $write-reqs owns sequencing.
```

The ORD brief carries the routed NFRs deliberately: it lets the ORD own them **without reading the
PRD**, preserving the ADR-0001 sibling rule. Appendix B is the one thing that cannot be prepared
this way — it needs both ID ranges, which is why it is filled in Phase 3 rather than at authoring.

## Phase 2 — HITL Author both [HITL]

1. **Author the PRD — invoke `$write-prd` with the PRD brief.** It runs its native flow:
   Phase-1 explore → **its own confirmation gate** → writes the PRD with `PRD-001` IDs to
   `docs/prd/active/`. Follow all rules from the write-prd skill; do not restate them here.
2. **Author the ORD — invoke `$write-ord` with the ORD brief.** Native flow: Phase-1 ingest
   → **its own confirmation gate** → writes the ORD with `ORD-001` IDs to `docs/ord/`. Follow all
   rules from the write-ord skill.
3. Record each returned document path and ID range before proceeding.

## Phase 3 — HITL Cross-link [HITL]

Both documents now exist and **both have already been approved at their own gates**. This pass
edits approved content, so it is gated in its own right.

1. Prepare the cross-link set — do not write yet:
   - **ORD Appendix B — PRD Cross-Link** is the home for the link, one row per linked
     requirement: `ORD#` → the requirement's ID, `Section` → its register subsection (e.g. `3.2.1`),
     `PRD#` → the real `PRD-NNN` it backs. The ORD template names this appendix as the one link its
     register cannot hold, and names this skill as what populates it — write the column headings
     exactly as the template gives them, and never invent a cross-link column in the register.
   - **The PRD side carries no ORD column.** Its traceability matrix ends at `SOAP Ref`, because in
     this chain the ORD is downstream of the SOAP. Appendix B is therefore the single home for the
     link and is read in both directions; do not add a column to the PRD matrix to mirror it, and do
     not restate the mapping anywhere else.
   - **NFR-home rule**: the ORD *owns* the NFR. Any NFR stated in full in the PRD is a duplication
     to resolve by deleting the PRD copy — `$write-prd` already forbids carrying a technical figure,
     so a PRD holding one is a defect at source, not a citation to rewrite. Where the story genuinely
     depends on a tolerance, the PRD cites it per its own rule (the BRD cost-of-failure), **not** an
     ORD section. Record the deletion in the change set below so the human sees it before it applies.
   - Orphans across the joined chain: any requirement with no BRD objective and no source; any BRD
     objective with no resulting requirement in either document.

2. **Gate — present the exact change set and require typed `CONFIRM`:**

```
## Cross-link pass — changes to two approved documents

Links to add:      N   (ORD Appendix B rows)
NFR text to DELETE from the PRD (the ORD owns it):
  - PRD §[x] "[first line of text to be removed]" → owned by [System] ORD §[y] (ORD-NNN)
Orphans / gaps to flag (no content change): N

Both documents were approved at their own gates. This edits them after approval.
Type CONFIRM to apply, or list the changes to drop.
```

3. On `CONFIRM`, apply the change set. Never apply any part of it before the typed response.
4. Present a joint coverage summary: PRD stories, ORD requirements, cross-links established,
   assumptions and dependencies recorded, remaining orphans/gaps.
5. Suggest next steps once, here — `$testplan`, then `$to-tickets`, then `$write-ac`.

## Rules

- Never let `Happy path`, `Error` or `Edge` reach the joint output as a scenario value, and never
  head that column `Type` — the values are `Sunny Day`, `Rainy Day` and `Edge Case`, the column is
  `Scenario`. Delegation does not transfer this check: scan the returned PRD for the old terms
  before the Phase 3 gate and report any found, in the change set, as a defect to correct.
- Never inline or reproduce the `$write-prd` or `$write-ord` templates, gates, or quality rules —
  invoke the skills; a copy drifts the moment a sibling changes.
- Never invoke a sibling without a brief — an unbriefed sibling re-extracts from the full source
  and silently discards the Phase 1 classification.
- Never collapse the two document gates into one — each document keeps its own confirmation.
  Phase 1 is ungated routing only.
- Never edit or delete content in an approved document without the Phase 3 typed `CONFIRM` — the
  cross-link pass runs after both human gates and must not treat that approval as covering it.
- Never hand the same whole need to both siblings — classify it to one, or split a dual-nature
  need into a linked PRD story / ORD requirement pair.
- Never leave an ORD Appendix B `PRD#` cell unset once both documents exist — closing that gap is
  the entire reason this skill exists.
- Never invent a cross-link column in either document. Appendix B is the only home the templates
  provide; if a link will not fit there, report it rather than adding a column to hold it.
- Never give an `ORD-NNN` ID to a functional need or a `PRD-NNN` ID to an operational one.
- Never reuse a retired `PRD-NNN`, `ORD-NNN`, `ASM-NNN` or `DEP-NNN` ID.
- Never let a sibling emit its standalone next-steps block — sequencing is owned here, once.
- Never silently resolve an orphan or coverage gap — flag it.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No BRD found | Note it. Proceed — needs trace to proximate source; PRD↔ORD cross-links still apply. |
| Only functional content (no operational needs) | Do not discard the classification. Hand the completed PRD half straight to `$write-prd` as a brief and tell the user an ORD is not warranted — never make them re-run from scratch. (Vice-versa for ORD-only.) |
| Active PRD or ORD already at target path | The invoked sibling stops on its own existing-file rule — relay it; confirm overwrite or rename before re-running. |
| A need resists classification | List it in the Phase-1 split as unclassified and stop for human placement before authoring — do not guess. |
| User rejects one sibling's gate | That document isn't written. Ask whether to revise its half and re-invoke, or author only the other; never run the cross-link pass until both documents exist. |
| User rejects the Phase 3 cross-link gate | Both documents stand as approved. Report which links remain unset; never apply a partial set without a fresh `CONFIRM`. |
| A sibling ignores its brief and re-extracts | Stop before the cross-link pass. Report the scope drift — a document containing needs routed to its sibling has the wrong ID prefixes and cannot be cross-linked correctly. |
| A sibling changes its Phase contract | Fix the invocation here; never copy the sibling's logic in to compensate. |
| Authored ORD has no Appendix B | The brief required it and the template omits it only for a standalone ORD. Stop before the cross-link pass and report it — never add the appendix here, and never write the links into the register instead. Re-invoke `$write-ord` with the brief restated, or ask the human to add the appendix. |
| Appendix B column headings differ from the ORD template | Report the mismatch and stop. The headings are `ORD#`, `Section`, `PRD#` — writing into renamed columns produces an ORD its own reviewer (`$review-ord`) reads as non-conforming. |
