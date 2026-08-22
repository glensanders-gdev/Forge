# Handoff: Skill naming — collision policy and verb-first convention

**Stream:** `skill-naming`
**Status:** Active
**Last updated:** 2026-08-22 12:05
**Session type:** Ad Hoc (framework — session state, then skill naming)
**Prepared by:** /handoff: next session adds the name-collision policy to `/write-a-skill` and `/skill-health`, and establishes a verb-first action-task naming convention
**Touches:** `global/.claude/skills/write-a-skill/`, `global/.claude/skills/skill-health/`, `global/.claude/skills/manifest.json`

---

## Current Ticket

No kanban ticket — framework work is ad-hoc and backlog-driven (`docs/kanban.md` board archived 2026-06-01).
**Current phase:** Framework maintenance — session 1 of this stream

---

## What Just Happened

Two releases shipped and merged to `main`. Session state stopped being a single file, then two skill
names that Claude Code built-ins were shadowing were renamed.

- **v3.24.0** ([PR #46](https://github.com/glensanders-gdev/Forge/pull/46) → `1b18d77`) — one handoff
  per stream of work. `docs/HANDOFF.md` is now a register of pointer rows; each stream's live handoff
  is `docs/handoffs/<slug>.md`. Spec in `global/.claude/skills/handoff/STREAMS.md`; `/handoff`,
  `/pickup`, `/save-state`, `/debrief` at 2.0.0, `/approve` 1.2.0, `/sprint-end` 1.1.0,
  `/context-health` 1.2.0.
- **v3.25.0** ([PR #47](https://github.com/glensanders-gdev/Forge/pull/47) → `847afb0`) —
  `/continue` → `/pickup`, `/review` → `/diff-review`, both at 3.0.0. A built-in wins the name, and a
  deprecation stub is not available as a mitigation because the stub would be shadowed too.

This file is the first product of the migration it describes: the stale 2026-06-19 legacy handoff is
at `docs/handoffs/archive/2026-06-19-forge-framework.md`.

Key artifacts:
- `global/.claude/skills/handoff/STREAMS.md` — new, the shared stream spec
- `global/.claude/CHANGELOG.md` — v3.24.0 and v3.25.0 entries carry the full reasoning

---

## Next Action

Add the name-collision check to `/write-a-skill` — a proposed skill name is checked against Claude
Code's built-in and bundled command names before the skill is scaffolded — then add the matching
audit to `/skill-health` so collisions that appear later, as the vendor namespace grows, are caught
rather than discovered in use.

Then establish the verb-first action-task naming convention (`brd-review` → `review-brd`) and decide
how far it applies retrospectively.

---

## Context the Next Session Will Need

- **The built-in list cannot be enumerated programmatically.** Whatever `/skill-health` checks against
  is a hand-maintained list that will drift. Decide where it lives — inside the skill, or a reference
  file stamped "last verified against Claude Code version X". The second is more honest about
  staleness and was the open recommendation.
- **Only 2 of 113 names collided** when checked this session. `/build`, `/deploy`, `/publish` and
  `/research` are the generic names most likely to go the same way.
- **Renaming has no soft landing.** The old name stops working the moment a built-in claims it; there
  is no stub, alias, or deprecation path. That is what makes the authoring-time check worth building.
- A rename is a **major** skill version — every reference breaks. Both renamed skills went to 3.0.0.
- Historical CHANGELOG and README version-history rows were deliberately **not** rewritten during the
  renames. Keep that rule if the verb-first convention triggers more renames.

---

## Open Decisions

1. **`/diff-review` contradicts the verb-first convention it precedes.** Under `review-brd` /
   `review-ord`, the skill renamed this session would be `review-diff`. Decide whether the convention
   forces a second rename of a name that is one release old, or whether `diff-review` is grandfathered.
   The same question applies to `security-review`, `performance-review`, `fy-review`, `brd-review`,
   `ord-review` and `code-review` — seven names, one convention.
2. **How far the convention reaches.** Verb-first is natural for action skills (`review-brd`,
   `write-prd`) and awkward for state skills (`standup`, `commands`, `caveman`, `pickup`). Decide the
   boundary before renaming anything, or the convention will be applied inconsistently and then
   argued about per-skill.
3. **Whether the collision check blocks or warns** in `/write-a-skill`. A block is safer; a warning
   respects that the built-in list is stale by construction.

---

## Blockers

_None._

---

## Suggested Skills for Next Session

1. `/pickup skill-naming` — resume this stream (note the new name; `/continue` now runs the Claude
   Code built-in)
2. `/write-a-skill` — the collision policy lands in it, and it is the skill that governs how the
   convention is documented for future skills
3. `/write-adr` — the verb-first convention is a hard-to-reverse decision across 113 skill names and
   warrants an ADR rather than a changelog line
