---
name: scope-check
category: session
description: Mid-session gut check that compares current progress against agreed goals and flags scope creep. Use when user runs /scope-check, the session feels like it's drifting, or more than 3 tickets have been added since the session started.
---

# Scope Check

Stop and compare what is actually happening against what was agreed at session start. Surface scope creep early before it derails the session.

## When to Use

- Mid-session when things feel like they're expanding
- More than 3 unplanned tickets have been added
- The original goals haven't been touched yet
- User or AI runs /scope-check explicitly

## Process

1. Read the session goals from the current DEVLOG entry or session start.
2. Review `docs/kanban.md` — what's been added, what's In Progress, what's Done.
3. Compare: are the original goals being addressed? What has been added that wasn't planned?
4. Produce the scope check report.
5. Force an explicit decision on each out-of-scope item.

## Output Format

```markdown
## Scope Check — YYYY-MM-DD

### Agreed Goals This Session
1. [Goal 1]
2. [Goal 2]
3. [Goal 3]

### Progress Against Goals
- [Goal 1]: Done / In Progress / Not started
- [Goal 2]: Done / In Progress / Not started
- [Goal 3]: Done / In Progress / Not started

### Unplanned Work Added
- [Ticket or task not in original goals] — added because [reason]

### Recommendation
[Stay the course / Defer unplanned items / Explicitly expand scope]
```

## Decision Required

For each unplanned item, the user must choose one:
- **Keep** — explicitly expand scope for this session
- **Defer** — add to backlog, do not work on it now
- **Drop** — remove entirely

## Rules

- Do not implement anything new until the scope decision is made.
- If all original goals are done and there is capacity, unplanned work may be promoted — but only with explicit confirmation.
- Log the scope check outcome in DEVLOG under "Decisions Made."

## Stale Estimate Detection

When unplanned work is added or scope changes are confirmed, check for stale estimates:

1. Read estimate status from the active PRD header (`Estimate Status: Current | Stale | Not estimated`)
2. If scope changed and status is `Current`, update to `Stale` in the PRD:
   ```
   **Estimate Status:** Stale — scope changed YYYY-MM-DD
   ```
3. Surface to human:
   ```
   ⚠️ Estimates are now stale — scope has changed.
   Run /user:estimate to update before the next /sprint-start.
   ```
4. Never auto-update estimates — flag only.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No session goals recorded in DEVLOG or at start | Reconstruct the agreed goals with the user before comparing — don't invent them. |
| An unplanned item has no decision | Force an explicit Keep / Defer / Drop — never leave it ambiguous. |
| Tempted to keep building mid-check | Stop — implement nothing new until the scope decision is made. |
| All goals done with capacity left | Unplanned work may be promoted, but only with explicit confirmation. |
| Scope changed and estimates are `Current` | Mark them `Stale` in the PRD and flag — never auto-update estimates. |
| User expands scope | Log the decision in DEVLOG under "Decisions Made." |
