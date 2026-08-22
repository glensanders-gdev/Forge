---
name: save-state
category: session
description: Save current session state immediately — stream handoff first, register second, kanban third, DEVLOG last. Use when user runs /save-state, wants to pause cleanly, or context window exhaustion is imminent. Fast, predictable, no ceremony, never asks a question.
argument-hint: "[stream-slug]"
---

# Save State

Save the minimum required state to allow the next session to resume cleanly. Four files, in
priority order. No grilling, no confirmation prompts — just save and confirm.

Session state is held per **stream** of work. The register and stream schemas are specified in
**`~/.claude/skills/handoff/STREAMS.md`**.

## When to Use

- User runs `/user:save-state` explicitly to pause cleanly
- Agent detects context window exhaustion is imminent
- Human wants to stop mid-build without losing progress
- Any pipeline stage — not limited to `/build`

## Stream Resolution — never blocks

An emergency save that stops to ask a question has failed. Resolve in this order and take the
first that answers:

1. A slug given as an argument.
2. The stream this session has already been writing to (resolved earlier by `/handoff`,
   `/pickup`, or a previous `/save-state`).
3. The single `Active` stream in `docs/HANDOFF.md`, if there is exactly one.
4. Otherwise write `docs/handoffs/unassigned-YYYY-MM-DD-HHMM.md` and say so.

**Never guess between two Active streams** — an unassigned file is recoverable, an overwritten
stream is not. **Never ask** — the context window may not survive the round trip.

## Execution (in order)

### 1. Write the stream handoff — highest priority

Overwrite `docs/handoffs/<slug>.md` (or the `unassigned-*` file) using the stream-file template in
`STREAMS.md`, with:

- **Status:** In Progress / Blocked / Interrupted by context limit
- **What Just Happened:** one or two sentences — what was being worked on when save-state fired
- **Next Action:** exactly what to do first next session; if mid-ticket, "Resume #N — [what was left]"
- **Open Decisions / Blockers:** `_None_` if nothing pending
- A closing note: "Session ended via /save-state — [context limit reached / manual pause]."

Apply the conflict guard from `STREAMS.md`: if the file changed since this session read it, write
the `.conflict-*` sibling rather than overwriting. Under context pressure this costs one extra
file and saves someone else's stream.

### 2. Update the register row — second priority

Edit this stream's row in `docs/HANDOFF.md`: `Status`, `Updated`, `Next action`. One row, never a
whole-file rewrite. If the save went to an `unassigned-*` file, add a row for it with the slug
`unassigned-YYYY-MM-DD-HHMM` so the next session finds it.

### 3. Write `docs/kanban.md` — third priority

Update ticket states to reflect current reality:
- Currently executing ticket → `[>] In Progress`
- Completed tickets → `[x] Done ✓`
- Not yet started → unchanged `[ ]`
- HITL waiting → `[⏸] awaiting input`

### 4. Append to `docs/DEVLOG.md` — lowest priority (attempt if context allows)

```markdown
## Session YYYY-MM-DD — Interrupted (save-state)

**Stream:** [slug]
**Trigger:** [Context limit / Manual pause]
**Tickets completed this session:** #N, #N
**Current ticket:** #N [name] — In Progress
**Next action:** [from the stream handoff]
**Status:** In Progress — resume next session
```

If context is too limited to write DEVLOG, skip it and note in the stream handoff: "DEVLOG not
updated — reconstruct from kanban.md."

---

## Confirmation

```
✓ State saved — stream `ord-pack`.

handoffs/ord-pack.md: ✅ Written
HANDOFF.md (register): ✅ Row updated
kanban.md:             ✅ Updated
DEVLOG:                ✅ Written | ⚠️ Skipped (context limit)

Start a new session to continue.
Run /user:pickup ord-pack to resume from #N [ticket name].
```

---

## Related

- `docs/handoffs/<slug>.md` — primary output; also written by `/handoff` and `/debrief`
- `docs/HANDOFF.md` — the stream register; see `~/.claude/skills/handoff/STREAMS.md`
- `docs/kanban.md` — also written by `/debrief`, `/sprint-end`, `/approve`
- `docs/DEVLOG.md` — also written by `/standup` and `/debrief`
- `/handoff` — planned pause on one stream, with skill suggestions for the next session
- `/pickup` — reads a stream handoff on session start to orient itself

## Rules

- Write in priority order — never skip the stream handoff to write DEVLOG first
- No confirmation prompts and no questions — save immediately and report what was done
- No compression or summarisation of any file — save only, never transform
- Name the stream in the confirmation, so a wrong resolution is visible immediately
- If the stream handoff write fails, report the failure clearly — the human needs to know state was not saved
- This skill does NOT end the Claude Code session — it saves state so the next session can resume

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/` or `docs/handoffs/` missing | Create it, then write the stream handoff |
| More than one Active stream, no slug, none resolved this session | Write `unassigned-YYYY-MM-DD-HHMM.md` and add its register row. Never guess, never ask. |
| Stream file changed since this session read it | Write `docs/handoffs/<slug>.conflict-YYYY-MM-DD-HHMM.md` and report both paths |
| Legacy single-document `docs/HANDOFF.md` | Write to it as before and note "legacy handoff — run /handoff to migrate". Never migrate here; migration under context pressure is how state gets lost. |
| Stream handoff write fails | Report clearly: "⚠️ Handoff could not be written. Manually note: stream [slug], current ticket #N, next action [X]." |
| Register write fails | Report clearly. The stream file was written — tell the human the exact path so the next session can be pointed at it. |
| kanban.md write fails | Report clearly. The handoff was written — next session can still orient. |
| All writes fail | "⚠️ State could not be saved. Before closing: note stream [slug], current ticket #N, and what was in progress." |
