---
name: "evolve"
description: "Review High confidence instincts and promote worthy ones to formal Forge skills. Surfaces all unpromoted High confidence instincts, presents each for human decision, and triggers $write-a-skill with the instinct as the brief. Use when user runs $evolve or after several sessions of $learn activity."
metadata:
  category: framework
  version: 1.0.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Evolve

Promote High confidence instincts into formal Forge skills. The bridge between "we've noticed a pattern" and "the framework enforces this pattern."

---

## When to Use

- User runs `evolve` explicitly
- After running `$learn` several times and wanting to review what's accumulated
- During a Forge framework maintenance session
- Periodically — monthly or after a PI close

---

## Process

### 1. Load Instincts

Read `~/.codex/forge/instincts/registry.md` and all instinct files in `~/.codex/forge/instincts/`.

Categorise:
- **High confidence, not promoted** — primary candidates for this session
- **Medium confidence** — show as "approaching promotion" for awareness
- **Low confidence** — show count only

### 2. Present Summary

```
## Evolve — Instinct Review

High confidence (ready to promote): N instincts
Medium confidence (approaching): N instincts
Low confidence (accumulating): N instincts

Reviewing High confidence instincts:
```

### 3. Review Each High Confidence Instinct

For each High confidence, unpromoted instinct — one at a time:

```
## instinct-NNN — [title]

Phase: [phase]
Observations: N (first: YYYY-MM-DD, last: YYYY-MM-DD)
Confidence: High

Pattern:
[pattern description]

Behaviour change:
[what the agent should do differently]

---

Promote this instinct to a Forge skill?

PROMOTE — run $write-a-skill with this as the brief
DEFER    — keep as an instinct, review again later
RETIRE   — this pattern is no longer relevant (will be archived)
```

Wait for one of these three responses before moving to the next instinct.

### 4. On PROMOTE

1. Update the instinct file — set `promoted-to-skill: [pending]`
2. Suggest: "Running `write-a-skill` now — the instinct will be the brief."
3. Pass the instinct content as context for the skill design:
   ```
   Skill brief (from instinct-NNN):
   Pattern: [pattern]
   Behaviour change: [behaviour]
   Phase: [phase]
   Observed: N times over [date range]
   ```
4. After skill is written, update the instinct: `promoted-to-skill: [skill-name]`
5. Update registry — mark as Promoted

### 5. On DEFER

Update `last-observed` in the instinct file to today. No other changes.

### 6. On RETIRE

Move the instinct file to `~/.codex/forge/instincts/archived/`. Update registry — mark as Archived with a note.

---

## End of Session Summary

```
## Evolve Complete

Promoted: N instincts → skills
Deferred: N instincts (will appear again next $evolve)
Retired: N instincts (archived)

Medium confidence instincts approaching High:
- instinct-NNN: [title] (N observations — needs N more for High)
- instinct-NNN: [title] (N observations — needs N more for High)

Run learn during sessions to accumulate observations.
```

---

## Rules

- Never auto-promote — every promotion requires explicit PROMOTE from the human
- Present instincts one at a time — never dump the full list
- Retired instincts are archived, never deleted — they are historical records
- Medium confidence instincts are shown for awareness only — not for decision in this session
- A promoted instinct that produces a poor skill should be retired, not left as a false positive

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No High confidence instincts | "No instincts at High confidence yet. Medium confidence instincts: [list]. Keep running $learn to accumulate observations." |
| Registry missing | "No instincts registry found. Run learn to start capturing patterns." |
| All instincts already promoted | "All High confidence instincts have been promoted to skills. Keep running $learn." |
