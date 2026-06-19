---
name: write-reqs
category: pipeline
description: Author a PRD and an ORD together from one source — classify needs into functional (PRD) and operational (ORD), delegate each document end-to-end to /write-prd and /write-ord (each keeping its own confirmation gate), then own the bidirectional BRD↔PRD↔ORD cross-link neither sibling can complete alone. Use when the user runs /write-reqs, or wants both a PRD and an ORD from a single grill, transcript, or BRD rather than authoring either standalone.
---

# Write Reqs

Author a **PRD and ORD as a matched pair** from one source. Per ADR-0001 the BRD is the single
origin and the two documents are siblings — `/write-reqs` is the only place their shared ID
namespace and full bidirectional traceability are owned. It **orchestrates** the two standalone
skills end-to-end, each keeping its own confirmation gate; it never reproduces their templates or
quality rules.

One source → one classification → two documents (two gates) → one joined matrix.

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
4. Tag provenance per need (BRD objective ID, or proximate source).
5. Print the split as orientation and proceed to Phase 2:

```
## Reqs split — [System / Feature]   (orientation — confirm at each document's gate)
PRD-bound (functional):  N needs
ORD-bound (operational): N needs
Cross-links foreseen:    N
BRD objectives with no coverage in either: [list or none]
```

## Phase 2 — HITL Author both, then cross-link [HITL]

1. **Author the PRD — invoke `/write-prd` with the PRD-bound half.** It runs its native flow:
   Phase-1 explore → **its own confirmation gate** → writes the PRD with `PRD-001` IDs to
   `docs/prd/active/`. Follow all rules from the write-prd skill; do not restate them here.
2. **Author the ORD — invoke `/write-ord` with the ORD-bound half.** Native flow: Phase-1 ingest
   → **its own confirmation gate** → writes the ORD with `ORD-001` IDs to `docs/ord/`. Follow all
   rules from the write-ord skill.
3. **Cross-link pass (the joint payload).** Both documents now exist — fill what neither could
   standalone:
   - PRD matrix `ORD NFR Ref` column → real `ORD-NNN` for every linked story.
   - ORD matrix `PRD Req` reference → real `PRD-NNN` for every operational req that backs a story.
   - Enforce the **reciprocal NFR-home rule**: the PRD *cites* ORD sections, the ORD *owns* the
     NFR. If any NFR is stated in full in both, delete the PRD copy and leave a citation.
   - Re-flag orphans across the joined chain: any req with no BRD objective and no source; any
     BRD objective with no resulting requirement in either document.
4. Present a joint coverage summary: PRD stories, ORD requirements, cross-links established,
   remaining orphans/gaps.

## Rules

- Never inline or reproduce the `/write-prd` or `/write-ord` templates, gates, or quality rules —
  invoke the skills; a copy drifts the moment a sibling changes.
- Never collapse the two document gates into one — each document keeps its own confirmation.
  Phase 1 is ungated routing only.
- Never hand the same whole need to both siblings — classify it to one, or split a dual-nature
  need into a linked PRD story / ORD requirement pair.
- Never leave a cross-link column as `—` once both documents exist — closing that gap is the
  entire reason this skill exists.
- Never give an `ORD-NNN` ID to a functional need or a `PRD-NNN` ID to an operational one.
- Never reuse a retired `PRD-NNN` or `ORD-NNN` ID.
- Never silently resolve an orphan or coverage gap — flag it.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No BRD found | Note it. Proceed — needs trace to proximate source; PRD↔ORD cross-links still apply. |
| Only functional content (no operational needs) | Stop. "No operational requirements — author a standalone PRD with /write-prd instead." (vice-versa for ORD-only). |
| Active PRD or ORD already at target path | The invoked sibling stops on its own existing-file rule — relay it; confirm overwrite or rename before re-running. |
| A need resists classification | List it in the Phase-1 split as unclassified and stop for human placement before authoring — do not guess. |
| User rejects one sibling's gate | That document isn't written. Ask whether to revise its half and re-invoke, or author only the other; never run the cross-link pass until both documents exist. |
| A sibling changes its Phase contract | Fix the invocation here; never copy the sibling's logic in to compensate. |
