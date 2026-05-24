---
name: sprint-end
description: Close the current sprint for this project. Can run in two modes — AFK (draft from kanban data, save for human review) or HITL (human confirms carry-over, fills retro, finalises). Use when user runs /sprint-end, or as an AFK kanban ticket at sprint close.
---

# Sprint End

Closes the current sprint in two distinct modes. The AFK mode drafts the record automatically; the HITL mode finalises it with human input.

---

## Mode A — AFK Draft (runs unattended)

Place this on the kanban board as a scheduled AFK task at sprint end:

```
- [ ] [AFK] #N Draft sprint-end record `sprint-end --draft`
```

### AFK Process

1. Read `~/.claude/sprints/calendar.md` — confirm active sprint name and period.
2. Read `docs/sprints/sprint-NN.md` — extract goals from sprint start.
3. Read `docs/kanban.md` — extract completed, in-progress, and blocked tickets.
4. Read `docs/DEVLOG.md` — scan session entries within the sprint period for decisions, blockers, and achievements.
5. Write the Sprint End section into `docs/sprints/sprint-NN.md` with:
   - Goals review auto-assessed from kanban state
   - All incomplete tickets listed as provisional carry-over
   - Retro fields marked `⏳ Awaiting human input`
   - Status marked `Draft — awaiting HITL review`
6. Add a HITL ticket to `docs/kanban.md`:
   ```
   - [ ] [HITL] #N+1 Finalise sprint-end record `blocked-by: #N`
   ```
7. Append to `docs/DEVLOG.md`: "Sprint-NN draft record written — awaiting HITL finalisation."

---

## Mode B — HITL Finalise (human present)

Triggered when the human runs `/user:sprint-end` or picks up the HITL finalise ticket.

### HITL Process

1. Read the draft sprint record from `docs/sprints/sprint-NN.md`.
2. Present the draft to the human — goals review, completed tickets, provisional carry-over.
3. Ask the human to confirm or adjust carry-over items:
   - "These incomplete tickets are provisionally carried over — remove any that should be dropped."
4. Ask for retro input:
   - "What went well this sprint?"
   - "What didn't go well?"
   - "One thing to improve next sprint?"
5. Present the finalised draft for confirmation before writing.
6. Write the finalised Sprint End section into `docs/sprints/sprint-NN.md`.
7. **Log sprint metrics** — append one row to `docs/metrics/metrics-log.md` (see Metrics Logging below).
8. **Update `docs/HANDOFF.md`** — overwrite with sprint close state:
   - Session type: Sprint Close
   - Current ticket: "Sprint-NN closed"
   - What just happened: sprint summary in one sentence
   - Next action: "Run `/user:sprint-start` to open Sprint-NN+1"
   - Open decisions or carry-forwards if any
8. **Archive completed tickets** — move all Done tickets from `docs/kanban.md` to `docs/kanban-archive.md`:
   - Append under heading: `## Sprint-NN — YYYY-MM-DD`
   - Leave only In Progress, Blocked, and Backlog tickets in `kanban.md`
   - Keeps `kanban.md` lean for future session start reads
9. Update `~/.claude/sprints/calendar.md` — mark sprint as Closed.
10. Prompt (do not trigger): "Sprint-NN closed. Run `/user:sprint-start` when you're ready to open Sprint-NN+1."

---

## Sprint Record Template (End Section)

```markdown
## Sprint End

**Date closed:** YYYY-MM-DD
**Status:** Draft — awaiting HITL review | Final

### Goals Review
| Goal | Outcome |
|------|---------|
| [Goal 1] | ✅ Achieved / ⚠️ Partial / ❌ Not started |
| [Goal 2] | ✅ Achieved / ⚠️ Partial / ❌ Not started |

### Tickets Completed
- [x] #N [Ticket name]

### Actions Achieved
- [Non-ticket accomplishments, decisions made, research completed]

### Blockers Encountered
- [Blocker] — [resolved / still open]

### Carry Over
Items moving to Sprint-NN+1:

- [ ] #N [Ticket name] — carried because [reason]

_None_ (if everything completed)

### Retrospective
**Went well:**
⏳ Awaiting human input (or completed text)

**Didn't go well:**
⏳ Awaiting human input (or completed text)

**One thing to improve next sprint:**
⏳ Awaiting human input (or completed text)
```

---

## Metrics Logging

After writing the finalised sprint record (HITL mode only), append one row to `docs/metrics/metrics-log.md`.
Create the file and section header if they don't exist.

**Section header (create if absent):**
```markdown
## Sprint Velocity

| Sprint | Closed | Points Done | Points Carried | Carry-Over % | Goals Met | Goals Total | Goal % |
|--------|--------|-------------|----------------|--------------|-----------|-------------|--------|
```

**Append row:**
```
| Sprint-13 | YYYY-MM-DD | 21 | 3 | 13% | 2 | 3 | 67% |
```

- **Points Done / Carried**: story points if tracked; ticket counts with `(tix)` suffix if not.
- **Carry-Over %**: points carried ÷ (done + carried) × 100%, rounded to nearest whole number.
- **Goal %**: goals met ÷ goals total × 100%, rounded to nearest whole number.
- AFK mode does not log — wait for HITL finalisation since carry-over may change.

Log silently — do not mention to the user.

---

## Rules

- AFK mode never prompts the human — it writes a draft and creates a HITL ticket.
- HITL mode never writes without human confirmation of the finalised draft.
- Never mark the sprint as Closed in the calendar until HITL finalisation is complete.
- Carry-over items must have a reason — don't carry over vaguely.
- The retro must have all three fields completed in HITL mode — prompt once if skipped.
- Do not auto-trigger `/sprint-start` — prompt only.

## Token Summary (Sprint)

At sprint end, sum token records for all features worked on this sprint:

Read `docs/tokens/[feature].md` for each feature. Sum totals and append to the sprint record:

```markdown
### Token Summary
**Sprint total:** ~Nk tokens (N features, N sessions)
**Input:** ~Nk | **Output:** ~Nk
**Largest phase:** [phase] (~Nk)
```
