---
name: "sprint-replan"
description: "Replan the current sprint when unplanned work is injected mid-sprint. Assesses capacity, presents absorb or swap options with ranked swap candidates, updates kanban in place, and appends a replan entry to DEVLOG. Use when user runs $sprint-replan or a new project/feature is injected into an active sprint."
metadata:
  category: pi-release
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Sprint Replan

Handle the injection of unplanned work into an active sprint. The sprint length is fixed — no extension. The only options are absorb (if slack exists) or swap (displace a ticket to make room).

## When to Use

- A new project or urgent feature is injected mid-sprint
- User explicitly runs `sprint-replan`
- `$create-project` prompts a replan after a new project is added

## Process

### 1. Assess Current State

Read `docs/kanban.md` — identify:
- Tickets In Progress (with estimated completion state)
- Tickets in Backlog not yet started
- Tickets marked Done this sprint
- Any slack (backlog tickets with no blocking dependencies and low priority)

Read `docs/sprints/sprint-NN.md` — confirm sprint goals and remaining days.

### 2. Assess the Injection

Ask the user:
- What is the injected work? (ticket description or feature name)
- Estimated size — how many days of work?
- Priority — P1 Critical / P2 High / P3 Normal / P4 Low
- Is this HITL or AFK?

### 3. Determine Options

**Option A — Absorb** (only if slack exists):
- Slack = backlog tickets that are unstarted, low priority, and have no dependents
- State clearly: "There is [N days] of slack in the sprint. The injected work ([N days]) can be absorbed without displacing anything."

**Option B — Swap** (always presented if no slack, or as alternative to absorb):
- Identify swap candidates from unstarted backlog tickets
- Rank by: lowest priority first, then least dependencies, then no HITL requirement
- **Never recommend a ticket that is In Progress or >50% complete**
- Present top 3 candidates with reasoning:

```markdown
## Swap Candidates

1. **#N [Ticket name]** — P3, unstarted, no dependents
   Displacing this frees [N days]. Risk: [low/medium/high]

2. **#N [Ticket name]** — P3, unstarted, blocked-by #M (also displaceable)
   Displacing this frees [N days]. Risk: [low/medium/high]

3. **#N [Ticket name]** — P2, unstarted, no dependents
   Displacing this frees [N days]. Risk: [medium] — higher priority item
```

### 4. Present Replan Summary

```markdown
## Sprint Replan — [Sprint-NN]

**Injected work:** [description]
**Size:** ~[N] days
**Priority:** P[N]

**Recommended option:** Absorb | Swap #N

**If Swap:**
- Displacing: #N [ticket name]
- Reason: [lowest priority, unstarted, no dependents]
- Displaced ticket: → General backlog, flagged "displaced by replan"

**Sprint goals impact:**
- [Goal 1]: [unchanged / at risk / unaffected]
- [Goal 2]: [unchanged / at risk / unaffected]

Type CONFIRM to apply, or choose a different swap candidate (#N).
```

### 5. On CONFIRM

1. Update `docs/kanban.md`:
   - Add injected ticket to In Progress or Backlog as appropriate
   - Move displaced ticket to Backlog with tag: `⚠️ displaced by replan [date]`
2. Update `docs/sprints/sprint-NN.md` — add a replan note to the sprint record
3. Append to `docs/DEVLOG.md`:

```markdown
### ⚠️ Sprint Replan — YYYY-MM-DD

**Injected:** #N [ticket name] (P[N], [AFK/HITL])
**Action:** [Absorbed / Swapped with #N [ticket name]]
**Displaced:** #N [ticket name] → General backlog
**Sprint goals impact:** [unchanged / [goal] at risk]
**Confirmed by:** Human
```

4. Remind: "Next standup will surface this replan. If this affects the PI plan, run `pi-replan`."

## Rules

- Never update any file before `CONFIRM` is received
- Never recommend displacing a ticket that is In Progress or >50% complete
- Displaced tickets always go to general project backlog — never auto-assigned to next sprint
- Displaced tickets must be flagged with `⚠️ displaced by replan [date]`
- If the injection is P1 Critical, surface it as urgent but still require `CONFIRM`
- Sprint length is fixed — never suggest extending it

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `kanban.md` missing | Stop. "No kanban found — cannot assess sprint capacity. Create kanban.md first." |
| No active sprint in calendar | Stop. "No active sprint found. Run `$sprint-start` before replanning." |
| All tickets In Progress or >50% complete | "No safe swap candidates found. All tickets are in progress. You must decide what to defer manually." |
| Injection is larger than entire sprint | Flag as P1 risk. "This work exceeds the remaining sprint capacity entirely. Consider `$pi-replan` instead." |
| DEVLOG.md missing | Create it with the replan entry as the first entry. |
