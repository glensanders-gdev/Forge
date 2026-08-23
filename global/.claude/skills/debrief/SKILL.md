---
name: debrief
category: session
standalone: true
description: Thorough session close — updates the stream handoff, sweeps the stream register, and updates kanban, DEVLOG, and the backlog. Use at the end of any partial session to save state completely. For passing work to another agent or person without the full close overhead, use /handoff instead — it compacts one stream and suggests next skills.
argument-hint: "[stream-slug]"
---

# Debrief

Close a working session cleanly when a feature is not yet complete. Lighter than `/approve` — no
PRD archiving, no feature closure. Updates all session state documents so the next session can
resume without re-reading the conversation.

Session state is held per **stream** of work — see `~/.claude/skills/handoff/STREAMS.md`. Debrief
writes the stream it was run for, and is the **only** session skill that sweeps the whole register.

**Session close hierarchy:**
- `/handoff` — any planned pause on one stream (same-day resume, passing to another agent or
  colleague). Writes the stream handoff and its register row. Light and fast.
- `/debrief` — end-of-day full close. Updates the stream handoff, sweeps the register, and updates
  kanban, DEVLOG, and the backlog. Use this when you're done for the day, not just pausing.
- `/save-state` — emergency save when context limit is imminent. No ceremony, no questions.

## When to Use

- The session is ending but work is still in progress
- Goals were partially met and the rest is deferred
- Something unexpected changed the plan mid-session

## Process

1. Review what was completed this session from the conversation and `docs/kanban.md`.
2. **Resolve the stream** — per the resolution table in `STREAMS.md`. With more than one Active
   stream and no slug given, ask which one this session's work belongs to.
3. **Update `docs/handoffs/<slug>.md`** — overwrite using the stream-file template in `STREAMS.md`,
   after applying the conflict guard:
   - Session type: Planning | Build | QA | Sprint Close | PI Management | Deployment | Ad Hoc
   - Current ticket and status
   - What was just done (one or two sentences)
   - Exact next action for the next session
   - Any open decisions or blockers
4. **Sweep the register** — update this stream's row in `docs/HANDOFF.md`, then check every other
   row:
   - Any `Active` stream not updated in more than 7 days → surface it and offer Pause or Close.
     Never change a status the human did not choose.
   - Any two `Active` streams sharing an entry under `Touches` → mark the cell `⚠️` and report it.
   - Any row whose stream file is missing → report it; that is lost work, not a tidy-up.
5. Update `docs/kanban.md` — move completed tickets to Done, update In Progress.
6. Identify anything deferred and why.
7. Reorder the Backlog by priority for next session.
8. **Record token actuals** — run `npx ccusage daily --since [today] --until [today] --json` and
   update the current phase's record in `docs/tokens/[feature-name].md` per
   `~/.claude/skills/token-report/TOKEN-RECORDING.md`. If ccusage returns no data, record
   `Source: no data` — never estimate token counts from memory.
9. Append a structured entry to `docs/DEVLOG.md`.
10. State the updated version number (single-file projects) or latest git tag (multi-file projects).
11. Suggest top 1–3 goals for next session, and name the stream each belongs to.

## DEVLOG Entry Format

```markdown
## Session YYYY-MM-DD

**Stream:** [slug]
**Version range:** vX.XX → vX.XX (single-file) or git tag (multi-file)
**Goals this session:** [1–3 goals]
**Tickets Completed:** #N, #N
**Decisions Made:** Brief summary (reference ADR if created)
**Assumptions Made:** [assumption — confirmed by user/evidence]
**Blockers:** Any HITL or external blockers
**Next Up:** Top 1–3 tickets for next session
**Status:** In Progress
```

## Register Sweep Output

```
Register swept — 3 streams open.

  ord-pack          Active   updated just now   → Reconcile the two pack trees
  capacity-report   Active   updated 18d ago    ⚠️ stale — pause or close?
  junction-sync     Blocked  updated 25d ago    → Waiting on API access
```

## Rules

- Debrief writes **one** stream handoff — the stream it was run for. The sweep touches other rows'
  metadata, never their handoff files.
- Never change another stream's status without the human choosing it.
- Never archive the PRD during debrief — that is `/approve` only.
- If the session produced no completed tickets, still write the DEVLOG entry — record what was
  attempted and why it didn't complete.
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
| More than one Active stream, no slug given | Ask which stream this session's work belongs to. Never infer it from the conversation. |
| `docs/HANDOFF.md` missing | Create the register and a first stream — debrief is a canonical writer of session state. |
| Legacy single-document `docs/HANDOFF.md` | Migrate per `STREAMS.md`, confirming the slug, then proceed. |
| Stream file changed since this session read it | Write `docs/handoffs/<slug>.conflict-YYYY-MM-DD-HHMM.md` and stop for the human. Never merge. |
| Register row points at a missing stream file | Report it as lost work. Never delete the row to make the sweep clean. |
| A stream has been Active and untouched for weeks | Offer Pause or Close. Never close it silently — an unclosed stream is visible, a wrongly closed one is not. |
| Session completed no tickets | Still write the DEVLOG entry — record what was attempted and why it didn't complete. |
| `ccusage` returns no data | Record `Source: no data` — never estimate token counts from memory. |
| Tempted to archive the PRD | Stop — PRD archiving is `/approve` only; debrief never closes a feature. |
| No clear next action | Resolve it with the user before closing, so the next session can resume without confusion. |
