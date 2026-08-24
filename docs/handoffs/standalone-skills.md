# Handoff: Standalone skills distribution

**Stream:** `standalone-skills`
**Status:** Active
**Last updated:** 2026-08-24 09:44
**Session type:** Framework build
**Prepared by:** /handoff: add the version bump check too
**Touches:** `global/.claude/skills/`, `global/.claude/rules/`, `dist/forge-standalone/`, `tools/`, `.github/workflows/`, `glensanders-gdev/skills` (public)

---

## Current Ticket

**Publish Forge skills as a standalone distribution** `[HITL]`
Status: Shipped — follow-up work outstanding
**Current phase:** Post-merge follow-ups — Session 1 of this phase

Not tracked in `docs/kanban.md`; that board is stale (June 2026, `/check-style` work) and belongs
to a different stream. This is framework work carried on branches and PRs.

---

## What Just Happened

Built a third build target off `global/.claude/skills/` that publishes 65 of 113 skills to
`github.com/glensanders-gdev/skills`, selected by a mandatory `standalone:` frontmatter key.
Scrubbed every reference to Forge from the published tree and added a build guard so it cannot
regress. Then made the distribution visible to the skills that maintain it — per-skill versions in
the published manifest, a `/skill-health` audit, and a `/write-a-skill` authoring step.

Key artifacts:
- `tools/build-forge-standalone.ps1` — new build target
- `tools/sync-standalone-skills.sh` — publish step, refuses to run on uncommitted `dist/`
- `.github/workflows/forge-parity.yml` — `-Strict` build + staleness check
- `.gitattributes` — `dist/** text eol=lf`
- `CLAUDE.md` — documents the target and the fence contract
- All 113 `SKILL.md` files — `standalone:` key added

PRs #59, #60, #61, #62 all merged. `main` at `badb6ec`, Forge 4.5.0.

---

## Next Action

**Add the version-bump check to `/skill-health`.** Nothing currently enforces that editing a skill
bumps its version in `manifest.json`. Parity checks that the Forge and Codex manifests agree with
*each other*, not that an edited skill was bumped at all. That gap predates this stream but now
matters more, because the per-skill version is published to a public manifest — a stale version
number is a claim to strangers that nothing changed.

Implementation: compare each skill's last-modified commit against the commit that last changed its
`manifest.json` entry. If the skill is newer, the version is stale. Amber, not Critical — it is a
hygiene failure, not a broken build. Add to the checks table, the Phase 2 tallies, and `FORMATS.md`
in `global/.claude/skills/skill-health/`, matching the shape of the standalone checks added in
v4.5.0.

Then bump `/skill-health` to 1.6.0 and Forge to 4.6.0.

---

## Context the Next Session Will Need

**The published repo is one release behind.** Source and `dist/` are at 4.5.0; the public repo is
still at 4.4.0 (`ff00307`). Run `./tools/sync-standalone-skills.sh --push` to publish — this is
independent of the version-bump check and can go first.

**Concurrent sessions.** Another session worked this repository throughout 2026-08-24 and its
`git add -A` twice swept in this session's in-flight edits. Nothing was lost, but check
`git log` before assuming a branch contains only your own commits.

**The fence contract.** `<!--forge-only-->…<!--/forge-only-->` *removes* but never *substitutes* —
Forge and Codex read the fenced span as ordinary text, so a sentence must read correctly with and
without it. Put the joining punctuation inside the fence. This was got wrong twice while building.
Documented in `CLAUDE.md` § Standalone skills distribution.

**Frontmatter `description:` cannot be fenced** — a YAML value carries the markers verbatim into the
live skill. Reword the description instead.

**Codex overrides.** Any shared-source change trips all 17 override-review flags. Review whether
the Codex-native copy genuinely needs the change (usually not — they are independently authored),
then `tools/update-forge-codex-overrides.ps1 -ConfirmReview`.

**Advisory worklist.** `dist/forge-standalone-BUILD-REPORT.md` is generated each build. Dangling
references are 0 and enforced; the `Forge` mention list is now also 0 and guarded.

---

## Open Decisions

**Three published commit subjects still name Forge.** `ff00307`, `0246fac` and `0c03e6a` in the
public repo read `Sync standalone skills from Forge …`. Fixed for future releases in #61; correcting
the existing three needs a force push over published history. Deliberately not done — awaiting a
decision. The repo is young and probably unforked, so the practical risk is low.

---

## Blockers

_None._

---

## Suggested Skills for Next Session

1. `/write-a-skill` — the version-bump check is an edit to `/skill-health`; its own checklist now
   covers the `standalone:` and section requirements the edit must satisfy.
2. `/skill-health` — run it once the check is added, to confirm it reports against the real
   portfolio rather than only reading correctly.
3. `/standup` — if resuming after a gap; this stream spans several merged PRs.
