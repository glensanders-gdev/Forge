---
name: continue
category: session
description: Resume a session exactly where it left off. Reads docs/HANDOFF.md as the primary source, loads referenced artifacts, and presents the exact next action. Use when user runs /continue or wants to resume interrupted work without re-reading the conversation. For daily planning orientation use /standup instead.
---

# Continue

Resume work from where the last session ended. `docs/HANDOFF.md` is the source of truth —
it captures what was in progress, what was decided, and what to do next, written by
`/handoff`, `/save-state`, or `/debrief`.

This skill is focused and fast: load state, confirm next action, start working.
For broader daily orientation (priorities, deadlines, PI plan) use `/standup` instead.

---

## Process

### Step 1 — Read `docs/HANDOFF.md`

If the file does not exist:
```
⚠️ No handoff found at docs/HANDOFF.md.

There is no saved session state for this project.
Run /standup to orient from the project's living documents instead.
```
Stop. Do not continue.

If the file exists, read it in full and extract:
- `Last updated` date
- Current ticket (number and name)
- What just happened (summary)
- Next action
- Context the next session will need
- Open decisions
- Blockers
- Suggested skills

### Step 2 — Check handoff age

Compare `Last updated` date to today's date.

**If more than 7 days old:**
```
⚠️ This handoff is [N] days old (last updated: YYYY-MM-DD).

It may no longer reflect current project state.

Options:
  1. Continue from this handoff anyway
  2. Run /standup for a fresh orientation from the project files

Which would you prefer? (1 / 2)
```
Wait for input. If the user chooses 2, stop — prompt them to run `/standup`.
If the user chooses 1 (or if age is ≤7 days), continue.

### Step 3 — Load referenced artifacts (silent)

From the handoff, identify and read:
- The current ticket in `docs/kanban.md` — confirm its current status
- The active PRD in `docs/prd/active/` if referenced
- The most recent `docs/DEVLOG.md` entry (last entry only)

Cross-check: if the kanban shows the ticket from the handoff is now marked Done,
flag it (the handoff may be stale even if recent).

### Step 4 — Present session state

Output a brief, focused summary:

```markdown
## Resuming — [Project Name]

**Handoff written:** YYYY-MM-DD HH:MM  ([N hours/days ago])
**Session type:** [from handoff]

---

### Where We Left Off

[What just happened — from handoff, 2-3 sentences max]

---

### Current Ticket

**#N — [Ticket name]** `[AFK/HITL]`
Status: [from kanban cross-check]

---

### Next Action

[Exact next action from the handoff]

---

[If open decisions exist:]
### Open Decisions

[List from handoff]

[If blockers exist:]
### Blockers

[List from handoff]

[If context notes exist:]
### Context

[Context notes from handoff]

---

Ready to continue? (yes — start on [next action] / no — I'll redirect)
```

### Step 5 — Confirm and proceed

If the user confirms:
- Begin executing the next action immediately
- Do not re-read files already loaded in step 3 unless needed

If the user redirects:
- Ask "What would you like to work on instead?" and proceed from their answer
- Optionally suggest `/standup` if they want to reassess the full picture

---

## Stale Ticket Detection

If step 3 reveals the current ticket from the handoff is already `Done` in kanban:

```
ℹ️ The ticket from the handoff (#N — [name]) is already marked Done in kanban.
   The handoff may be from a session that completed fully.

The next open ticket in kanban is: #N — [name]

Continue with that, or run /standup for a full orientation? (continue / standup)
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/HANDOFF.md` missing | Stop — suggest `/standup` |
| Handoff older than 7 days | Warn and offer choice |
| Handoff exists but has no "Next Action" | Note "Handoff has no next action recorded." Present what is there and ask the user to direct. |
| Referenced kanban ticket not found | Note "Ticket not found in kanban — it may have been completed or removed." Ask user to confirm next step. |
| Referenced PRD not found | Skip PRD load. Note "PRD not found at referenced path." |
| `docs/kanban.md` missing | Skip cross-check. Proceed from handoff alone, note "kanban not found — state is from handoff only." |

---

## Rules

- HANDOFF.md is the primary source — do not override it with inferences from other files
- Never auto-start implementation — always confirm with the user first
- Keep the output brief — this is resumption, not a report
- If the handoff suggests specific skills for the next session, surface them after the next action
- Never run `/standup` automatically — offer it as an option, let the user choose
