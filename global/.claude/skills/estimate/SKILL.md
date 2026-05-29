---
name: estimate
category: pipeline
description: Estimate AI token cost and development complexity for a feature, module, or ticket. Produces token cost bands (S/M/L/XL) and story points (1/2/3/5/8/13). AI suggests all estimates as a table, human confirms in aggregate. Use when user runs /estimate, scope has changed, or a planning document needs estimates updated.
---

# Estimate

Generate or update token cost and complexity estimates for the current feature, module set, or ticket. Two metrics tracked separately — AI execution cost drives smart zone decisions, story points drive sprint capacity planning.

## Metrics

### AI Token Cost Bands
| Band | Token Range | Implication |
|------|------------|-------------|
| S | < 20k | Single focused task, fits in one session |
| M | 20–80k | Standard feature ticket |
| L | 80–200k | Complex ticket, monitor context |
| XL | 200k+ | **Must run `/break-down` before `/build`** |

### Story Points
1, 2, 3, 5, 8, 13 — Fibonacci scale. Higher values reflect increasing uncertainty as much as effort.

## When to Use

- After `/idea` grill — feature-level estimate
- After `/write-prd` Phase 2 — per-module estimates
- After `/sprint-start` — per-ticket capacity check
- When scope changes and estimates are flagged as stale
- On demand: `/user:estimate` at any point

## Scope Detection

Determine what to estimate based on context:

1. **Idea level** — if called from `/idea` or no PRD exists: estimate the feature as a whole
2. **Module level** — if a PRD exists with modules identified: estimate per module + rolled-up total
3. **Ticket level** — if called on a specific ticket or kanban context: estimate that ticket

Ask the user to clarify if scope is ambiguous.

## Process

1. Read available context — `idea.md`, PRD, `kanban.md`, and codebase if accessible
2. For each item in scope, reason about:
   - **Token cost:** How much code needs to be written? How complex are the integrations? How many files touched?
   - **Story points:** How well understood is the problem? How many dependencies? How much risk?
3. Produce an estimate table for human review
4. On confirmation, write estimates to the relevant document

## Estimate Table Format

```markdown
## Estimates — [Feature / Module / Ticket Name]

| Item | Token Cost | Story Points | Reasoning |
|------|-----------|-------------|-----------|
| [Module/Ticket] | M (20–80k) | 5 | [one sentence] |
| [Module/Ticket] | S (<20k) | 2 | [one sentence] |
| [Module/Ticket] | L (80–200k) | 8 | [one sentence] |
| **Total** | **L** | **15** | |

⚠️ XL items flagged: [none / #N requires /break-down before /build]

Confirm these estimates or adjust any values before I write them to the document.
```

## After Confirmation

Write estimates to the relevant document:

**`idea.md`** — add to feature record:
```markdown
## Estimates
**AI Token Cost:** M (20–80k)
**Story Points:** 8
**Last estimated:** YYYY-MM-DD
**Status:** Current
```

**PRD** — add to each module in Implementation Decisions:
```markdown
- Auth module: M / 5pts
- Dashboard: L / 8pts
- **Total: L / 13pts**
```

**`kanban.md` ticket** — add inline:
```markdown
- [ ] [AFK] #N Ticket name `M | 5pts`
```

## XL Handling

If any item is estimated XL:
```
⚠️ XL estimate — #N [ticket name]

This ticket is estimated at 200k+ tokens and cannot be safely
executed by /build in a single pass.

Run /user:break-down on this ticket before proceeding to /build.
```

## Stale Estimate Detection

When scope changes (tickets added, removed, or modified), flag:
```
⚠️ Estimates may be stale — scope has changed since last estimate.
Run /user:estimate to update.
```

Add `**Status:** Stale` to the estimate block in the relevant document.

## Actuals Tracking

After `/build` completes a ticket, the actual token band is recorded in `kanban-archive.md`:
```markdown
- [x] [AFK] #N Ticket name `estimated: M | actual: M` ✓
- [x] [AFK] #N Ticket name `estimated: M | actual: L` ⚠️ over
```

Over-band actuals (estimated M, actual L) are flagged for calibration awareness.

## Rules

- Always present estimates as a table — never one at a time
- Never write estimates without human confirmation
- XL estimates always flag `/break-down` requirement — never let them through to `/build` silently
- Story points reflect uncertainty as much as effort — an 8 doesn't mean 4× the work of a 2
- Token cost estimates are AI execution cost only — not wall-clock time or human effort
- Stakeholder-facing documents receive story points only — never token bands

## Token Recording (Automatic)

After estimates are confirmed and written, record in `docs/tokens/[feature-name].md`:

```markdown
### Estimate
**Date range:** YYYY-MM-DD
**Sessions:** N
**Input:** ~Nk tokens — Read: [PRD, kanban, codebase modules]
**Output:** ~Nk tokens — [estimate table]
**Total:** ~Nk ([band])
**Pre-build estimate recorded:** [band confirmed by human]
```

See `~/.claude/skills/token-report/TOKEN-RECORDING.md` for estimation guidance.
