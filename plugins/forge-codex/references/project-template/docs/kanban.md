# Kanban: [Project Name]

Ticket board for the current feature. Updated by the AI agent as work progresses.

**Tags:**
- `[HITL]` — Human-in-the-Loop: requires human present to execute
- `[AFK]` — Away from Keyboard: AI can execute autonomously
- `[BUG]` — Bug fix: safe to execute during buffer window
- `[PREP]` — Deployment prep: safe to execute during buffer window
- `` `blocked-by: #N` `` — cannot start until ticket #N is complete
- `` `S|M|L|XL | Npts` `` — token cost band and story point estimate (e.g. `M | 5pts`)
- `` `XL ⚠️` `` — requires `$break-down` before `$build` can execute

---

## In Progress

_Nothing in progress._

## Backlog

_No tickets yet. Run `$write-prd` to generate tasks._

## Done

_Nothing completed yet._

<!--
Ticket format:
- [ ] [HITL] #1 Short description of task
- [ ] [AFK] #2 Short description of task `blocked-by: #1`
- [x] [AFK] #3 Completed task
-->
