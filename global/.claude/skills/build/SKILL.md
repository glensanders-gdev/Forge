---
name: build
description: Execute the current sprint's AFK tickets in sequence, running /tdd for each. Pauses at HITL tickets and blockers with clear prompts. Updates kanban in real time. Resumable across sessions. Use when user runs /build or is ready to begin implementation work on the current sprint.
---

# Build

Execute the current sprint's tickets. The human signals `/build` once — the agent works through the AFK queue autonomously, pausing only when human input is genuinely required.

## Pipeline Position

```
/sprint-start → /build → /qa-plan → /pii-check → /approve
```

## Pre-Flight Checks

**Step 0 — Resolve active company:** Read `~/.claude/preferences.md`. If `active-company:` is set, use that value in place of `[active_company]` throughout this run. If not set, skip all company-config reads and apply defaults.

Before executing any ticket:

1. Read `docs/kanban.md` — identify current sprint tickets (In Progress and Backlog)
2. Read `docs/prd/active/` — confirm feature scope
3. Read `docs/testplan-[feature].md` if it exists — understand what needs testing
4. Read `~/.claude/sprints/calendar.md` — confirm current sprint dates
5. Check for resumable state — any tickets already In Progress from a previous build session
6. **Read company config** — `~/.claude/companies/[active_company]/config.md` (if set):
   - `ai_human_signoff_required` — if `true`, add a mandatory HITL sign-off gate before each ticket is marked Done (see Execution Loop Step 4)
   - `ai_data_restrictions` — if set, note at build start: "⚠️ AI policy: [restrictions] — do not include restricted data in prompts or generated code."

7. **Check required tools** — if a company is set, read `~/.claude/companies/[active_company]/tools.md`:
   - For each tool marked `required`: run its `check-command`
   - If any required tool is missing, stop:
     ```
     ⛔ Required tools missing — install before running /build:

       [tool-name] ([category])
         Install: [install-hint from registry]

     Run /tool-check for the full picture.
     ```
   - If all required tools are present, proceed silently.

If no sprint tickets found: "No sprint tickets found in kanban.md. Run `/user:sprint-start` to open a sprint first."

4. **Check sprint buffer window** — read `~/.claude/sprints/calendar.md` and `~/.claude/pi/[current-pi]/plan.md`:
   - If today falls within the buffer window (Friday–Sunday before a release Monday), warn:
     ```
     ⚠️ Buffer Window Active

     You are in the buffer window for PI-N-RN (Release: Mon DD MMM).
     Friday EOD is the last working day for feature tickets.
     During the buffer window, only bug fixes [BUG] and deployment prep [PREP] should be executed.

     Tickets in queue flagged as feature work: #N, #N
     Tickets flagged as [BUG] / [PREP]: #N, #N

     Type BUILD-FEATURES to proceed with all tickets (accepted risk)
     Type BUILD-FIXES to execute [BUG] and [PREP] tickets only
     Type STOP to cancel
     ```
   - Wait for explicit decision before proceeding.

5. **Pre-build health check** — if a `build-check` command is defined in `CLAUDE.md` or `.claude/deploy.md`, run it before the build loop begins:
   - If it passes → proceed
   - If it fails → stop:
     ```
     ⛔ Pre-build check failed

     Command: [command]
     Output: [error output]

     The codebase is in a broken state. Fix this before running /build.
     Run /user:diagnose for help investigating.
     ```

6. **Present build queue** before starting.

```
## Build Queue — Sprint-NN

Ready to execute:
- [AFK] #N [Ticket name]
- [AFK] #N [Ticket name]
- [AFK] #N [Ticket name]

Pausing at:
- [HITL] #N [Ticket name] — requires: [what's needed]
- [AFK] #N [Ticket name] `blocked-by: #M` — blocked until #M done

Type CONFIRM to begin, or adjust the queue first.
```

Wait for `CONFIRM` before executing anything.

---

## Execution Loop

For each ticket in the queue, in order:

### Step 1 — Smart Zone Check

Before executing, estimate ticket size:
- If the ticket appears to exceed 100k tokens of work, pause:
  ```
  ⚠️ Smart Zone Warning — #N [Ticket name]

  This ticket looks larger than the smart zone limit.
  Running it as-is risks an incomplete or low-quality result.

  Options:
  1. Run /break-down to split it first (recommended)
  2. Proceed anyway (accepted risk)

  Type 1 or 2.
  ```
- Wait for human decision before continuing.

### Step 2 — Mark In Progress

Update `docs/kanban.md` immediately:
```markdown
- [x→] [AFK] #N [Ticket name]  ← In Progress
```

### Step 3 — Execute with TDD

For each AFK ticket, run the TDD cycle:

```
RED:   Write test for the behaviour → confirm it fails
GREEN: Implement minimum code to pass → confirm tests pass
REFACTOR: Clean up — run tests again to confirm still green
```

Reference `docs/testplan-[feature].md` for which behaviours to test.
Follow all rules from the TDD skill — vertical slices, public interfaces only, no horizontal slicing.

### Step 4 — Human Sign-Off Gate (if ai_human_signoff_required)

If `ai_human_signoff_required: true` was read from company config in pre-flight, pause before marking the ticket Done:

```
✋ AI policy: human sign-off required before this ticket is marked complete.

Ticket: #N [Ticket name]
Work completed: [brief summary of what was built and tested]

Review the changes and type APPROVED to close this ticket, or REWORK to continue.
```

Wait for `APPROVED` before updating kanban. Do not mark tickets Done autonomously when this policy is active.

### Step 5 — Mark Done

On successful completion, run a lightweight PII hint scan on files written during this ticket:
- Check for email address patterns, phone number formats, and obvious real names in test fixtures or hardcoded values
- If found, flag immediately: "⚠️ Possible PII in #N [file:line] — [description]. Review before committing."
- Do not block the build — note it and continue. Full `/pii-check` runs in QA.

**Track actual token cost** — estimate the actual token band consumed building this ticket:
- Compare against the estimate tag on the ticket (e.g. `M | 5pts`)
- Record in `docs/kanban-archive.md` when the ticket is archived at sprint end:
  ```
  - [x] [AFK] #N Ticket name `estimated: M | actual: M` ✓
  - [x] [AFK] #N Ticket name `estimated: M | actual: L` ⚠️ over
  ```
- Over-band actuals (e.g. estimated M, actual L) flagged ⚠️ for calibration awareness

Update `docs/kanban.md` immediately:
```markdown
- [x] [AFK] #N [Ticket name]  ✓
```

### Step 6 — Context Checkpoint

After every 3 completed tickets, if **3 or more tickets remain in the queue**, checkpoint before continuing:

```
## Build Checkpoint — Sprint-NN

Completed this session: #N, #N, #N (N total)
Remaining in queue: N tickets

Context summary:
- [One sentence on what was built]
- [Any patterns or decisions worth noting]

[If 6+ tickets completed this session]:
⚠️ Context is getting large — N tickets remain.
Continue or PAUSE to save state?

Type CONTINUE, PAUSE, or just press Enter to continue.
```

Re-read `docs/kanban.md` fresh at each checkpoint to reset effective context.
If the human types `PAUSE`, run `/user:save-state` and stop cleanly.
If fewer than 3 tickets remain after the checkpoint, skip it and continue without interruption.

### Step 7 — Next Ticket

Move to the next ticket in the queue.

---

## HITL Pause

When the queue reaches a HITL ticket:

```
⏸️  HITL Required — #N [Ticket name]

This ticket requires your input before it can proceed.

What's needed:
[Exact description of what the human must do, decide, or provide]

When you're ready, type CONTINUE to resume the build.
```

Wait indefinitely. Do not proceed until `CONTINUE` is received.

After `CONTINUE`, execute any follow-up AFK work that was blocked by this HITL ticket, then continue the queue.

---

## Blocker Pause

When a ticket has an unresolved `blocked-by` dependency:

```
🚧  Blocked — #N [Ticket name]

This ticket is blocked by #M [Ticket name] which is not yet complete.

Options:
1. Skip this ticket and continue with unblocked tickets
2. Stop the build here

Type 1 or 2.
```

---

## Resuming a Build

When `/build` is run and tickets are already In Progress or partially done:

```
## Resuming Build — Sprint-NN

Previously completed:
- [x] #N [Ticket name] ✓
- [x] #N [Ticket name] ✓

Resuming from:
- [AFK] #N [Ticket name] ← next in queue

Type CONFIRM to resume.
```

---

## Build Summary

When all executable tickets are done or blocked:

```
## Build Complete — Sprint-NN

✅ Completed: #N, #N, #N (N tickets)
⏸️  HITL stops: N
🚧  Blocked: #N [reason]
⚠️  Smart zone warnings: N

Next steps:
- Run /user:qa-plan to begin QA
- Run /user:debrief to close the session
```

---

## Kanban Notation During Build

| State | Notation |
|-------|---------|
| Queued | `- [ ] [AFK] #N Ticket name` |
| In Progress | `- [>] [AFK] #N Ticket name` |
| Done | `- [x] [AFK] #N Ticket name ✓` |
| HITL waiting | `- [⏸] [HITL] #N Ticket name — awaiting input` |
| Blocked | `- [🚧] [AFK] #N Ticket name blocked-by: #M` |

---

## Scope Rules

- Execute current sprint tickets only — never pull from general backlog without `/sprint-replan`
- If a ticket is not in the current sprint, flag it and skip
- Never create new tickets during build — surface gaps to the human after the loop completes
- If scope appears to have grown mid-build, flag it and suggest `/scope-check`

## Rules

- Always present the build queue and wait for `CONFIRM` before executing anything
- Update kanban in real time — never batch updates
- Run `/tdd` for every AFK ticket — never skip tests
- Never deploy — build produces tested code only; deployment is handled by `/go-nogo` and future `/deploy` skills
- DEVLOG is not updated during build — defer to `/debrief`
- Smart zone check is mandatory for every ticket — never skip it
- Resumable by design — reading kanban state is always the first step

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No kanban found | "No kanban.md found. Run `/user:sprint-start` to open a sprint first." |
| No sprint tickets | "No sprint tickets found. Add tickets via `/user:backlog-add` or `/user:write-prd`." |
| Tests fail after implementation | Run `/user:diagnose` automatically if same test fails twice. Surface to human if still failing. |
| Codebase in broken state at start | "Codebase has failing tests before build began. Fix these before running `/build`." Surface the failures. |
| All tickets blocked | "All remaining tickets are blocked. Resolve blockers then resume with `/user:build`." |

## Token Recording (Automatic)

At build completion (or at each checkpoint if pausing), update `docs/tokens/[feature-name].md`:

```markdown
### Build
**Date range:** [start date] → [end date]
**Sessions:** N
**Input:** ~Nk tokens — Read: [source files, testplan, PRD]
**Output:** ~Nk tokens — [code written, tests]
**Total:** ~Nk ([band])

**Per-ticket breakdown:**
| Ticket | Estimated | Input | Output | Actual | Band |
|--------|-----------|-------|--------|--------|------|
| #N [name] | M | ~Nk | ~Nk | ~Nk | M ✅ |
```

See `~/.claude/skills/token-report/TOKEN-RECORDING.md` for estimation guidance.
