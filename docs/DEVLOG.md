# DEVLOG — Forge Framework

---

## Session 2026-06-18

**Version range:** 3.10.0 → 3.11.0 (PRs #12 and #13 merged to main)
**Goals this session:** Assimilate Matt Pocock's "Writing Great Skills" into `/write-a-skill`; assimilate his "teach" skill into Forge
**Tickets Completed:** None (no kanban tickets — assimilation-driven maintenance; both `/assimilate` runs delivered and merged)
**Decisions Made:** (1) Pocock skill-craft folded into `write-a-skill` as a new `CRAFT.md` reference + SKILL.md edits rather than a separate skill (v3.10.1, PR #12). (2) `/teach` added as a new `knowledge`-category skill with workspaces under `~/.claude/knowledge/learning/`, a single consolidated `FORMATS.md`, and explicit reuse of `/add-term` (glossary), `/research` (resources), and ADR/`/learn` (records) rather than duplicating them (v3.11.0, PR #13). Domain tension (personal upskilling vs software delivery) raised and user-confirmed before writing.
**Assumptions Made:** `plugins/forge-codex/.codex-plugin/plugin.json` version is hand-maintained — `build-forge-codex.ps1` does not bump it (confirmed: parity failed until bumped manually, saved to memory). Repo-root `CLAUDE.md` is untracked, so its skill-count edit was deliberately left out of PR #13 (confirmed by `git status`).
**Blockers:** None
**Next Up:** Skill completeness sweep (P3 backlog — 43 Failure Modes + 7 Rules sections, pipeline-core first); decide whether to commit the session docs trail and the carried untracked files; create/push `v3.10.1` and `v3.11.0` tags if treating as releases
**Status:** In Progress

---

## Session 2026-06-11

**Version range:** 3.9.0 → 3.9.0 (commits 4af34c5 → 32cbe96, PRs #9 and #10 merged)
**Goals this session:** Critic the framework (tiered governance / token optimisation / model selection); execute resulting backlog items; run health audits
**Tickets Completed:** None (no kanban tickets — backlog-driven maintenance; both global backlog items delivered)
**Decisions Made:** Tier system and per-ticket model selection dropped after critique — accepted trade-off: trivial fixes keep full pipeline ceremony; revisit if informal skill-bypassing becomes routine. Token recording moved to ccusage actuals at /debrief and /sprint-end (per-skill guessing retired). Version-mismatch sync policy: align to the higher version on either side.
**Assumptions Made:** ccusage daily totals are machine-wide for the day — attribution to a single feature noted in the token record (confirmed by ccusage output structure). forge-install override unaffected by frontmatter-only version bump (confirmed by diff review).
**Blockers:** None
**Next Up:** Skill completeness sweep (P3 backlog — 43 Failure Modes + 7 Rules sections, pipeline-core first); optionally dashboard-tokens template extraction; decide on untracked docs (context-health report, dashboard, root CLAUDE.md)
**Status:** In Progress

---

## Session 2026-06-01 — APPROVED ✓

**Feature:** Forge Junction-Based Sync (v3.7.0)
**Tickets Completed:** #1, #2, #3, #4, #5, #6, #7
**QA:** Waived — all 10 TCs deferred to future cycle; P1s partially verified during build session
**PRD:** Archived
**Status:** Approved
