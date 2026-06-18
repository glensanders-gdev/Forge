# Kanban — Forge Framework

**Sprint:** Forge Junction Sync
**Started:** 2026-06-01
**Feature:** Junction-Based Sync — `docs/prd/archived/forge-junction-sync.md`
**Status:** Approved — 2026-06-01

<!-- Feature approved 2026-06-01. Board archived. -->
<!-- 2026-06-11: ad-hoc maintenance — PR #9, #10 (no kanban tickets). -->
<!-- 2026-06-18: ad-hoc assimilation — PR #12 (write-a-skill CRAFT.md, v3.10.1), PR #13 (/teach, v3.11.0). No kanban tickets. -->

---

## In Progress

_None_

---

## Backlog

- [x] [AFK]  #2 Rewrite `install.sh` — platform detection, junction/symlink creation, remove copy step ✓
- [x] [AFK]  #3 Deprecate `update.sh` — add deprecation notice, retain file ✓
- [x] [AFK]  #4 Rewrite `/forge-install` skill — auto-detect, migration flow, iOS guidance ✓
- [x] [AFK]  #5 Simplify `/forge-update` skill — replace `update.sh` with `git pull` ✓
- [x] [HITL] #6 Run migration on Windows — confirm junctions resolve, verify skill edits appear in repo ✓
- [x] [AFK]  #7 Commit and push all changes to `origin/main` ✓

---

## Done

- [x] [HITL] #1 Confirm PRD scope and module estimates ✓

---

<!-- Previous sprint: Forge Knowledge Onboard Build (2026-05-23) — shipped as v2.5.6 -->
<!-- Deferred tickets from previous sprint: #2/#7/#10/#11 (api.md design) — tracked in PRD archived/knowledge-onboard.md -->

---

## Done (Previous Sprint)

- [x] [HITL] #1 Review and confirm `style-guide.md` template structure before writing ✓
- [x] [HITL] #3 Review and confirm `/knowledge-onboard` SKILL.md draft before finalising ✓
- [x] [HITL] #4 Review and confirm `/style-check` SKILL.md draft before finalising ✓
- [x] [HITL] #5 Confirm manifest, commands reference, and CHANGELOG updates before push ✓
- [x] [AFK] #6 Create `~/.claude/knowledge/company/style-guide.md` template ✓
- [x] [AFK] #8 Write `/knowledge-onboard` SKILL.md and command file ✓
- [x] [AFK] #9 Write `/style-check` SKILL.md and command file ✓
- [x] [AFK] #12 Extend `/write-article` — consult `style-guide.md` when present ✓
- [x] [AFK] #13 Extend `/write-prd` — consult `style-guide.md` when present ✓
- [x] [AFK] #14 Extend `/knowledge-health` — check `style-guide.md` presence (api.md portion deferred) ✓
- [x] [AFK] #15 Update `manifest.json`, `commands/SKILL.md`, and `CHANGELOG.md` ✓
- [x] [AFK] #16 Sync changes to `~/forge/global/.claude/` and commit ✓

---

## Deferred (pending api.md design decision)

- [ ] [HITL] #2 Review and confirm `api.md` template structure before writing ⏭ Deferred
- [ ] [AFK] #7 Create `~/.claude/knowledge/systems/[name]/api.md` template `blocked-by: #2` ⏭ Deferred
- [ ] [AFK] #10 Extend `/add-system` — scaffold `api.md` alongside existing three files `blocked-by: #7` ⏭ Deferred
- [ ] [AFK] #11 Extend `/summarise-system` — add API ingestion path and multi-source routing `blocked-by: #7` ⏭ Deferred

---

## In Progress

_None_

---

## Backlog

_None — deferred tickets tracked in PRD and HANDOFF._

---

## Done

- [x] [HITL] #1 Review and confirm `style-guide.md` template structure before writing ✓
- [x] [HITL] #3 Review and confirm `/knowledge-onboard` SKILL.md draft before finalising ✓
- [x] [HITL] #4 Review and confirm `/style-check` SKILL.md draft before finalising ✓
- [x] [HITL] #5 Confirm manifest, commands reference, and CHANGELOG updates before push ✓
- [x] [AFK] #6 Create `~/.claude/knowledge/company/style-guide.md` template ✓
- [x] [AFK] #8 Write `/knowledge-onboard` SKILL.md and command file ✓
- [x] [AFK] #9 Write `/style-check` SKILL.md and command file ✓
- [x] [AFK] #12 Extend `/write-article` — consult `style-guide.md` when present ✓
- [x] [AFK] #13 Extend `/write-prd` — consult `style-guide.md` when present ✓
- [x] [AFK] #14 Extend `/knowledge-health` — check `style-guide.md` presence (api.md portion deferred) ✓
- [x] [AFK] #15 Update `manifest.json`, `commands/SKILL.md`, and `CHANGELOG.md` ✓
- [x] [AFK] #16 Sync changes to `~/forge/global/.claude/` and commit ✓

---

## Deferred (pending api.md design decision)

- [ ] [HITL] #2 Review and confirm `api.md` template structure before writing ⏭ Deferred
- [ ] [AFK] #7 Create `~/.claude/knowledge/systems/[name]/api.md` template `blocked-by: #2` ⏭ Deferred
- [ ] [AFK] #10 Extend `/add-system` — scaffold `api.md` alongside existing three files `blocked-by: #7` ⏭ Deferred
- [ ] [AFK] #11 Extend `/summarise-system` — add API ingestion path and multi-source routing `blocked-by: #7` ⏭ Deferred
