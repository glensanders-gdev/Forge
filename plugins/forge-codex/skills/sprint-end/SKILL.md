---
name: "sprint-end"
description: "Close the current sprint for this project. Can run in two modes — AFK (draft from kanban data, save for human review) or HITL (human confirms carry-over, fills retro, finalises). Use when user runs $sprint-end, or as an AFK kanban ticket at sprint close."
metadata:
  category: sprint
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
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

1. Read `~/.codex/forge/sprints/calendar.md` — confirm active sprint name and period.
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

Triggered when the human runs `sprint-end` or picks up the HITL finalise ticket.

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
7. **Write retrospective to company directory** — if `active_company` is set, write the
   retrospective section to `~/.codex/forge/companies/[active_company]/retrospectives/sprint-NN-retro.md`
   (see Retrospective Storage below).
8. **Log sprint metrics** — append one row to `docs/metrics/metrics-log.md` (see Metrics Logging below).
9. **Update `docs/HANDOFF.md`** — overwrite with sprint close state:
   - Session type: Sprint Close
   - Current ticket: "Sprint-NN closed"
   - What just happened: sprint summary in one sentence
   - Next action: "Run `sprint-start` to open Sprint-NN+1"
   - Open decisions or carry-forwards if any
## Pipeline Position

```
$sprint-start → $standup (daily) → $sprint-end → $debrief
```

Precedes: `$debrief` (session close), `$sprint-start` (next sprint)
Follows: the last `$standup` of the sprint

8. **Archive completed tickets** — move all Done tickets from `docs/kanban.md` to `docs/kanban-archive.md`:
   - Append under heading: `## Sprint-NN — YYYY-MM-DD`
   - Leave only In Progress, Blocked, and Backlog tickets in `kanban.md`
   - Keeps `kanban.md` lean for future session start reads
9. Update `~/.codex/forge/sprints/calendar.md` — mark sprint as Closed.
10. **Review open RAID entries** — if `docs/raid/` exists, prompt:
    "Review open RAID entries for this sprint. Any risks mitigated, actions completed, or issues resolved?"
    For each confirmed resolution, offer to run `$raid close [ID]` — do not close automatically.
11. Prompt (do not trigger): "Sprint-NN closed. Run `sprint-start` when you're ready to open Sprint-NN+1."

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

## Retrospective Storage

When `active_company` is set, write the retrospective to the company directory in addition
to the main sprint record. This keeps sensitive reflections (what went wrong, team friction,
process failures) private — not committed to the project's GitHub.

Create `~/.codex/forge/companies/[active_company]/retrospectives/` if it doesn't exist.

**File:** `~/.codex/forge/companies/[active_company]/retrospectives/sprint-NN-retro.md`

```markdown
# Sprint Retrospective — Sprint-NN

**Project:** [Project Name] (PROJ-NNN)
**Sprint closed:** YYYY-MM-DD
**Sprint period:** [start date] → [end date]

## Goals Review

| Goal | Outcome |
|------|---------|
| [Goal 1] | ✅ Achieved / ⚠️ Partial / ❌ Not started |

## Velocity

| Metric | Value |
|--------|-------|
| Points completed | N |
| Points carried | N |
| Carry-over rate | N% |
| Goal hit rate | N% |

## Retrospective

**Went well:**
[Human input]

**Didn't go well:**
[Human input]

**One thing to improve next sprint:**
[Human input]

---
*Private — not committed to project GitHub.*
```

If `active_company` is not set, skip this step silently — the retro data is captured only
in `docs/sprints/sprint-NN.md`.

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
- Do not auto-trigger `$sprint-start` — prompt only.

## Token Summary (Sprint)

At sprint end (HITL mode), build the sprint token summary from actuals:

1. Run `npx ccusage daily --since [sprint-start] --until [sprint-end] --json` — the measured sprint total.
2. Read `docs/tokens/[feature].md` for each feature worked this sprint and sum their recorded totals.
3. If the ccusage total and the sum of feature records differ materially (>20%), sessions were missed at `$debrief` — backfill the gap dates per `~/.codex/forge/skills/token-report/TOKEN-RECORDING.md` before writing the summary.
4. Append to the sprint record:

```markdown
### Token Summary
**Sprint total (ccusage):** Nk tokens (N features, N sessions)
**Input:** Nk | **Output:** Nk
**Largest phase:** [phase] (Nk)
```

If ccusage is unavailable, sum the feature records alone and note `Source: feature records only — ccusage unavailable`. Never fill gaps with estimates.

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Run unattended (AFK mode) | Write a draft only and create a HITL finalise ticket — never prompt or finalise. |
| Run with human present (HITL mode) | Finalise only after the human confirms carry-over and completes the retro. |
| A carry-over item has no reason | Prompt for one — don't carry over vaguely. |
| Retro fields left blank in HITL mode | Prompt once for all three before finalising. |
| ccusage total and feature-record sum differ >20% | Sessions were missed at `$debrief` — backfill before writing the token summary; never estimate. |
| Tempted to mark the sprint Closed early | Don't update the calendar to Closed until HITL finalisation completes. |
