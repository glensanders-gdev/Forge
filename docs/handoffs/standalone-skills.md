# Handoff: Standalone skills distribution

**Stream:** `standalone-skills`
**Status:** Active
**Last updated:** 2026-08-24 10:27
**Session type:** Framework build
**Prepared by:** /handoff: fix the setup.sh bug too
**Touches:** `global/.claude/skills/`, `global/.claude/commands/`, `dist/forge-standalone/`, `plugins/forge-codex/`, `tools/`, `glensanders-gdev/skills` (public), and the `nbn` company repo (outside Forge)

---

## Current Ticket

**Publish Forge skills as a standalone distribution** `[HITL]`
Status: Shipped — follow-up work outstanding
**Current phase:** Post-merge follow-ups — Session 2 of this phase

Not tracked in `docs/kanban.md`; that board is stale (June 2026, `/check-style` work) and belongs
to a different stream. This is framework work carried on branches and PRs.

---

## What Just Happened

Three pieces, all landed in **PR #63**. `/write-a-skill` now confirms a skill's destination before
anything else — Forge, company, or standalone — with the whole fork fenced `forge-only`. A real
defect in the standalone build was found and fixed: a whole-line `forge-only` fence left behind
the blank line it sat on, which split any markdown table it was a row of, so `/handoff` and
`/standup` were both shipping broken tables to the public repo. And `/skill-health` gained the two
version checks nothing was performing.

Key artifacts updated this session:
- `global/.claude/skills/write-a-skill/SKILL.md` — destination fork (v1.6.0 → 1.7.0)
- `global/.claude/skills/skill-health/SKILL.md` + `FORMATS.md` — two checks (v1.5.0 → 1.6.0)
- `tools/build-forge-standalone.ps1` — two-pass fence strip
- `plugins/forge-codex/skills/write-a-skill/SKILL.md` — company destination added to the override
- `global/.claude/CHANGELOG.md` — v4.6.0 section

---

## Next Action

**Fix `setup.sh` copying company skills into the Forge repo.** Start from a tree synced to PR #63;
the work described above is committed there, not sitting loose.

`~/.claude/companies/<name>/setup.sh` step 3 runs
`cp "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"`, and `~/.claude/skills` is a
symlink to `global/.claude/skills/` in this repository. So installing a company knowledge base
writes into the Forge working tree:

- 11 of the 17 bundled names match live Forge skills — those are **overwritten** with whatever
  stale copy the company repo holds.
- 6 carry pre-rename names (`pii-check`, `style-check`, `company-sync`, `tool-add`, `tool-check`,
  `knowledge-onboard`) and land as new untracked directories with no `standalone:` key, which
  **throws `build-forge-standalone.ps1` for every skill**.

Two places to fix, and they are in different repositories: the template in
`global/.claude/skills/add-company/SKILL.md` (§ `setup.sh` and § Company Skills), and the live
`~/.claude/companies/nbn/setup.sh`. The live nbn copy also still holds the six pre-rename skill
names — reconcile those while there.

`/write-a-skill` step 3 now warns an author that a company skill shares one discovery namespace
with the Forge portfolio. That mitigates the collision; it does not fix the copy target.

---

## Context the Next Session Will Need

**Two sessions' work shipped together in PR #63.** A concurrent session delivered v4.6.1
(accessibility structural constraints become `CON-NNN` rows) touching
`global/.claude/skills/accessibility/SKILL.md`, `prototype/SKILL.md`, `prototype/ui-prototype.md`
and `write-prd/SKILL.md`, bumping `prototype` to 2.1.1 and `write-prd` to 2.7.3, and setting
`forge_version` to 4.6.1. This session's work is under the v4.6.0 CHANGELOG section. Because
`manifest.json` and `CHANGELOG.md` each held both sets of edits, the two could not be split
per-file and one commit carries both releases.

**The `git add -A` warning was right, and it fired.** The other session staged the whole tree while
this one's `build-forge-standalone` was mid-write, producing a commit that recorded 56 `dist/`
paths as deleted while they still existed on disk. It was caught and amended before the push. Stage
by path when a tree is shared, and never stage during a build. Run `git log` before assuming a
branch holds only one session's commits.

**Version ordering is unresolved.** `/skill-health` v1.6.0 was filed under the v4.6.0 CHANGELOG
section after 4.6.1 had already been claimed. No release is tagged, so this is still cosmetic —
but both sections are now committed in PR #63, so splitting the skill-health work into its own
v4.6.2 would mean rewriting that commit rather than restaging. Awaiting a decision.

**The published repo is two releases behind.** Source and `dist/` are at 4.6.1; the public repo is
at 4.4.0 (`ff00307`). `./tools/sync-standalone-skills.sh --push` publishes it, and it refuses to
run while `dist/` is uncommitted — satisfied once PR #63 merges, not before.

**The fence contract.** `<!--forge-only-->…<!--/forge-only-->` *removes* but never *substitutes*.
Since this session's build fix, a fence occupying whole lines takes its trailing newline with it,
so the natural whole-line form is now safe. The end-of-previous-line form used throughout
`/write-a-skill` is safe under both the old and new build.

**`/write-a-skill` fences are unexercised by CI.** The skill is `standalone: false`, so the build
never converts it and never validates its fences. They were verified by simulating the build's
transform in Python. Any future edit to that fork needs the same manual check.

**Frontmatter `description:` cannot be fenced** — a YAML value carries the markers verbatim into
the live skill. Reword instead.

**Codex overrides.** Both touched skills were reviewed this session and hashes refreshed.
`/write-a-skill`'s override gained the company destination; `/skill-health`'s needed nothing — it
audits the installed plugin, not this repository, so neither new check has a counterpart there.

**`/skill-health`'s new checks, run for real, currently report:** published release 4.4.0 against
`dist/` 4.6.1, 65 published skills with no per-skill version (that field shipped in 4.5.0, never
published), and 17 stale skill versions after the portfolio-sweep filter.

---

## Open Decisions

**Three published commit subjects still name Forge.** `ff00307`, `0246fac` and `0c03e6a` in the
public repo read `Sync standalone skills from Forge …`. Fixed for future releases in #61;
correcting the existing three needs a force push over published history. Deliberately not done.

**Whether `/skill-health` v1.6.0 stands as its own v4.6.2** rather than sitting in the v4.6.0
section beneath the concurrent session's v4.6.1. See Context.

**Whether `/write-a-skill` ever ships standalone.** Deferred this session by choice: the
destination fork is fenced and shaped for publication, but the skill stays `standalone: false`.
Shipping it means rewriting or fencing the Forge-only back half — After Writing Files, half the
Review Checklist, the git-tag step, the Codex fence contract. The `standalone:` template line and
its two checklist items are also still unfenced, and are part of that same deferred sweep.

---

## Blockers

_None._

---

## Suggested Skills for Next Session

1. `/write-a-skill` — the `setup.sh` fix edits `/add-company`'s SKILL.md; its own checklist covers
   what that edit must satisfy.
2. `/skill-health` — run it once PR #63 merges, to see the two new checks report against the real
   portfolio rather than only reading correctly.
3. `/standup` — if resuming after a gap; this stream now spans several merged PRs and two
   release sections carried by PR #63.
