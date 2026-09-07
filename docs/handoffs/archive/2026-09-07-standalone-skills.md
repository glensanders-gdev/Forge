# Handoff: Standalone skills distribution

**Stream:** `standalone-skills`
**Status:** Closed
**Last updated:** 2026-09-07 21:10
**Session type:** Stream closed — v4.7.4 published and confirmed
**Prepared by:** /handoff standalone-skills --close
**Touches:** `dist/forge-standalone/`, `.standalone-sync/`, `glensanders-gdev/skills` (public), `global/.claude/`, `tools/`, `.github/workflows/`

---

## Current Ticket

**Publish Forge skills as a standalone distribution** `[HITL]`
Status: **Done.** Published as `9218bfe`, *Release 4.7.4*, 2026-09-07.
**Current phase:** Closed — the stream's purpose is discharged

Not tracked in `docs/kanban.md`; that board is stale (June 2026) and belongs to a different stream.

---

## What Just Happened

**The blocker cleared.** The previous handoff said *"v4.7.0 is not on `main` and is not pushed"* and
named landing it as the next action. It is landed — and four more releases with it.

The session ran in the `requirements-pack` stream and produced three of those releases, then
reviewed all of them before pushing. This stream's paths were written deliberately and with the
collision declared on both registers.

| Release | Commit | What |
|---|---|---|
| v4.7.0 | `15273d1` | `write-ord` converged onto the demand-side ORD standard; new `rules/requirements/reporting.md` |
| v4.7.1 | `1dddc0c` | The `reporting.md` standards anchors verified — all four hold; `AS/NZS ISO/IEC 25012:2013` exists, which `ai.md`'s own rule required be cited |
| v4.7.2 | `55a6eeb` | Review-criteria extracts regenerated against pack v1.11 |
| v4.7.3 | `4764267` | **Five emitted templates still sourced register columns v4.7.0 removed** — found by pre-push review |
| v4.7.4 | `b24efef` | **The Codex plugin, four releases stale** — found by CI, not by review |

**PR [#68](https://github.com/glensanders-gdev/Forge/pull/68) merged as `3c1ceff`.** `origin/main`
and local `main` both carry **v4.7.4**; the branch was retained. `parity` passed in 18s.

**Two of those five releases exist because something was checked rather than read.** v4.7.3 came
from a pre-push review; v4.7.4 came from CI catching what that same review missed — it swept
`global/` and `dist/` and never looked at `plugins/`. **Three generated trees exist —
`dist/`, `plugins/forge-codex/` and the `review-*` extracts — and a review covered two.**

## Outcome — the stream is closed

**Published.** `ff00307..9218bfe`, commit subject *Release 4.7.4*, 2026-09-07, to
`git@github.com:glensanders-gdev/skills.git`.

| | |
|---|---|
| Diff | 25 files, 24 modified, **1 added**, **0 deleted**, +1,427/−713 |
| Version | `4.4.0` → **`4.7.4`** in `manifest.json` and `README.md` |
| Skill count | unchanged at 65 |
| First-time content | `rules/requirements/reporting.md`, and the per-skill `version` field on all 65 skills |

**The `rsync -a --delete` risk did not fire, and that was checked on the staged diff rather than
inferred** — zero deletions. The guard matters again the moment the shipped set changes; it is not
a general clearance.

**Confirmed after the fact by `/skill-health`, read live from `gh`:** published release `4.7.4`
matches `dist/`, 65 skills both sides, all 65 per-skill versions agree, none absent upstream and
none upstream-only. **The publication checks had never run against a real publish before — they
work.** The lag they exist to catch measured 4.4.0 vs 4.7.4 beforehand and is now zero.

**Ten release bumps landed unannotated**, as a bare `Release 4.7.4`. `/changelog` was offered and
not taken. Recorded because it is the one thing about this publish that a future reader of the
public repository cannot reconstruct.

## Context the Next Session Will Need

**Tree state as at this handoff, all verified rather than remembered:**

- `origin/main` = **`3c1ceff`** (merge of PR #68), carries **v4.7.4**. Local `main` fast-forwarded to
  match — the staleness the previous handoff recorded is cleared.
- Branch `claude/prototype-switcher-operability` merged and **retained**, in sync with its remote.
  Working tree clean except the `.gitignore` modification that **predates all of this and is
  deliberately left unstaged.**
- `dist/forge-standalone` builds clean under `-Strict`: 113 source skills → 65 shipped, 48 held,
  **0 dangling references, 0 surviving 'Forge' mentions.** Reproducible — a clean rebuild after
  commit yields no diff. `dist/` is committed, so the sync script's uncommitted-`dist/` refusal will
  not fire.
- `plugins/forge-codex/` regenerated at v4.7.4 and **now carries `reporting.md`**, which shipped in
  v4.7.0 and had never reached it. `test-forge-parity.ps1` passes: 113 shared skills, 114 Claude
  commands, 115 Codex skills.
- `review-*` extracts current against **pack v1.11**, stamped with pack commit `d2f74eca4885`.

**The parity gate is load-bearing and had never fired on this stream before.** It caught the stale
Codex plugin that four releases of review had not. Nothing equivalent guards the `review-*`
extracts — `build-review-criteria.py --check` exists but must be remembered.

**The branch name no longer describes what is on it.** PR #67 already merged the prototype-switcher
work that named it; the branch was then reused for the write-ord convergence. Whoever opens the PR
should title it for v4.7.0, not for the branch.

**The publish path is wired and does not need rebuilding.** `tools/sync-standalone-skills.sh` builds
under `-Strict`, refuses to run on an uncommitted `dist/`, mirrors into a gitignored working clone at
`.standalone-sync/`, and stages. Remote defaults to SSH `git@github.com:glensanders-gdev/skills.git`,
overridable via `FORGE_STANDALONE_REMOTE`. Its commit form is `Release <version>` / `Build <sha>`,
fixed in #61, and does not name Forge.

**CI has three build targets** — `build-forge-codex.ps1`, `test-forge-parity.ps1`, and
`build-forge-standalone.ps1 -Strict`. A version bump alone makes `dist/` stale, because the release
version is stamped into its README and manifest. `CLAUDE.md` Key Commands says so.

**`/skill-health`'s publication checks are still unrun against a fresh publish.** They read the
published manifest via `gh` and compare it to `dist/`. Before the push they should report the lag as
4.4.0 vs whatever is being published; after it, clean. Cheapest available confirmation the publish
worked.

**Three defects in this stream's history were invisible to reading and obvious on execution** — an
`ln -sfn` that linked a repo inside itself, a missing standalone build step, and a staleness check
that could not see the report its own build wrote. Run the thing.

**Two sessions once shared this working tree**, and a `git add -A` fired mid-build committed 56
`dist/` paths as deleted while they existed on disk. If a second session is open, stage by path and
never stage during a build.

---

## Open Decisions at close

**All closed or carried out of the stream. Nothing was dropped.**

| Decision | Disposition |
|---|---|
| Which release publishes first | **Closed** — v4.7.4 published |
| `/skill-health` v1.6.0 versioning | **Carried to backlog** — committed history; age turned it from a decision into a fact |
| Three published commit subjects naming the upstream framework | **Carried to backlog** — `ff00307`, `0246fac`, `0c03e6a`. Fixed for future releases in #61; correcting these needs a force push over published history, deliberately not done |
| Whether `/write-a-skill` ever ships standalone | **Carried to backlog** — deferred by choice; the destination fork is fenced and shaped, the skill stays `standalone: false` |

**Archives are never read on resume**, so the three surviving items were written to
`~/.claude/backlog.md` rather than left here. That is the whole reason this section exists in a
closing handoff.

## Blockers

_None, and none remaining._ The stream's last blocker cleared with PR #68 and the publish followed.

---

## Not Backed Up Anywhere

- `~/.claude/companies/nbn/` at `e7357a2`, clean — **no remote by design.** The company repo must
  never be given one.
- `~/.claude/knowledge/` at `1b1174d`, clean — **now has a remote**
  (`git@github.com:glensanders-gdev/forge-knowledge.git`). The open question recorded in the previous
  handoff, *"no remote by default, not by design"*, is answered.
- `requirements-documents/` has no remote and is 13 commits deep, now at pack **v1.11**.
  **The extracts' provenance stamp names a commit no one else can resolve** — a consequence of the
  no-remote arrangement, made visible by the publish. Tracked by the `requirements-pack`
  stream in the workspace register, not this one.

---

## Suggested Skills for Next Session

1. `/skill-health` — run it **before** the publish to capture the lag, and again after to confirm it
   cleared. Its publication checks exist for exactly this moment and have never been run against a
   fresh publish.
2. `/changelog` — if the publish should carry release notes into the public repo rather than landing
   as a bare `Release 4.7.4`. **Ten release bumps** is a lot to land unannotated, and five of them
   changed how the requirements skills behave.
3. `/standup` — only if resuming after a gap; this stream now spans PRs #59–#67 and six release
   sections.
