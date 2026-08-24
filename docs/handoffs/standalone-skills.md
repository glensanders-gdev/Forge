# Handoff: Standalone skills distribution

**Stream:** `standalone-skills`
**Status:** Active
**Last updated:** 2026-08-24 11:00
**Session type:** Framework build
**Prepared by:** /handoff: publish the standalone repo in the next session
**Touches:** `dist/forge-standalone/`, `.standalone-sync/`, `glensanders-gdev/skills` (public), `global/.claude/`, `tools/`, `.github/workflows/`

---

## Current Ticket

**Publish Forge skills as a standalone distribution** `[HITL]`
Status: Shipped — publish step outstanding
**Current phase:** Post-merge follow-ups — Session 3 of this phase

Not tracked in `docs/kanban.md`; that board is stale (June 2026, `/check-style` work) and belongs
to a different stream. This is framework work carried on branches and PRs.

---

## What Just Happened

Three PRs merged. **#63** landed two releases at once (v4.6.0 from a concurrent session, v4.6.1
prototype accessibility) plus this stream's last handoff. **#64** closed the previous Next Action —
the `setup.sh` bug — and documented the third build target in `CLAUDE.md`. **#65** closed a CI gap
that surfaced while fixing #64.

`main` is at `e305962`, Forge **4.6.2**, working tree clean, in sync with origin.

Key artifacts updated this session:
- `global/.claude/skills/add-company/SKILL.md` — symlink guard, in-place link guard, rename rule (v2.0.0 → 2.1.0)
- `CLAUDE.md` — three build targets in Key Commands; CI list 2 entries → 4
- `.github/workflows/forge-parity.yml` — staleness check scoped to `dist/`, not `dist/forge-standalone/`
- `~/.claude/companies/nbn/` — `setup.sh` fixed, 6 skills renamed, all 17 re-bundled (`e7357a2`, local-only)

---

## Next Action

**Publish 4.6.2 to `glensanders-gdev/skills`.** The public repo is at **4.4.0** (`ff00307`) — three
release bumps behind. The `dist/`-must-be-committed precondition that blocked this is now satisfied.

```bash
./tools/sync-standalone-skills.sh          # rebuilds, mirrors, stages, stops
```

It never pushes on its own. Read the staged diff, then:

```bash
./tools/sync-standalone-skills.sh --push
```

Expect a large diff — three releases of accumulated change, including the per-skill `version` field
that shipped in 4.5.0 and has never been published. **Read it before pushing**: the mirror runs
`rsync -a --delete`, so a skill dropped from the shipped set disappears upstream, and that is the
one thing this script does that cannot be undone by the next release.

---

## Context the Next Session Will Need

**The publish path is already wired and does not need rebuilding.** `tools/sync-standalone-skills.sh`
rebuilds under `-Strict`, refuses to run while `dist/forge-standalone` is uncommitted, mirrors into
a working clone at `.standalone-sync/` (gitignored, currently at `ff00307`), and stages. Remote
defaults to SSH `git@github.com:glensanders-gdev/skills.git`, overridable via
`FORGE_STANDALONE_REMOTE`. The commit it writes is `Release <version>` / `Build <sha>` — that form
was fixed in #61 and does not name Forge.

**CI has three build targets, and this was learned the hard way.** `build-forge-codex.ps1`,
`test-forge-parity.ps1`, and `build-forge-standalone.ps1 -Strict`. A version bump alone makes
`dist/` stale, because the release version is stamped into its README and manifest. `CLAUDE.md`
Key Commands now says so; before #64 it named only the first two, and following it was enough to
fail CI.

**Three defects this session were invisible to reading and obvious on execution** — an `ln -sfn`
that linked a repo inside itself, the missing standalone build step, and a staleness check that
could not see the report its own build wrote. Run the thing.

**Two sessions shared this working tree earlier today.** One `git add -A` fired mid-build and
committed 56 `dist/` paths as deleted while they existed on disk; caught and amended before the
push. If a second session is open, stage by path and never stage during a build.

**`/skill-health`'s publication checks are now live and unrun against a fresh publish.** They read
the published manifest via `gh` and compare it to `dist/`. Before the push they should report
publication lag 4.4.0 vs 4.6.2 and 65 skills with no per-skill version; after it, clean. That is
the cheapest confirmation the publish worked.

---

## Open Decisions

**Whether `/skill-health` v1.6.0 stands as its own v4.6.2** rather than sitting in the v4.6.0
CHANGELOG section beneath the concurrent session's v4.6.1. No release is tagged, so this is still
cosmetic — but it is committed history now, so changing it means rewriting a merged commit rather
than restaging. Note that 4.6.2 has since been used for the `setup.sh` fix.

**Three published commit subjects still name Forge.** `ff00307`, `0246fac` and `0c03e6a` in the
public repo read `Sync standalone skills from Forge …`. Fixed for future releases in #61; correcting
the existing three needs a force push over published history. Deliberately not done.

**Whether `/write-a-skill` ever ships standalone.** Deferred by choice: the destination fork is
fenced and shaped for publication, but the skill stays `standalone: false`. Shipping it means
rewriting or fencing the Forge-only back half.

**`review-ord` extract differs from pack v1.9.** Pre-existing and unrelated to this stream — the
extract is unmodified in the tree, so `main` reports the same. `python3 tools/build-review-criteria.py`
regenerates it, which pulls in pack changes nobody has reviewed. Only visible to whoever holds the
local `requirements-documents` pack.

---

## Blockers

_None._ The precondition that blocked publishing is satisfied.

---

## Not Backed Up Anywhere

Two local-only git repositories hold work from this session and have no remote:

- `~/.claude/companies/nbn/` at `e7357a2` — the `setup.sh` fix and re-bundled skills. No remote **by
  design**; the company repo must never be given one.
- `~/.claude/knowledge/` at `d94ffba` — initialised this session. Holds the company glossary and
  `docs/research/australian-accessibility-standards-for-ui.md`. No remote **by default, not by
  design** — a decision nobody has made yet.

---

## Suggested Skills for Next Session

1. `/standup` — if resuming after a gap; this stream now spans PRs #59–#65 and four release sections.
2. `/skill-health` — run it *before* the publish to capture the lag, and again after to confirm it
   cleared. Its publication checks exist for exactly this moment and have never been run against a
   fresh publish.
3. `/changelog` — if the publish should carry release notes to the public repo rather than landing
   as a bare `Release 4.6.2`.
