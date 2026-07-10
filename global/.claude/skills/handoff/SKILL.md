---
name: handoff
category: session
version: 1.1.0
description: Compact the current session into a structured handoff document so the next session can continue without re-reading the conversation. Writes to docs/HANDOFF.md. References artifacts by path rather than reproducing content. Suggests skills for the next session. Use /handoff for any planned pause — same-day resume, passing to another agent, or handing to a colleague. Use /debrief for a thorough end-of-day close that updates kanban, DEVLOG, and backlog.
argument-hint: What will the next session focus on?
---

# Handoff

Compact the current conversation into a clean handoff so the next session — whether a fresh agent instance or a human picking up the work — can continue without replaying the entire conversation history.

Adapted from techniques and skills by Matt Pocock (AIHero.dev / github.com/mattpocock/skills), extended for the Forge framework's session and pipeline conventions.

---

## Rules

- **Reference, don't duplicate.** Do not reproduce content already captured in PRDs, ADRs, kanban tickets, DEVLOG entries, testplans, or other Forge artifacts. Reference them by filename or path instead.
- **Forge-first.** The handoff writes to `docs/HANDOFF.md` — read by `/continue` at the next session start.
- **Tailored.** If the user provides an argument (e.g. `/handoff "next session: implement the login flow"`), use it to shape the focus of the handoff — what to prioritise, what context is most relevant.
- **Suggest skills.** At the end, suggest which Forge skills the next session should use first.
- **Never carry secrets across the handoff.** `HANDOFF.md` is a tracked workspace file read by `/continue` — anything written to it is persisted. Never reproduce API keys, passwords, tokens, or PII surfaced during the session. Reference where the value lives (env var, secrets manager, ticket) rather than the value itself; redact anything sensitive that must be mentioned.
- **`/handoff` vs `/debrief` vs `/save-state`:** `/handoff` is for any planned pause — same-day resume, passing to another agent, or handing to a colleague. It writes HANDOFF.md only. `/debrief` is for end-of-day full close — it also updates kanban, DEVLOG, and reorders the backlog. `/save-state` is for emergencies when context limit is imminent.

---

## Process

1. **Read current state** — scan `docs/kanban.md`, the most recent `docs/DEVLOG.md` entry, and any active `docs/prd/active/` document to understand where things stand.

2. **Identify what the user passed as an argument** — if provided, tailor the handoff to that focus. If not provided, infer the most likely next focus from the current kanban and DEVLOG state.

3. **Write `docs/HANDOFF.md`** — overwrite with the structured handoff:

```markdown
# Handoff: [Project Name]

**Last updated:** YYYY-MM-DD HH:MM
**Session type:** [current session type]
**Prepared by:** /handoff[: next focus if provided]

---

## Current Ticket

**#N — [Ticket name]** `[AFK/HITL]`
Status: [In Progress / Blocked / Ready to start]
**Current phase:** [phase name] — Session N of this phase

---

## What Just Happened

[2-3 sentences maximum — what was done, what was decided, what changed.
Reference artifacts by path rather than reproducing content.]

Key artifacts updated this session:
- [path/to/file] — [one-word description of what changed]
- [path/to/file] — [one-word description]

---

## Next Action

[The single most important thing to do first in the next session.
Specific enough that no context is needed.]

---

## Context the Next Session Will Need

[Only include context that is NOT already in Forge artifacts.
If it's in the PRD, kanban, or ADR — reference it, don't repeat it.]

- [Unwritten decision or context that would otherwise be lost]
- [External dependency or blocker the artifacts don't capture]

---

## Open Decisions

[Unresolved decisions the next session must make before proceeding.]
_None_ if nothing is pending.

---

## Blockers

[Anything blocking progress.]
_None_ if nothing is blocked.

---

## Suggested Skills for Next Session

[Based on the current state and next focus, suggest 1-3 Forge skills
the next session should use first — with a brief reason each.]

1. `/user:[skill]` — [why this is the right next step]
2. `/user:[skill]` — [why]
```

4. **Optionally archive** — if the user adds `--archive` (e.g. `/handoff --archive "next session: QA"`), also write a timestamped copy to `docs/handoffs/YYYY-MM-DD-HH-MM-handoff.md` for reference. Create the `docs/handoffs/` folder if it doesn't exist.

5. **Instinct prompt** — at the end of the handoff, include:

```
💡 Did anything this session produce a pattern worth capturing?
   Run /user:learn to capture it before it's forgotten.
```

This is a suggestion only — never mandatory.

---

## Suggested Skills Logic

Base the skill suggestions on the current pipeline position:

| Current state | Suggest |
|--------------|---------|
| PRD written, no testplan | `/testplan` then `/estimate` |
| Testplan done, no build | `/sprint-start` then `/build` |
| Build in progress | `/build` (resume) |
| Build complete, no QA | `/qa-plan` then `/pii-check` |
| QA complete | `/approve` |
| Feature approved, no next PRD | `/grill-with-docs` or `/idea` |
| Known issues flagged | `/diagnose` |
| Scope has changed | `/scope-check` then `/estimate` |
| Buffer window active | `/build` with `BUILD-FIXES` only |

Always suggest `/standup` if the next session is starting fresh (first action of a new day or after a multi-day gap).

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `docs/kanban.md` missing | Write handoff from conversation context only. Note "kanban not found." |
| No active PRD | Note "No active PRD — next session should run /grill-with-docs or /write-prd." |
| Argument provided but vague | Use it as directional context, not a precise instruction. |
| `docs/handoffs/` doesn't exist (archive mode) | Create it silently before writing. |
| Session surfaced a secret or PII value | Never write it into `HANDOFF.md` — reference its location (env var, secrets manager, ticket) and redact the value. |
