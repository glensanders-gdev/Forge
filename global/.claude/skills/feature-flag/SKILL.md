---
name: feature-flag
category: maintenance
description: Track feature flags from creation to planned removal. Register flags, monitor for overdue removal dates, and create kanban tickets for cleanup. /standup surfaces overdue flags. Per-project register at docs/feature-flags.md. Use when user runs /feature-flag, a new flag is added to the codebase, or /standup surfaces overdue flags.
---

# Feature Flag

Track feature flags from introduction to removal. Prevents flags from becoming invisible
permanent code by surfacing overdue removals in `/standup` and creating cleanup tickets
automatically.

---

## Usage

```
/feature-flag add [flag-name]    ← register a new flag
/feature-flag list               ← show all flags with status
/feature-flag check              ← check for overdue flags (called by /standup)
/feature-flag remove [flag-name] ← mark a flag as removed (does not touch code)
```

---

## Register Format

`docs/feature-flags.md`:

```markdown
# Feature Flags — [Project Name]

| ID | Flag Name | Status | Ticket | Removal Date | Owner | Purpose |
|----|-----------|--------|--------|-------------|-------|---------|
| FF-001 | FEATURE_NEW_CHECKOUT | Active | PROJ-042 | 2026-06-01 | Jane | Gradual rollout of new checkout flow |
| FF-002 | ENABLE_DARK_MODE | Active | PROJ-051 | 2026-07-15 | John | A/B test dark mode |
| FF-003 | OLD_SEARCH_FALLBACK | Removed | PROJ-031 | 2026-04-01 | Jane | Removed 2026-04-03 |
```

**Status values:** `Active` · `Overdue` · `Removed`

---

## `/feature-flag add [flag-name]`

Ask in sequence:

1. **Flag name** — if not provided as argument (e.g. `FEATURE_NEW_CHECKOUT`)
2. **Associated ticket** — PROJ-NNN or leave blank if not yet ticketed
3. **Planned removal date** — when should this flag be cleaned up?
   > "What is the planned removal date for this flag? (YYYY-MM-DD)"
   > Tip: flags without removal dates become permanent — set one now.
4. **Owner** — who is responsible for removing it?
5. **Purpose** — one line describing what the flag controls

Show for confirmation:

```
Ready to register:

  FF-004 | FEATURE_NEW_DASHBOARD | Active
  Ticket: PROJ-061
  Remove by: 2026-08-01
  Owner: Alex
  Purpose: New dashboard rollout behind flag while testing with beta users

Add to docs/feature-flags.md? (yes/no)
```

---

## `/feature-flag list`

```
## Feature Flags — [Project Name]

### 🔴 Overdue (past removal date)
FF-001 | FEATURE_NEW_CHECKOUT | Remove by: 2026-06-01 (23 days overdue) | Owner: Jane

### 🟢 Active
FF-002 | ENABLE_DARK_MODE | Remove by: 2026-07-15 (in 52 days) | Owner: John
FF-004 | FEATURE_NEW_DASHBOARD | Remove by: 2026-08-01 (in 69 days) | Owner: Alex

### ✅ Removed
FF-003 | OLD_SEARCH_FALLBACK | Removed 2026-04-03
```

---

## `/feature-flag check`

Called by `/standup` at the start of each session. Checks whether any active flags
have passed their planned removal date.

If overdue flags exist:

```
⚠️ Overdue feature flags:

  FF-001 | FEATURE_NEW_CHECKOUT | Was due: 2026-06-01 (23 days ago) | Owner: Jane

  Create kanban tickets for removal? (yes / no / skip)
```

If yes, create a ticket per overdue flag:
```markdown
- [ ] Remove feature flag FEATURE_NEW_CHECKOUT (FF-001) — see docs/feature-flags.md | Medium | tech-debt
```

Update the flag status to `Overdue` in the register.

If no overdue flags, return silently — do not add noise to standup.

---

## `/feature-flag remove [flag-name]`

Mark the flag as removed in the register. Does not modify source code.

Ask:
> "Confirm FEATURE_NEW_CHECKOUT (FF-001) has been removed from the codebase? (yes/no)"

If confirmed, update status to `Removed` and record the date. Close any open
kanban ticket for this flag.

```
✅ FF-001 FEATURE_NEW_CHECKOUT marked as removed.

   Note: this skill does not modify source code — ensure the flag and its
   conditional branches have been cleaned up and tests pass before closing
   the kanban ticket.
```

---

## `/standup` Integration

`/standup` calls `/feature-flag check` at the start of each session.
Overdue flags surface as a warning with an offer to create kanban tickets.
If no flags are overdue, nothing appears in standup output.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/feature-flags.md` missing | Create it with the standard header on first add |
| Flag name not found for remove | List active flags and ask to confirm |
| No removal date provided | Warn strongly — a flag without a removal date is a permanent flag. Require one before adding. |
| Duplicate flag name | Warn and ask to confirm before adding |

---

## Rules

- A removal date is mandatory — never register a flag without one
- Removal status update does not touch code — code removal is a developer task via `/tdd` and `/review`
- Kanban tickets for overdue flags use flag name and FF-NNN ID only — no code details
- Flags stay in the register after removal for historical reference
- `/standup` only surfaces flags that are past their removal date — not flags approaching it
