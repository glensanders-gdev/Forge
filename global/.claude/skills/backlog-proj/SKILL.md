---
name: backlog-proj
description: Display the backlog for a specific project, grouped by priority. Prompts the user to select from known active projects. Use when user runs /backlog-proj or wants to see unstarted work for a specific project.
---

# Backlog Proj

Display the Backlog section of a specific project's `kanban.md`, grouped by priority. For the global framework backlog use `/user:backlog-list`.

## Process

1. **Build project list** — read `~/.claude/priorities.md` and `~/.claude/pi/[current-pi]/plan.md` to identify active projects.
2. **Present project list** — ask the user to select:

```
Which project backlog would you like to see?

1. [project-name] — [stakeholder label]
2. [project-name] — [stakeholder label]
3. [project-name] — [stakeholder label]

Type a number or project name.
```

3. **Read project kanban** — open `docs/kanban.md` in the selected project repo.
4. **Extract Backlog section only** — In Progress and Blocked tickets are excluded.
5. **Group by priority** — P1 → P2 → P3 → P4 → Unranked.
6. **Display the formatted list.**
7. Offer: "Want to add an item to this backlog? Run `/user:backlog-add`."

## Output Format

```markdown
## [Project Name] — Backlog

### P1 — Critical
- [ ] [HITL/AFK] #N [Ticket name] · `blocked-by: #N` (if any)

### P2 — High
- [ ] [HITL/AFK] #N [Ticket name]

### P3 — Normal
- [ ] [HITL/AFK] #N [Ticket name]

### P4 — Low
- [ ] [HITL/AFK] #N [Ticket name]

### Unranked
- [ ] [HITL/AFK] #N [Ticket name]

**Total:** N backlog items
```

## Rules

- Show Backlog section only — never In Progress or Blocked
- Do not modify `kanban.md` — read only
- If a ticket has no priority tag, list under Unranked

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No active projects found | "No active projects found in priorities.md or PI plan. Add a project first." |
| Project kanban not found | "kanban.md not found for [project]. The project may not be scaffolded with Forge." |
| Backlog section empty | "[Project] backlog is empty — nothing waiting to be started." |
| Project not in known list | Ask user to type the path manually as a fallback. |
