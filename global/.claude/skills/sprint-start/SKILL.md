---
name: sprint-start
description: Open a new sprint for the current project. Reads the global sprint calendar for dates and active projects, pulls carry-in from the previous sprint-end record, captures goals and deadlines, and writes a sprint-start document. Use when user runs /sprint-start or a new sprint period begins.
---

# Sprint Start

Open a new sprint for the current project. Pulls context automatically from the global calendar and previous sprint record, then confirms with the user before writing anything.

## Process

1. **Read the sprint calendar** — `~/.claude/sprints/calendar.md`
   - Identify the current sprint by today's date.
   - If no current sprint exists, ask the user:
     - "No active sprint found in the calendar. Would you like me to generate the next sprint dates, or do you have a calendar to sync from?"
     - If generate: propose start = today, end = today + 13 days, confirm before adding to calendar.
     - If sync: ask the user to provide the sprint name, start, and end dates.

2. **Read active projects** — from the calendar entry for this sprint.
   - Confirm this project is listed. If not, offer to add it.

3. **Pull carry-in** — read `docs/sprints/sprint-NN.md` for the previous sprint.
   - Extract the "Carry Over" section.
   - Pre-populate carry-in items for confirmation.
   - If no previous sprint record exists, note this is the first sprint for this project.

4. **Surface global backlog items** — read `~/.claude/backlog.md`:
   - Flag any items relevant to this sprint or project
   - Ask: "These items are in the global backlog — are any worth including in this sprint's goals?"
   - Do not add them automatically — human confirms

5. **Surface active known issues** — read `docs/known-issues.md`:
   - List any Active issues with High or Critical impact
   - Ask: "These known issues are unresolved — should any be scheduled as tickets in this sprint?"
   - Do not add them automatically — human confirms

6. **Gather sprint goals** — ask the user:
   - What are the goals for this sprint? (1–5)
   - Are there any fixed deadlines within the sprint?
   - Any context or constraints worth noting?

5. **Present the full draft** for confirmation before writing.

6. **Write** `docs/sprints/sprint-NN.md` using the template below.

7. **Update active PRDs** — for any PRD in `docs/prd/active/`, update the `Sprint:` field to the current sprint name if blank or outdated.

8. **Update** `docs/kanban.md` if relevant tickets should be flagged for this sprint.

## Sprint Record Template (Start Section)

```markdown
# Sprint-NN: [Project Name]

**Sprint:** Sprint-NN
**Period:** YYYY-MM-DD → YYYY-MM-DD
**Project:** [repo name]

---

## Sprint Start

**Date opened:** YYYY-MM-DD

### Goals
1. [Goal 1]
2. [Goal 2]
3. [Goal 3]

### Carry-In
Items brought forward from Sprint-NN-1:

- [ ] [Ticket or task carried in] — carried because [reason]

_None_ (if first sprint or no carry-in)

### Deadlines This Sprint
| Item | Deadline | Notes |
|------|----------|-------|
| | | |

### Notes / Constraints
[Anything relevant to how this sprint should be run]

---

## Sprint End

_To be completed at sprint close — run `/user:sprint-end`_
```

## Rules

- Never write to `docs/sprints/` without user confirmation of the draft.
- Never create a sprint record if the sprint calendar has no matching entry — resolve the calendar first.
- If carry-in items are pulled, present them clearly and let the user remove any that are no longer relevant.
- Suggest running `/user:standup` at the start of each session during the sprint.

## Sprint Capacity Check

After sprint goals are confirmed and tickets are assigned, check capacity:

1. Read `sprint-capacity-points` and `sprint-capacity-tokens` from `~/.claude/preferences.md` (defaults: 20pts, 400k tokens if not set).
2. Total the story points and token cost bands of all tickets in the sprint:
   - Token band totals: S=20k, M=50k, L=140k, XL=200k+ (use midpoint of range for totalling)
3. Present the capacity summary:

```
## Sprint Capacity — Sprint-NN

| Metric | Used | Limit | Status |
|--------|------|-------|--------|
| Story Points | Npts | 20pts | ✅ Within / ⚠️ Over |
| Token Budget | ~Nk | 400k | ✅ Within / ⚠️ Over |

⚠️ XL tickets requiring /break-down: [none / #N, #N]
```

4. If either limit is exceeded, warn — never block:
   ```
   ⚠️ Sprint is over capacity (Npts / 20pt limit).
   Consider deferring lower-priority tickets or accepting the overload.
   ```
5. If any XL tickets exist, flag explicitly:
   ```
   ⚠️ #N [ticket name] is estimated XL — run /break-down before /build.
   ```
6. Human decides whether to adjust or proceed.

---

## Context Health Check

After the capacity check, check `context-health-last-run` in `~/.claude/preferences.md`.
If more than 7 days ago (or missing):

```
⚠️ Context health check overdue (last run: N days ago).
Consider running /context-health before this sprint begins to avoid mid-session compaction.
```

Do not block sprint start — this is advisory only.
