---
name: build
category: pipeline
description: Execute the current sprint's AFK tickets in sequence, running /tdd for each. Pauses at HITL tickets and blockers with clear prompts. Updates kanban in real time. Resumable across sessions. Use when user runs /build or is ready to begin implementation work on the current sprint.
---

# Build

Execute the current sprint's tickets. The human signals `/build` once — the agent works through the AFK queue autonomously, pausing only when human input is genuinely required.

## Pipeline Position

```
/sprint-start → /build (per ticket: /tdd → /review) → /qa-plan → /pii-check → /approve
```

## Pre-Flight Checks

**Step 0 — Resolve active company:** Read `~/.claude/preferences.md`. If `active-company:` is set, use that value in place of `[active_company]` throughout this run. If not set, skip all company-config reads and apply defaults.

Before executing any ticket:

1. Read `docs/kanban.md` — identify current sprint tickets (In Progress and Backlog). If none found: "No sprint tickets found in kanban.md. Run `/user:sprint-start` to open a sprint first."
2. Read `docs/prd/active/` — confirm feature scope.
3. Check for `docs/testplan-[feature].md`. If found, use its TC IDs to guide test writing during the build loop. If not found, warn before proceeding:
   ```
   ⚠️ No testplan found for this feature.

   Without a testplan, /build cannot track test cases to TC-NNN IDs and
   /qa-plan will have no TC registry to draw from.

   Run /testplan first? (yes — stop and run /testplan / no — proceed without)
   ```
   Wait for response. On `yes`, stop. On `no`, note "TC tracking not available — no testplan" and continue.
4. Read `~/.claude/sprints/calendar.md` — confirm current sprint dates.
5. Check for resumable state — any tickets already In Progress from a previous build session (see Resuming a Build).
6. Read company config `~/.claude/companies/[active_company]/config.md` (if set):
   - `ai_human_signoff_required: true` → add a mandatory HITL sign-off gate before each ticket is marked Done (Execution Loop Step 4)
   - `ai_data_restrictions` → note at build start: "⚠️ AI policy: [restrictions] — do not include restricted data in prompts or generated code."
7. Check required tools — if a company is set, read `~/.claude/companies/[active_company]/tools.md` and run the `check-command` for each tool marked `required`. If any is missing, stop:
   ```
   ⛔ Required tools missing — install before running /build:

     [tool-name] ([category])
       Install: [install-hint from registry]

   Run /tool-check for the full picture.
   ```
8. Check sprint buffer window — read `~/.claude/sprints/calendar.md` and `~/.claude/pi/[current-pi]/plan.md`. If today falls within the buffer window (Friday–Sunday before a release Monday), warn and wait for an explicit decision:
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
9. Pre-build health check — if a `build-check` command is defined in `CLAUDE.md` or `.claude/deploy.md`, run it. On failure, stop:
   ```
   ⛔ Pre-build check failed

   Command: [command]
   Output: [error output]

   The codebase is in a broken state. Fix this before running /build.
   Run /user:diagnose for help investigating.
   ```
10. Present the build queue and wait for `CONFIRM` before executing anything:
    ```
    ## Build Queue — Sprint-NN

    Ready to execute:
    - [AFK] #N [Ticket name]

    Pausing at:
    - [HITL] #N [Ticket name] — requires: [what's needed]
    - [AFK] #N [Ticket name] `blocked-by: #M` — blocked until #M done

    Type CONFIRM to begin, or adjust the queue first.
    ```

---

## Execution Loop

For each ticket in the queue, in order:

### Step 1 — Smart Zone Check

Estimate ticket size before executing. If it appears to exceed 100k tokens of work, pause and wait for a decision:
```
⚠️ Smart Zone Warning — #N [Ticket name]

This ticket looks larger than the smart zone limit.
Running it as-is risks an incomplete or low-quality result.

Options:
1. Run /break-down to split it first (recommended)
2. Proceed anyway (accepted risk)

Type 1 or 2.
```

### Step 2 — Mark In Progress

Update `docs/kanban.md` immediately: `- [>] [AFK] #N [Ticket name]  ← In Progress`

### Step 3 — Execute with TDD

Run the TDD cycle for each AFK ticket:

```
RED:      Write test for the behaviour → confirm it fails
GREEN:    Implement minimum code to pass → confirm tests pass
REFACTOR: Clean up — run tests again to confirm still green
```

Reference `docs/testplan-[feature].md` for which behaviours to test. Follow all rules from the TDD skill — vertical slices, public interfaces only, no horizontal slicing.

**Test-execution cadence** — keep the feedback loop tight without paying for the full suite on every change (adapted from Matt Pocock's `implement` skill, github.com/mattpocock/skills):
- **Typecheck regularly** as you write — catch type breaks the moment they appear, not at the end.
- **Run single test files regularly** — the RED/GREEN cycle drives the file under change; do not run the whole suite to confirm one behaviour.
- **Run the full suite once, at the end of the ticket** — the whole-project pass is the final gate before Step 4 review, not a per-edit habit. If the full suite is red at ticket end, the ticket is not done.

### Step 4 — Post-Build Review

Once the ticket's tests are green, run `/user:review` on **this ticket's diff** (the files written during this ticket) — the two-axis review: Spec (does the diff fulfil the ticket's requirement) and Standards (project docs + smell baseline). This is AFK and advisory — it does not auto-fix.

Surface the result inline, then handle by severity:
- **P1 findings (Spec miss or documented-standard/ADR breach):** pause before the ticket can be marked Done:
  ```
  🔎 Review — #N [Ticket name] — P1 findings

  [Axis]: [finding] — [file:line] — [why blocking]

  Options:
  1. Fix now (stay on this ticket, re-run /tdd + /review)
  2. Defer to backlog (/backlog-add) and mark ticket Done anyway (accepted risk)
  3. Stop the build here

  Type 1, 2, or 3.
  ```
  Wait for the decision. Never auto-fix and never silently pass a P1.
- **P2 / P3 findings:** record them in the review output and continue — do not block. Note them for `/qa-plan`.
- **Both axes clean:** note "Review clean" and continue.

### Step 5 — Human Sign-Off Gate (if ai_human_signoff_required)

If company config set `ai_human_signoff_required: true`, pause before marking the ticket Done:

```
✋ AI policy: human sign-off required before this ticket is marked complete.

Ticket: #N [Ticket name]
Work completed: [brief summary of what was built and tested]

Review the changes and type APPROVED to close this ticket, or REWORK to continue.
```

Wait for `APPROVED`. Do not mark tickets Done autonomously when this policy is active.

### Step 6 — Mark Done

On completion, run a lightweight PII hint scan on files written during this ticket (email patterns, phone formats, obvious real names in fixtures or hardcoded values). If found, flag immediately — "⚠️ Possible PII in #N [file:line] — review before committing" — but do not block; full `/pii-check` runs in QA.

Judge the actual token band consumed (S/M/L/XL — coarse band judgement, not a count) against the ticket's estimate tag (e.g. `M | 5pts`). Recorded in `docs/kanban-archive.md` when the ticket is archived at sprint end, with over-band actuals flagged for calibration:
```
- [x] [AFK] #N Ticket name `estimated: M | actual: M` ✓
- [x] [AFK] #N Ticket name `estimated: M | actual: L` ⚠️ over
```

Update `docs/kanban.md` immediately: `- [x] [AFK] #N [Ticket name]  ✓`

### Step 7 — Context Checkpoint

After every 3 completed tickets, if 3 or more remain in the queue, checkpoint:

```
## Build Checkpoint — Sprint-NN

Completed this session: #N, #N, #N (N total)
Remaining in queue: N tickets

Context summary:
- [One sentence on what was built]
- [Any patterns or decisions worth noting]

[If 6+ tickets completed this session]:
⚠️ Context is getting large — N tickets remain.

Type CONTINUE, PAUSE, or just press Enter to continue.
```

Re-read `docs/kanban.md` fresh at each checkpoint to reset effective context. On `PAUSE`, run `/user:save-state` and stop cleanly. If fewer than 3 tickets remain, skip the checkpoint.

Then move to the next ticket in the queue.

---

## HITL Pause

When the queue reaches a HITL ticket, wait indefinitely:

```
⏸️  HITL Required — #N [Ticket name]

What's needed:
[Exact description of what the human must do, decide, or provide]

When you're ready, type CONTINUE to resume the build.
```

After `CONTINUE`, execute any follow-up AFK work that was blocked by this HITL ticket, then continue the queue.

## Blocker Pause

When a ticket has an unresolved `blocked-by` dependency:

```
🚧  Blocked — #N [Ticket name] — blocked by #M [Ticket name], not yet complete.

Options:
1. Skip this ticket and continue with unblocked tickets
2. Stop the build here

Type 1 or 2.
```

## Resuming a Build

When `/build` is run and tickets are already In Progress or partially done, present what was previously completed and the next ticket in the queue, then wait for `CONFIRM` to resume.

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

## Scope Rules

- Execute current sprint tickets only — never pull from general backlog without `/sprint-replan`
- If a ticket is not in the current sprint, flag it and skip
- Never create new tickets during build — surface gaps to the human after the loop completes
- If scope appears to have grown mid-build, flag it and suggest `/scope-check`

## Rules

- Always present the build queue and wait for `CONFIRM` before executing anything
- Update kanban in real time — never batch updates
- Run `/tdd` for every AFK ticket — never skip tests
- Never run the full test suite after every change — single test files and typechecks as you go, full suite once at ticket end (see Step 3 cadence)
- Run `/review` on every ticket's diff once tests are green — never skip the post-build review, and never auto-fix or silently pass a P1 finding
- Never deploy — build produces tested code only; deployment is handled by `/go-nogo` and `/deploy`
- DEVLOG and token records are not updated during build — defer to `/debrief`
- Smart zone check is mandatory for every ticket — never skip it
- Resumable by design — reading kanban state is always the first step

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No kanban found | "No kanban.md found. Run `/user:sprint-start` to open a sprint first." |
| No sprint tickets | "No sprint tickets found. Add tickets via `/user:backlog-add` or `/user:write-prd`." |
| Tests fail after implementation | Run `/user:diagnose` automatically if same test fails twice. Surface to human if still failing. |
| Review returns a P1 finding | Pause per Step 4 — fix now, defer to backlog, or stop. Never auto-fix, never mark the ticket Done with an unresolved P1. |
| Codebase in broken state at start | "Codebase has failing tests before build began. Fix these before running `/build`." Surface the failures. |
| All tickets blocked | "All remaining tickets are blocked. Resolve blockers then resume with `/user:build`." |
