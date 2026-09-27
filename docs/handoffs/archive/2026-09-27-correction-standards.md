# Handoff: Corrections become coding standards

**Stream:** `correction-standards`
**Status:** Closed — opened and closed at `/debrief` 2026-09-27, work complete
**Last updated:** 2026-09-27 10:34
**Session type:** Ad Hoc
**Prepared by:** /debrief
**Touches:** `global/.claude/` · `project-template/` · `dist/forge-standalone/` · `plugins/forge-codex/`

---

## Current Ticket

**No kanban ticket** — ad-hoc framework change from a user question ("does Forge use a coding-standards
file, and can Claude update it when it makes mistakes?").
Status: Complete — both releases merged and published.

---

## What Just Happened

Shipped two releases. **v4.14.0** ([PR #86](https://github.com/glensanders-gdev/Forge/pull/86), `624fa18`):
`/push-standards --correction` writes a standard the moment a meaningful mistake is corrected — write,
then tell — with hooks from `/diagnose` and `/review-diff`, and a *Corrections Become Standards*
section in the project template. **v4.15.0** ([PR #87](https://github.com/glensanders-gdev/Forge/pull/87),
`6e7c6e2`): `/learn` ships standalone; its instinct and registry templates moved into
`skills/learn/` because no installer ever seeded `~/.claude/instincts/`. Both published to
`glensanders-gdev/skills`.

Key artifacts updated this session:
- `global/.claude/skills/push-standards/SKILL.md` — correction mode
- `global/.claude/skills/learn/` — templates, standalone
- `project-template/CLAUDE.md` — new section

The section was also copied into four projects and pushed to their `main`: Capacity Report
(`a750c22`), Indoor Cricket Team Manager (`724a05a`, carrying a pending Knowledge References edit),
FFTCG Simulator (`f879c1e`) and Lilydale Bowmen (`d4eecc5`). The last two had no standards file, so
each gained `.claude/CODING-STANDARDS.md` and a load-before-code line; Lilydale's `.gitignore` now
ignores `.claude/*` except that file.

---

## Next Action

None — stream closed. The open question is behavioural: whether corrections are actually captured
in practice. Check the four projects' `.claude/CODING-STANDARDS.md` after a few build sessions; an
empty file after real corrections means the `CLAUDE.md` rule is not firing.

---

## Context the Next Session Will Need

- The CI parity workflow also runs `build-forge-standalone.ps1 -Strict`: a shipped skill naming a
  held skill fails it. Fence with `<!--forge-only-->` or ship the target.
- GitHub auto-merge is unavailable on the Forge repo (no required checks) — merge after CI by hand.

---

## Open Decisions

_None_

---

## Blockers

_None_

---

## Suggested Skills for Next Session

1. `/pickup` — the workspace stream `requirements-pack` is the only open stream.
