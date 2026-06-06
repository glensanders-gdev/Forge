---
name: "save-state"
description: "Save current session state immediately — HANDOFF.md first, kanban.md second, DEVLOG entry last. Use when user runs $save-state, wants to pause cleanly, or context window exhaustion is imminent. Fast, predictable, no ceremony."
metadata:
  category: session
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Save State

Save the minimum required state to allow the next session to resume cleanly. Three files, in priority order. No grilling, no confirmation prompts — just save and confirm.

## When to Use

- User runs `save-state` explicitly to pause cleanly
- Agent detects context window exhaustion is imminent
- Human wants to stop mid-build without losing progress
- Any pipeline stage — not limited to `$build`

## Execution (in order)

### 1. Write `docs/HANDOFF.md` — highest priority

Overwrite with current state:

```markdown
# Handoff: [Project Name]

**Last updated:** YYYY-MM-DD HH:MM
**Session type:** [current session type]

## Current Ticket

**#N — [current ticket name]** `[AFK/HITL]`
Status: [In Progress / Blocked / Interrupted by context limit]

## What Just Happened

[One or two sentences — what was being worked on when save-state was triggered]

## Next Action

[Exactly what to do first in the next session]
[If mid-ticket: "Resume #N — [what was left to do]"]

## Open Decisions

[Any unresolved decisions]
_None_ if nothing pending.

## Blockers

[Any blockers]
_None_ if nothing blocked.

## Note

Session ended via $save-state — [context limit reached / manual pause].
Resume with build to continue from the current ticket.
```

### 2. Write `docs/kanban.md` — second priority

Update ticket states to reflect current reality:
- Currently executing ticket → `[>] In Progress`
- Completed tickets → `[x] Done ✓`
- Not yet started → unchanged `[ ]`
- HITL waiting → `[⏸] awaiting input`

### 3. Append to `docs/DEVLOG.md` — lowest priority (attempt if context allows)

```markdown
## Session YYYY-MM-DD — Interrupted (save-state)

**Trigger:** [Context limit / Manual pause]
**Tickets completed this session:** #N, #N
**Current ticket:** #N [name] — In Progress
**Next action:** [from HANDOFF.md]
**Status:** In Progress — resume next session
```

If context is too limited to write DEVLOG, skip it and note in HANDOFF: "DEVLOG not updated — reconstruct from kanban.md."

---

## Confirmation

After saving:

```
✓ State saved.

HANDOFF.md: ✅ Written
kanban.md:  ✅ Updated
DEVLOG:     ✅ Written | ⚠️ Skipped (context limit)

Start a new session to continue.
Run build to resume from #N [ticket name].
```

---

## Rules

- Write in priority order — never skip HANDOFF to write DEVLOG first
- No confirmation prompts — save immediately and report what was done
- No compression or summarisation of any file — save only, never transform
- If HANDOFF.md write fails, report the failure clearly — the human needs to know state was not saved
- This skill does NOT end the Codex session — it saves state so the next session can resume

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/` folder missing | Create it, then write HANDOFF.md |
| HANDOFF.md write fails | Report clearly: "⚠️ HANDOFF.md could not be written. Manually note: current ticket #N, next action [X]." |
| kanban.md write fails | Report clearly. HANDOFF.md was written — next session can still orient. |
| All writes fail | "⚠️ State could not be saved. Before closing: note current ticket #N and what was in progress." |
