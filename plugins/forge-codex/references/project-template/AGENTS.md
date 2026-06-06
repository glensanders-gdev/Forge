# Forge — Project Instructions

You are a development assistant working on **[PROJECT NAME]**.

Read this file completely at the start of every session before doing anything else.

---

## Project Context

- **Type:** [web app / mobile app / API / script / other]
- **Stack:** [stack]
- **Hosting:** [hosting]
- **Live URL:** [url or "not yet deployed"]
- **Repository:** [repo url]
- **Project ID:** PROJ-NNN  ← set automatically by $create-project or $onboard
- **Origin:** IDEA-NNN ([idea name]) | None  ← set automatically by $create-project
- **Current version:** [vX.XX]
- **Last session:** [date]

---

## Key Files

| File | Purpose |
|------|---------|
| `[working file]` | Primary working file |
| `[versioned saves pattern]` | e.g. app_vX_XX.html |
| `docs/CONTEXT.md` | Domain glossary — canonical terminology |
| `docs/DEVLOG.md` | Session history log |
| `docs/HANDOFF.md` | Always-current session handoff (agent-managed) |
| `docs/kanban.md` | Current ticket board |
| `docs/adr/` | Architecture Decision Records |
| `docs/known-issues.md` | Active and deferred project issues and known limitations |
| `docs/prd/active/` | Active PRD |
| `docs/prd/archived/` | Archived PRDs (post-approval) |
| `docs/tests/registry.md` | Project-wide TC-NNN test case registry |
| `docs/tokens/` | Per-feature token usage records |
| `README.md` | Public-facing project overview |

---

## Session Start (Automatic)

At the start of every session, before anything else:

1. Read `~/.codex/forge/preferences.md` — global preferences. Respect these throughout. Also load `~/.codex/forge/rules/common/git-safety.md` if present — confirm before push and before any destructive git operation.
2. Read `~/.codex/forge/knowledge/company/acronyms.md` — company terminology.
3. Read `docs/HANDOFF.md` if it exists — highest-signal context. If "Current phase" field shows the same phase continuing, increment the session counter in `docs/tokens/[feature].md`.
4. Read `docs/CONTEXT.md` — project domain glossary. Skip silently if the file is empty or contains only the stub template (no terms defined yet). Domain model is built progressively via `$grill-with-docs`.
5. Read the most recent entry of `docs/DEVLOG.md` only — not the full file.
6. Read `docs/kanban.md` — current ticket state.
7. Read `~/.codex/forge/priorities.md` — global feature priority order.
8. State current version or latest git tag.
9. Confirm session goals (max 3). Do not begin work until confirmed.
10. State any assumptions upfront.

**Load only what you need.** Steps 1–7 above are the mandatory baseline. Load additional files on demand — do not pre-load the full project structure before understanding what the session requires. Exception: `HANDOFF.md` always loads.

---

## On-Demand Reference Files

The agent loads these automatically when the work requires them — no manual action needed.

| File | Load when |
|------|-----------|
| `.codex/forge/CODING-STANDARDS.md` | Before any code change |
| `.codex/forge/ERROR-HANDLING.md` | When debugging or setting up error infrastructure |
| `.codex/forge/SECURITY.md` | Before any change touching data, APIs, or auth |
| `.codex/forge/TESTING.md` | Before writing tests or running $tdd |

---

## Knowledge References

| System | Files to Load |
|--------|--------------|
| | `~/.codex/forge/knowledge/systems/[system]/overview.md` |
| | `~/.codex/forge/knowledge/systems/[system]/known-issues.md` |

> Before proposing any solution involving a known system, check its `known-issues.md` first.

> **Staleness check:** When loading any knowledge file, check its `Last updated` date against `staleness-warning-days` in `~/.codex/forge/preferences.md` (default 90 days). Warn if exceeded.

---

## Stage Pipeline

```
$grill-with-docs → Research? → Prototype? → $write-prd → Kanban → $build → $qa-plan → $approve
```

Suggest the next stage at the end of each stage. Wait for human confirmation before proceeding.

---

## Core Concepts

| Term | Meaning |
|------|---------|
| `[HITL]` | Human-in-the-Loop — task requires human present |
| `[AFK]` | Away from Keyboard — AI executes autonomously |
| `[BUG]` | Bug fix — safe to execute during buffer window |
| `[PREP]` | Deployment prep — safe during buffer window |
| `blocked-by: #N` | Cannot start until ticket #N is complete |
| Smart Zone | Keep each unit of work under 100k tokens |
| Buffer window | Days before the release date (default: Friday–Sunday). Set by company config — run `company-add` |
| Release day | Set by company config (default: 3rd Monday of each month) |
| Sprint start | Set by company config (default: Tuesdays) |

---

## Session Goals Discipline

- Agree on 1–3 specific goals at session start.
- Do not begin new features if current goals are incomplete.
- If scope expands mid-session, explicitly agree before continuing.
- Deferred items go to the backlog — not abandoned.

---

## Stale Estimate Detection

When scope changes, check the active PRD's `Estimate Status` field:
- If `Current`, update to `Stale — scope changed YYYY-MM-DD`
- Flag: "⚠️ Estimates may be stale — run `estimate` to update."
- Never auto-update estimates — flag only.

---

## Context Window Exhaustion Protocol

If context exhaustion is imminent, immediately run `save-state`:

1. Write `docs/HANDOFF.md` — highest priority
2. Write `docs/kanban.md` — second priority
3. Append to `docs/DEVLOG.md` — lowest priority, skip if too limited
4. Report: "⚠️ Context limit reached. State saved. Start a new session and run build to resume."

Never attempt another substantive operation after detecting imminent exhaustion.

---

## Session End (Automatic)

Before closing any session:

1. **Update `docs/HANDOFF.md`** — overwrite with:
   - Session type: Planning | Build | QA | Sprint Close | PI Management | Deployment | Ad Hoc
   - Current phase and session count for that phase
   - Current ticket and status
   - What was just done (one or two sentences)
   - Exact next action
   - Open decisions and blockers
2. State final version number and summary of changes.
3. Update `docs/kanban.md` — move completed tickets to Done.
4. Append to `docs/DEVLOG.md` (newest at top):

```markdown
## Session YYYY-MM-DD

**Version range:** vX.XX → vX.XX (single-file) or git tag (multi-file)
**Goals this session:** [1–3 goals]
**Tickets Completed:** #N, #N
**Decisions Made:** [summary — reference ADR filename if created]
**Assumptions Made:** [assumption — confirmed by user/evidence]
**Blockers:** [any HITL or external blockers]
**Next Up:** [next tickets in queue]
**Status:** In Progress | Approved
```

5. Update `README.md` if user-facing behaviour changed.
6. State updated backlog with priorities.
7. Note anything deferred and why.

---

## On `$approve`

When the human runs `approve`, the `$approve` skill handles everything. Summary:
- PRD archived, DEVLOG sealed, kanban closed, HANDOFF reset
- Token record rolled up to global ledger
- Coding standards and README update prompted
- "✓ Approved. PRD archived. Session sealed. Ready for next feature."

**Never reference an archived PRD in any future session.**
