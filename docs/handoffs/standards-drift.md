# Handoff: Standards drift — skills checked against the standards they apply

**Stream:** `standards-drift`
**Status:** Active
**Last updated:** 2026-10-09 09:00
**Session type:** Ad Hoc
**Prepared by:** /debrief: merge PR #106, then work the review backlog
**Touches:** `global/.claude/skills/skill-health/`, `global/.claude/skills/review-language/`, `global/.claude/skills/write-{ac,brd,ord,prd,reqs}/`, `global/.claude/skills/write-a-skill/RESERVED-NAMES.md`, `global/.claude/skills/manifest.json`, `global/.claude/CHANGELOG.md`, `plugins/`, `dist/`

---

## Current Ticket

**Ad hoc — standards drift and the review backlog** `[HITL]`
Status: In Progress. PR #106 (v4.21.0 → v4.23.2) is being merged at the close of this session.
**Current phase:** Review backlog — Session 1 of this phase

---

## What Just Happened

`/review-language` gained a `--skill` mode that checks a skill's templates and worked examples, never
its instruction prose. Its runs fixed the requirements skills' templates: `/write-ac`, `/write-ord`,
`/write-prd` (guidance moved out of the template fence) and the `/write-reqs` brief. `/skill-health`
1.8.x now reads a standards register and flags drift. `RESERVED-NAMES.md` was refreshed against
Claude Code 2.1.293. All of it is in PR #106.

Key artifacts updated this session:
- `global/.claude/skills/review-language/SKILL.md` — skill mode
- `global/.claude/skills/skill-health/STANDARDS.md` — new register
- `global/.claude/skills/skill-health/SKILL.md` — drift checks
- `global/.claude/skills/write-prd/SKILL.md` — template notes
- `global/.claude/skills/write-a-skill/RESERVED-NAMES.md` — refreshed

---

## Next Action

Confirm PR #106 merged to `main` (it was merged at the close of this session). Then run
`tools/sync-standalone-skills.sh` to publish 4.23.2, and pull `main` into the main checkout at
`~/Documents/Forge/Forge` so `~/.claude` serves the new skills. That checkout is on
`write-ord-testable-ac`, so check its state first.

---

## Context the Next Session Will Need

- **The review backlog** is the 46 `Applies` declarations with `Reviewed: —` in
  `global/.claude/skills/skill-health/STANDARDS.md`. Start with `tables.md` and `ai.md` against
  the requirements skills. Stamp a row only after the review, and only once the standard's latest
  change is committed (see § *Updating a stamp*).
- **The `rules/common/` `Applies to` lists are a seed.** They list the skills that cite each file
  plus the obvious code-writing and git skills. Review them before trusting the coverage check.
- **The `/skill-health` invoked by name loads a stale copy** while `~/.claude` points at the main
  checkout. Until `main` is pulled there, follow the worktree's `SKILL.md`.
- **Requirements pack items, not in this repo:**
  - The `/write-brd` header carries `BABOK v3` with no expansion and an `FYnn Hn` horizon. Both
    are in the pack's BRD template (`STANDARD.md:226`, worked example at `:672`).
  - `review-ord/CRITERIA.md:872` still has the old ORD-005 wording.
  - The pack's own templates have not had a language pass.
- The worktree at `.claude/worktrees/review-language-skill` can be removed once #106 is merged.

---

## Open Decisions

- Whether `FYnn Hn` horizons stay as a recorded deviation in `language.md` or move to the
  `2026–27` financial-year form. This is the pack owner's call.

---

## Blockers

_None_

---

## Suggested Skills for Next Session

1. `/review-language --skill <name>` — work the `language.md` rows of the backlog: `idea-ai`, `roap`, `testplan`, `review-language`.
2. `/skill-health` — after `main` is pulled into the main checkout, to confirm a clean baseline with publication current.
