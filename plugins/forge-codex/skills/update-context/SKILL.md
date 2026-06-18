---
name: "update-context"
description: "Review the current session and flush new terms, decisions, and system behaviour into CONTEXT.md and relevant knowledge files. Use when user runs $update-context, terminology has shifted during a session, or new domain concepts have emerged."
metadata:
  category: knowledge
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Update Context

Review the session and flush any new or refined understanding into the project's living documents. Keeps the knowledge layer current so future sessions don't re-discover the same ground.

## Process

1. Review the current conversation for:
   - New domain terms introduced or clarified
   - Terms that were redefined or corrected
   - System behaviour that was discovered or confirmed
   - Assumptions that were confirmed as fact
2. Read `docs/CONTEXT.md` — check for conflicts or gaps.
3. Read relevant `~/.codex/forge/knowledge/systems/*/overview.md` and `known-issues.md` files.
4. Present proposed updates to the user before writing anything.
5. On confirmation, update the relevant files.

## What Gets Updated

| Discovery | Destination |
|-----------|-------------|
| New domain term | `docs/CONTEXT.md` |
| Corrected term definition | `docs/CONTEXT.md` (update in place) |
| New system limitation or quirk | `~/.codex/forge/knowledge/systems/[name]/known-issues.md` |
| Confirmed system behaviour | `~/.codex/forge/knowledge/systems/[name]/overview.md` |
| New field or object discovered | `~/.codex/forge/knowledge/systems/[name]/schema.md` |

## CONTEXT.md Term Format

```markdown
## [Term]
[Plain language definition meaningful to a domain expert. No implementation details.]
```

## Rules

- Present all proposed changes before writing — never update silently.
- Do not add implementation details to `CONTEXT.md` — domain language only.
- If a term conflicts with an existing definition, flag it and ask the user to resolve before updating.
- Do not remove existing terms — update or annotate them.
- After updating, confirm which files were changed and what was added.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No new terms or decisions surfaced this session | Say there's nothing to flush — don't manufacture updates. |
| A term conflicts with an existing CONTEXT.md definition | Flag it and ask the user to resolve before updating. |
| Tempted to add implementation detail to CONTEXT.md | Domain language only — keep implementation out. |
| Tempted to remove an existing term | Update or annotate — never remove. |
| Discovery belongs to a system, not the project | Route it to the system's `known-issues.md` / `overview.md` / `schema.md`, not CONTEXT.md. |
| Tempted to write without review | Present all proposed changes first — never update silently. |
