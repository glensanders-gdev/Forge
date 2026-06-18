# Handoff: Forge Framework

**Last updated:** 2026-06-18
**Session type:** Ad Hoc (framework maintenance — assimilation)

---

## Current Ticket

No active feature — kanban clear since forge-junction-sync approval (2026-06-01). Today was assimilation-driven maintenance: two `/assimilate` runs of Matt Pocock material, both delivered and merged (PR #12, PR #13). `forge_version` now **3.11.0**.

---

## What Was Just Done

Assimilated two Matt Pocock skills into Forge:
1. **"Writing Great Skills"** → enhanced `/write-a-skill` with a new `CRAFT.md` (leading words, completion criteria, information hierarchy, pruning/no-op discipline, failure-modes lens). `write-a-skill` 1.1.0→1.2.0, v3.10.0→3.10.1. **PR #12 merged.**
2. **"teach"** → new `/teach` skill (knowledge category): mission-grounded, ZPD-pitched multi-session learning with consolidated `FORMATS.md`; workspaces under `~/.claude/knowledge/learning/`. Reuses `/add-term`, `/research`, ADR conventions. `teach` 1.0.0, v3.10.1→3.11.0. **PR #13 merged.**

Both included Codex plugin regen + `plugin.json` bump; parity passed on each (104 shared skills at close).

---

## Next Action

Pick up the still-open **P3 backlog item**: skill completeness sweep — add `## Failure Modes` to 43 skills (pipeline-core first: grill-with-docs, qa-plan, qa-report, review, tdd, testplan, estimate, sprint-start, sprint-end, debrief, idea, critic) and `## Rules` to 7 skills. Source: `~/.claude/knowledge/skill-health-report.md`. Note: `/teach` and `write-a-skill` now both carry Failure Modes sections — usable as reference exemplars.

Alternative: dashboard-tokens template extraction to `references/` (top recommendation in `docs/skill-size-audit.md`) — not yet on the backlog; add via `/backlog-add` if pursuing.

---

## Open Decisions

- **Uncommitted session docs** — this debrief's edits to `docs/HANDOFF.md`, `docs/DEVLOG.md`, `docs/kanban.md`, `docs/tokens/forge-maintenance.md` are in the working tree only. They sit alongside *pre-existing* uncommitted 2026-06-11 edits to DEVLOG/HANDOFF that were never committed. Decide whether to commit the docs trail.
- **Untracked files** awaiting a commit decision (carried from 2026-06-11): repo-root `CLAUDE.md`, `docs/context-health-report.md`, `docs/dashboard/`, `docs/tokens/forge-maintenance.md`. My `CLAUDE.md` skill-count edit (103→104) only lands if `CLAUDE.md` is tracked.
- **Git tags lag** — latest pushed tag is `v3.10.0`; tags for `v3.10.1` and `v3.11.0` not yet created/pushed (write-a-skill checklist step). Create them if treating these as releases.
- Deferred QA cycle: TC-001–TC-010 for forge-junction-sync still waived (carried from 2026-06-01).
- Repo move off OneDrive (Windows machine) still pending — re-run install.sh after moving.

---

## Blockers

None.
