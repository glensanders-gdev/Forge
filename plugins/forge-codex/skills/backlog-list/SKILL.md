---
name: "backlog-list"
description: "Display the global Forge backlog grouped by priority. Use when user runs $backlog-list, wants to see pending framework items, discussion topics, or cross-project concerns."
metadata:
  category: session
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Backlog List

Display the global backlog from `~/.codex/forge/backlog.md`, grouped by priority. This is the framework-level backlog — for project-level backlogs use `backlog-proj`.

## Process

1. Read `~/.codex/forge/backlog.md`.
2. Group items by priority: P1 → P2 → P3 → P4 → Unranked.
3. Within each group, maintain date-added order.
4. Display the formatted list.
5. Offer: "Want to add an item? Run `backlog-add`."

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
| `backlog.md` missing | "No global backlog found. Run `backlog-add` to create one." |
| Backlog is empty | "Global backlog is empty." Offer `backlog-add`. |
| Items have no priority | Group under Unranked. Offer to run `backlog-add` to triage them. |

## Rules

- This is a read-only display — never modify `backlog.md`; adding items is `$backlog-add`.
- Preserve priority grouping and date-added order within groups — never reorder by inference.
- This shows the global backlog only — direct project-level requests to `$backlog-proj`.
