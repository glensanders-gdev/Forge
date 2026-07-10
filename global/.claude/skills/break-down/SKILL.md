---
name: break-down
category: pipeline
version: 1.1.0
description: Split a large ticket or feature into smaller tickets within the smart zone limit, with HITL/AFK tags and blocking relationships. Use when user runs /break-down, a ticket is too large, or a task exceeds the smart zone of 100k tokens.
---

# Break Down

Split a large ticket or vague task into concrete, well-scoped tickets that each stay within the smart zone (<100k tokens). Add HITL/AFK tags and blocking relationships automatically.

> Splitting one existing ticket is this skill's job. To turn a whole plan or PRD into a fresh ticket set, use [`/to-tickets`](../to-tickets/SKILL.md) — it drafts the vertical slices and delegates here when a slice is still too big.

## When to Use

- A ticket is estimated to exceed 100k tokens of work
- A ticket is vague or covers multiple concerns
- The user explicitly runs /break-down on a ticket or feature

## Process

1. Read the target ticket from `docs/kanban.md`, or ask the user to describe it.
2. Read the active PRD from `docs/prd/active/` for context.
3. Identify natural split points — by layer `[UI]`/`[DATA]`/`[LOGIC]`/`[SYNC]`/`[INFRA]`, by dependency order, or by concern.
4. Draft the breakdown and present it to the user before writing to kanban.
5. On confirmation, update `docs/kanban.md` — replace the original ticket with the new ones, preserving the original ticket number with a note.

## Splitting Rules

- Each ticket should be completable in one focused agent run.
- **Prefer vertical slices** — each split should cut a narrow but complete path through the layers it needs, independently demoable. A ticket touching several layers is normal and good; that's a tracer bullet, not a problem to split away.
- Split by dependency order — foundational work first.
- Tag each ticket `[HITL]` or `[AFK]`.
- Add `blocked-by: #N` notation where a ticket cannot start until another completes.
- **Split by layer only as a last resort** — when a single vertical slice still exceeds the smart zone, carve it by layer (`[UI]`/`[DATA]`/`[LOGIC]`/`[SYNC]`/`[INFRA]`); otherwise keep slices vertical.

## Output Format

Present the breakdown before writing:

```markdown
## Breakdown: #N [Original Ticket Name]

Original ticket #N will be replaced with:

- [ ] [AFK] #N.1 [Sub-task] `[LOGIC]`
- [ ] [AFK] #N.2 [Sub-task] `[UI]` `blocked-by: #N.1`
- [ ] [HITL] #N.3 [Sub-task requiring human] `blocked-by: #N.2`

Confirm to update kanban.md?
```

## Rules

- Never write to `kanban.md` without user confirmation.
- Keep the original ticket number visible in the breakdown — prefix sub-tickets as `#N.1`, `#N.2` etc.
- If a ticket cannot be broken down further without losing coherence, note that and suggest the smart zone limit be accepted as a known risk for that ticket.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Target ticket not found in `docs/kanban.md` | Ask the user to describe it rather than guessing scope. |
| No PRD in `docs/prd/active/` | Proceed from the ticket and user input; note the breakdown lacks PRD context. |
| Ticket can't be split without losing coherence | Say so and recommend accepting the smart-zone limit as a known risk — don't force an artificial split. |
| A sub-ticket still exceeds the smart zone | Break it down further before writing — every ticket must fit one focused run. |
| A sub-ticket touches multiple layers | Fine — a vertical slice cuts through layers. Only split by layer if it *also* exceeds the smart zone. |
| Tempted to write to kanban directly | Present the breakdown and get confirmation first — never write unconfirmed. |
