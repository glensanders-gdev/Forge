---
name: "pickup"
description: "Resume a session exactly where it left off. Reads the stream register at docs/HANDOFF.md, picks a stream, loads its handoff and referenced artifacts, and presents the exact next action. Use when user runs $pickup or wants to resume interrupted work without re-reading the conversation. For daily planning orientation use $standup instead."
metadata:
  category: session
  version: 3.0.1
  argument_hint: "[stream-slug]"
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Pickup

Resume work from where the last session ended on **one stream**. The stream's handoff at
`docs/handoffs/<slug>.md` is the source of truth — it captures what was in progress, what was
decided, and what to do next, written by `$handoff`, `$save-state`, or `$debrief`. The register at
`docs/HANDOFF.md` lists which streams exist.

The register and stream schemas, and the stream lifecycle, are specified in
**`~/.agents/skills/handoff/STREAMS.md`**.

Named for its pair: `$handoff` puts a stream down, `$pickup` takes it up. (Renamed from
`/continue` in v3.25.0 — that name is shadowed by a Claude Code built-in.)

This skill is focused and fast: pick a stream, load its state, confirm the next action, start
working. For broader daily orientation across all streams (priorities, deadlines, PI plan) use
`$standup` instead.

**`$pickup` never writes.** It reads state; it does not migrate, close, or update anything.

---

## Process

### Step 1 — Read the register

Read `docs/HANDOFF.md`.

**If it does not exist:**
```
⚠️ No handoff register found at docs/HANDOFF.md.

There is no saved session state for this project.
Run $standup to orient from the project's living documents instead.
```
Stop. Do not continue.

**If it is a legacy single-document handoff** (heading `# Handoff:`, no `| Stream |` table):
read it exactly as written and carry on from Step 3 — it is the only stream. Note once:
```
ℹ️ This project still uses the single-document handoff. The next $handoff will migrate it
   to the stream register. Nothing is lost — continuing from it as-is.
```

### Step 2 — Resolve the stream

| Situation | Behaviour |
|---|---|
| Slug given as an argument | Load that stream. If no row matches, say so and list what does exist. |
| One `Active` stream | Load it, naming it in the output. |
| More than one `Active` stream | Present the picker below. Never choose for the user. |
| No `Active` streams | Show the Paused and Blocked rows and ask which to resume. |

Picker:
```
Open streams:

  1. ord-pack          Active   updated 2h ago    → Reconcile the two pack trees
  2. capacity-report   Paused   updated 18d ago   → Draft §3 thresholds
  3. junction-sync     Blocked  updated 25d ago   → Waiting on API access

Which stream? (1-3, or a slug)
```
Wait for input.

### Step 3 — Check the stream's age

Compare the stream file's `Last updated` to today.

**If more than 7 days old:**
```
⚠️ This stream was last updated [N] days ago (YYYY-MM-DD).

It may no longer reflect current project state.

Options:
  1. Continue from it anyway
  2. Run $standup for a fresh orientation from the project files

Which would you prefer? (1 / 2)
```
Wait for input. If the user chooses 2, stop — prompt them to run `$standup`.

Where a stream is Active and stale, add: "It is still marked Active — `$handoff <slug> --close`
retires it, or `$debrief` can pause it." Never change the status here.

### Step 4 — Load referenced artifacts (silent)

From the stream handoff, identify and read:
- The current ticket in `docs/kanban.md` — confirm its current status
- The active PRD in `docs/prd/active/` if referenced
- The most recent `docs/DEVLOG.md` entry (last entry only)

Load only what **this stream** references. Other streams' artifacts stay unread — that is the
point of splitting them.

Cross-check: if the kanban shows the ticket from the handoff is now marked Done, flag it (the
handoff may be stale even if recent).

### Step 5 — Present session state

```markdown
## Resuming — [Project Name] · `[stream-slug]`

**Stream:** [Title]  ([Status])
**Handoff written:** YYYY-MM-DD HH:MM  ([N hours/days ago])
**Session type:** [from handoff]

---

### Where We Left Off

[What just happened — from the handoff, 2-3 sentences max]

---

### Current Ticket

**#N — [Ticket name]** `[AFK/HITL]`
Status: [from kanban cross-check]

---

### Next Action

[Exact next action from the handoff]

---

[If open decisions exist:]      ### Open Decisions
[If blockers exist:]            ### Blockers
[If context notes exist:]       ### Context
[If another Active stream shares this stream's Touches:]
### ⚠️ Shared Artifacts
`[path]` is also being written by stream `[other-slug]`.

---

Ready to continue? (yes — start on [next action] / no — I'll redirect)
```

### Step 6 — Confirm and proceed

If the user confirms:
- Begin executing the next action immediately
- Do not re-read files already loaded in step 4

If the user redirects:
- Ask "What would you like to work on instead?" and proceed from their answer
- Offer `$pickup <other-slug>` if they meant a different stream, or `$standup` for the full picture

---

## Stale Ticket Detection

If step 4 reveals the current ticket from the stream handoff is already `Done` in kanban:

```
ℹ️ The ticket from this stream's handoff (#N — [name]) is already marked Done in kanban.
   The handoff may be from a session that completed fully.

The next open ticket in kanban is: #N — [name]

Continue with that, or run $standup for a full orientation? (continue / standup)
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/HANDOFF.md` missing | Stop — suggest `$standup` |
| Legacy single-document handoff | Read it as-is, note that `$handoff` will migrate it. **Never migrate here** — `$pickup` is a read path. |
| Register lists a stream whose file is missing | Report the broken row and offer the other streams. Never silently skip it — a missing stream file is lost work, not an empty one. |
| Slug given matches no row | List the streams that do exist and ask. Never fall back to "the only Active one" — the user named something specific. |
| Stream older than 7 days | Warn and offer the choice |
| Stream handoff has no "Next Action" | Note "This stream has no next action recorded." Present what is there and ask the user to direct. |
| Referenced kanban ticket not found | Note "Ticket not found in kanban — it may have been completed or removed." Ask user to confirm next step. |
| Referenced PRD not found | Skip PRD load. Note "PRD not found at referenced path." |
| `docs/kanban.md` missing | Skip cross-check. Proceed from the handoff alone, note "kanban not found — state is from the handoff only." |
| A `.conflict-*` file sits beside the stream file | Surface it: two sessions wrote this stream. Present both timestamps and ask which is current before loading either. |

---

## Rules

- The stream handoff is the primary source — do not override it with inferences from other files
- Load one stream, not all of them — reading every stream defeats the split
- Never auto-start implementation — always confirm with the user first
- Never write: no migration, no status change, no register edit
- Keep the output brief — this is resumption, not a report
- If the handoff suggests specific skills for the next session, surface them after the next action
- Never run `$standup` automatically — offer it as an option, let the user choose
