---
name: "write-reqs"
description: "Author a PRD and an ORD together from one source — classify needs into functional (PRD) and operational (ORD), delegate each document end-to-end to $write-prd and $write-ord via a binding authoring brief (each keeping its own confirmation gate), then own the bidirectional BRD↔PRD↔ORD cross-link neither sibling can complete alone. Use when the user runs $write-reqs, or wants both a PRD and an ORD from a single grill, transcript, or BRD rather than authoring either standalone."
metadata:
  category: pipeline
  version: 1.1.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Write Reqs

Author a **PRD and ORD as a matched pair** from one source. Per ADR-0001 the BRD is the single
origin and the two documents are siblings — `$write-reqs` is the only place their shared ID
namespace and full bidirectional traceability are owned. It **orchestrates** the two standalone
skills end-to-end via the handoff-with-brief pattern, each keeping its own confirmation gate; it
never reproduces their templates or quality rules.

One source → one classification → two briefs → two documents (two gates) → one gated cross-link.

**Authoring standards** — shared with both siblings, never restated here:
`~/.codex/forge/rules/requirements/language.md` and `~/.codex/forge/rules/requirements/tables.md`.

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
5. Collect assumptions and dependencies once, centrally — they are shared, not per-document.
   Carry forward any `$idea` assumptions with their Status rather than restating them.
6. Print the split as orientation and proceed to Phase 2:

```
## Reqs split — [System / Feature]   (orientation — confirm at each document's gate)
PRD-bound (functional):  N needs
ORD-bound (operational): N needs
Cross-links foreseen:    N
Assumptions / dependencies carried: N / N
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
  [ORD brief] NFRs the PRD cites and this ORD must own: [list]
  [PRD brief] Operational needs routed to the ORD — cite, never restate: [list]

Shared records: assumptions [ASM-NNN…], dependencies [DEP-NNN…]

On completion: return the document path and the ID range assigned. Suppress your standalone
              next-steps block — $write-reqs owns sequencing.
```

The ORD brief carries the PRD's NFR citations deliberately: it lets the ORD own what the PRD
cites **without reading the PRD**, preserving the ADR-0001 sibling rule.

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
   - PRD matrix `ORD NFR Ref` column → real `ORD-NNN` for every linked story.
   - ORD matrix `PRD Ref` column → real `PRD-NNN` for every operational requirement backing a story.
   - **Reciprocal NFR-home rule**: the PRD *cites* ORD sections, the ORD *owns* the NFR. Any NFR
     stated in full in both is a duplication to resolve by deleting the PRD copy and leaving a citation.
   - Orphans across the joined chain: any requirement with no BRD objective and no source; any BRD
     objective with no resulting requirement in either document.

2. **Gate — present the exact change set and require typed `CONFIRM`:**

```
## Cross-link pass — changes to two approved documents

Links to add:      N   (PRD matrix: N · ORD matrix: N)
NFR text to DELETE from the PRD (replaced by a citation):
  - PRD §[x] "[first line of text to be removed]" → cite [System] ORD §[y] (ORD-NNN)
Orphans / gaps to flag (no content change): N

Both documents were approved at their own gates. This edits them after approval.
Type CONFIRM to apply, or list the changes to drop.
```

3. On `CONFIRM`, apply the change set. Never apply any part of it before the typed response.
4. Present a joint coverage summary: PRD stories, ORD requirements, cross-links established,
   assumptions and dependencies recorded, remaining orphans/gaps.
5. Suggest next steps once, here — `$testplan`, then `$to-tickets`, then `$write-ac`.

## Rules

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
- Never leave a cross-link column as `—` once both documents exist — closing that gap is the
  entire reason this skill exists.
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
