# Handoff: AI as the subject of a requirement

**Stream:** `ai-requirements`
**Status:** Blocked
**Last updated:** 2026-08-22 12:05
**Session type:** Ad Hoc (requirements ruleset)
**Prepared by:** /handoff (row opened from the `skill-naming` session — this stream's own work was done in an earlier session)
**Touches:** `global/.claude/rules/requirements/ai.md`, `global/.claude/CHANGELOG.md`, `README.md`, `global/.claude/skills/manifest.json`

---

## Current Ticket

No kanban ticket — ad-hoc. Work is complete on a **local, unpushed branch**:
`claude/ai-requirements-ruleset` at `4135b73`.

---

## What Just Happened

The ruleset itself is finished — `rules/requirements/ai.md`, the evaluative criterion form,
`EVL-NNN` / `MDL-NNN`, ADR-0002, and citations from `/write-prd`, `/write-ord`, `/write-ac`,
`/write-reqs`, `/write-brd`.

It was rebased once during the 2026-08-22 session so it sits on top of the merged multi-stream work,
and its release was renumbered 3.23.0 → 3.25.0 at that point. **That renumber is now stale**: 3.25.0
shipped as the skill renames, so this branch needs 3.26.0.

---

## Next Action

Rebase `claude/ai-requirements-ruleset` onto current `main` (`847afb0`), renumber the release
3.25.0 → **3.26.0**, then push and open a PR.

---

## Context the Next Session Will Need

- Expect conflicts in `global/.claude/CHANGELOG.md`, `global/.claude/skills/manifest.json`,
  `README.md`, and four generated `plugins/forge-codex/` files. Resolve the generated ones by running
  `tools/build-forge-codex.ps1` rather than by hand.
- `README.md` will conflict specifically: v3.25.0 already corrected the title and Skill Versioning
  line, which this branch also edits as part of its version-drift fix. Take the higher version.
- The commit message says "forge_version 3.24.0 -> 3.25.0" and needs the same correction to 3.26.0.
- Pre-rebase SHA before the first rebase was `3ef2ce5`, if the original ordering is ever needed.
- After any rebase: `tools/build-forge-codex.ps1` then `tools/test-forge-parity.ps1` must both pass
  before pushing — CI runs the same two.

---

## Open Decisions

_None._ The content is settled; only the rebase and renumber remain.

---

## Blockers

Blocked on nothing external — it is parked behind the `skill-naming` stream by choice. Every release
that lands on `main` first makes this rebase slightly larger.

---

## Suggested Skills for Next Session

1. `/pickup ai-requirements` — resume this stream when the naming work is done
