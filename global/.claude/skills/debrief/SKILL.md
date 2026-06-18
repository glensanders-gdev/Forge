---
name: debrief
category: session
description: Thorough session close — updates HANDOFF.md, kanban, DEVLOG, and reorders the backlog. Use at the end of any partial session to save state completely. For passing work to another agent or person without the full close overhead, use /handoff instead — it compacts the session and suggests next skills.
---

# Debrief

Close a working session cleanly when a feature is not yet complete. Lighter than `/approve` — no PRD archiving, no feature closure. Updates all session state documents so the next session can resume without re-reading the conversation.

**Session close hierarchy:**
- `/handoff` — any planned pause (same-day resume, passing to another agent or colleague). Writes HANDOFF.md only. Light and fast.
- `/debrief` — end-of-day full close. Updates HANDOFF.md, kanban, DEVLOG, and reorders the backlog. Use this when you're done for the day, not just pausing.
- `/save-state` — emergency save when context limit is imminent. No ceremony, just saves state.

## When to Use

- The session is ending but work is still in progress
- Goals were partially met and the rest is deferred
- Something unexpected changed the plan mid-session

## Process

1. Review what was completed this session from the conversation and `docs/kanban.md`.
2. **Update `docs/HANDOFF.md`** — overwrite with current state:
   - Session type: Planning | Build | QA | Sprint Close | PI Management | Deployment | Ad Hoc
   - Current ticket and status
   - What was just done (one or two sentences)
   - Exact next action for the next session
   - Any open decisions or blockers
3. Update `docs/kanban.md` — move completed tickets to Done, update In Progress.
4. Identify anything deferred and why.
5. Reorder the Backlog by priority for next session.
6. **Record token actuals** — run `npx ccusage daily --since [today] --until [today] --json` and update the current phase's record in `docs/tokens/[feature-name].md` per `~/.claude/skills/token-report/TOKEN-RECORDING.md`. If ccusage returns no data, record `Source: no data` — never estimate token counts from memory.
7. Append a structured entry to `docs/DEVLOG.md`.
8. State the updated version number (single-file projects) or latest git tag (multi-file projects).
9. Suggest top 1–3 goals for next session.

## DEVLOG Entry Format

```markdown
## Session YYYY-MM-DD

**Version range:** vX.XX → vX.XX (single-file) or git tag (multi-file)
**Goals this session:** [1–3 goals]
**Tickets Completed:** #N, #N
**Decisions Made:** Brief summary (reference ADR if created)
**Assumptions Made:** [assumption — confirmed by user/evidence]
**Blockers:** Any HITL or external blockers
**Next Up:** Top 1–3 tickets for next session
**Status:** In Progress
```

## Rules

- Never archive the PRD during debrief — that is `/approve` only.
- If the session produced no completed tickets, still write the DEVLOG entry — record what was attempted and why it didn't complete.
- Always end with a clear "Next Up" so the next session can start without confusion.

## Instinct Prompt (Session End)

After the DEVLOG entry is written, include:

```
💡 Did anything this session produce a pattern worth capturing?
   Run /user:learn to capture it before it's forgotten.
```

This is a suggestion only — never mandatory.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/HANDOFF.md` missing | Create it — debrief is a canonical writer of session state. |
| Session completed no tickets | Still write the DEVLOG entry — record what was attempted and why it didn't complete. |
| `ccusage` returns no data | Record `Source: no data` — never estimate token counts from memory. |
| Tempted to archive the PRD | Stop — PRD archiving is `/approve` only; debrief never closes a feature. |
| No clear next action | Resolve it with the user before closing, so the next session can resume without confusion. |
