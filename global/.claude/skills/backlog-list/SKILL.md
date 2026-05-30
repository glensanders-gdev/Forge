---
name: backlog-list
category: session
description: Display the global Forge backlog grouped by priority. Use when user runs /backlog-list, wants to see pending framework items, discussion topics, or cross-project concerns.
---

# Backlog List

Display the global backlog from `~/.claude/backlog.md`, grouped by priority. This is the framework-level backlog — for project-level backlogs use `/user:backlog-proj`.

## Process

1. Read `~/.claude/backlog.md`.
2. Group items by priority: P1 → P2 → P3 → P4 → Unranked.
3. Within each group, maintain date-added order.
4. Display the formatted list.
5. Offer: "Want to add an item? Run `/user:backlog-add`."

## Output Format

```markdown
## Global Backlog

### P1 — Critical
- [item] — [why it matters] · Added YYYY-MM-DD

### P2 — High
- [item] — [why it matters] · Added YYYY-MM-DD

### P3 — Normal
- [item] — [why it matters] · Added YYYY-MM-DD

### P4 — Low
- [item] — [why it matters] · Added YYYY-MM-DD

### Unranked
- [item] — [why it matters] · Added YYYY-MM-DD

**Total:** N items (N unranked)
```

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `backlog.md` missing | "No global backlog found. Run `/user:backlog-add` to create one." |
| Backlog is empty | "Global backlog is empty." Offer `/user:backlog-add`. |
| Items have no priority | Group under Unranked. Offer to run `/user:backlog-add` to triage them. |
