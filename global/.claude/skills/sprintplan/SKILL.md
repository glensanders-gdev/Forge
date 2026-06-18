---
name: sprintplan
category: pi-release
description: Display a timeline table of sprints, tickets, deployment dates, buffer windows, and Go/No Go gates for the current PI. Produces per-project and consolidated views. Use when user runs /sprintplan or wants to see the development timeline.
---

# Sprint Plan

Display a timeline view of the current PI — sprints, tickets, deployment dates, buffer windows, and Go/No Go gates. Produces both a per-project view for development planning and a consolidated view for stakeholder communication.

## Process

1. Read `~/.claude/pi/[current-pi]/plan.md` — identify current PI and release dates.
2. Read `~/.claude/sprints/calendar.md` — sprint dates and active projects.
3. Read `docs/kanban.md` for each active project — current ticket state.
4. Read active PRDs — feature assignments, priorities, delivery types.
5. Produce both views.

## Consolidated View (Stakeholder-Facing)

```markdown
## [PI Name] — Sprint Plan

| Sprint | Period | Release Target | Key Features | Deployment |
|--------|--------|---------------|-------------|------------|
| Sprint-01 | Tue DD MMM → Mon DD MMM | R1 | [Stakeholder Label], [Stakeholder Label] | — |
| Sprint-02 | Tue DD MMM → Mon DD MMM | R1 (buffer Fri-Sun DD-DD MMM) | [Stakeholder Label] | Mon DD MMM |
| | | | Go/No Go: Fri DD MMM 5pm | |
| Sprint-03 | Tue DD MMM → Mon DD MMM | R2 | [Stakeholder Label] | — |
| Sprint-04 | Tue DD MMM → Mon DD MMM | R2 (buffer Fri-Sun DD-DD MMM) | [Stakeholder Label] | Mon DD MMM |
| | | | Go/No Go: Fri DD MMM 5pm | |
| Sprint-05 | Tue DD MMM → Mon DD MMM | R3 | [Stakeholder Label] | — |
| Sprint-06 | Tue DD MMM → Mon DD MMM | R3 (buffer Fri-Sun DD-DD MMM) | [Stakeholder Label] | Mon DD MMM |
| | | | Go/No Go: Fri DD MMM 5pm | |
```

## Per-Project View (Development Planning)

```markdown
## [Project Name] — Sprint Plan

| Sprint | Period | Tickets | Status | Notes |
|--------|--------|---------|--------|-------|
| Sprint-01 | DD MMM → DD MMM | #1 [name], #2 [name] | In Progress | |
| Sprint-02 | DD MMM → DD MMM | #3 [name] | Planned | Buffer: DD-DD MMM |
| | | Go/No Go: Fri DD MMM 5pm | | |
```

## Standalone Releases

Listed below the sprint table in both views:

```markdown
## Standalone Releases

| Date | Feature | Type | Status |
|------|---------|------|--------|
| DD MMM | [Stakeholder Label / internal name] | Standalone | Planned |
```

## Risk Indicators

Flag in the output:
- 🔴 Fixed Deadline feature at risk of missing release
- 🟡 Sprint appears over capacity
- ⚠️ Feature with no assigned release
- 📋 Go/No Go due within 5 days

## Related

- `/go-nogo` — produces the **Go/No Go Gate** record checked during sprint planning
- `/sprint-start` — opens an individual project sprint after the sprint plan is approved
- `/piplan` — PI-level planning that sprint plans feed into

## Rules

- Consolidated view uses Stakeholder Labels only
- Per-project view uses internal ticket names
- Buffer windows shown explicitly — no tickets scheduled in buffer
- Go/No Go dates always shown — never omit them
- Standalone releases always shown in a separate section

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No PI plan at `~/.claude/pi/[current-pi]/plan.md` | Note no active PI is set; suggest `/piplan` before a sprint plan can be shown. |
| No sprint calendar entries | Report that dates are unavailable and recommend `/sprint-start` or `/piplan` first. |
| A feature has no assigned release | Flag it ⚠️ — never silently omit it from the view. |
| A Go/No Go date is missing for a release | Surface the gap — Go/No Go dates are never omitted. |
| A sprint appears over capacity | Flag 🟡 — this is display only; never reschedule automatically. |
| Stakeholder (consolidated) view requested | Use Stakeholder Labels only — never expose internal ticket names. |
