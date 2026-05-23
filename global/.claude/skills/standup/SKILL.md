---
name: standup
description: Summarise the last session, state today's goals, and surface any blockers. Use when user wants a session summary, runs /standup, or wants to orient themselves at the start of a working session.
---

# Standup

Generate a concise standup summary from the project's living documents. No input required from the user — draw from existing files.

## Process

1. Read `~/.claude/priorities.md` — global feature priority order.
2. Read `~/.claude/pi/[current-pi]/plan.md` — current PI release dates and Go/No Go dates.
3. Read `docs/DEVLOG.md` — most recent entry only.
4. Read `docs/kanban.md` — current In Progress, Blocked, and top Backlog items.
5. Read active PRDs — check Delivery Type and Due Dates for deadline risk.
6. Read `docs/prd/active/` — confirm what feature is currently in flight.
7. **Run automatic checks:**
   - If today is within 5 days of a Go/No Go date → flag it
   - If today is within 3 days of an internal due date → flag deadline risk
   - If today is within 7 days of an external due date → flag deadline risk
   - If Delivery Type is Fixed Deadline or Fixed Both → run scope check summary
8. Produce the standup report.
9. Ask: "Are these the right goals for today, or do you want to adjust?"

## Output Format

```markdown
## Standup — YYYY-MM-DD

### ⚠️ Flags (if any)
- 📋 Go/No Go for PI-N-RN due [date] — [N days away]
- 🔴 [Feature] deadline at risk — [N days to internal/external due date]
- 🟡 Fixed Deadline feature — scope check summary below

### Yesterday
[What was completed or progressed in the last session — from DEVLOG]

### Today
[Top 1–3 tickets to work on — ordered by global priority]

### Blockers
[Any HITL tasks waiting on human input, or external dependencies]

### Feature in Flight
[Active PRD name, delivery type, target release, current completion status]
**Token spend so far:** ~Nk across N phases, N sessions (read from docs/tokens/[feature].md if exists)
**Active known issues:** [N issues from docs/known-issues.md — list KI-NNN titles, or "None"]

### Scope Check (Fixed Deadline features only)
[Tickets remaining vs days to deadline — proposed options if at risk]
```

## Rules

- Keep it brief — this is orientation, not a report.
- If no DEVLOG entry exists, say so and ask the user to confirm goals from scratch.
- If there are no blockers, say "None."
- Do not begin implementation until the user confirms today's goals.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `DEVLOG.md` missing or empty | Note "No session history found — this may be a fresh project." Ask user to state goals directly. |
| `kanban.md` missing | Note "No kanban found." Ask user to confirm goals and whether to run `/write-prd` first. |
| `priorities.md` missing | Skip priority ordering. Surface tickets in kanban order. |
| No active sprint in calendar | Note "No active sprint found." Suggest `/sprint-start`. |
| No active PRD | Note "No active PRD." State which feature is in progress based on kanban if possible. |
| Go/No Go date calculation fails | Skip deadline flag. Do not guess dates. |
