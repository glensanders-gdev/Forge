# Handoff: Forge Framework

**Last updated:** 2026-05-29
**Session type:** Framework Maintenance — Branch Sync + Unique Work Rescue
**Prepared by:** /handoff

---

## Current State

Branch: `claude/forge-learning-on-go-STAq0`
Framework version: `3.4.0` (branch base = main at v3.4.0)
3 commits ahead of `origin/main` — pushed and clean.

---

## What Was Done This Session

The branch was discovered to be stale (v2.7.0 base vs main at v3.4.0) with unique work
that hadn't landed. Performed a controlled rescue:

1. **Diagnosed the discrepancy** — branch was built on v2.5.6, had 10 stale commits
   reaching v2.7.0; `origin/main` had advanced to v3.4.0 independently (7 major versions ahead)
2. **Diffed unique content** — identified things not in main: `/forge-init`, `/forge-update`,
   `/ingest` scope prompt enhancement, `/context-health` Intent Layer extension, and `category:`
   frontmatter fields on all skills
3. **Reset branch to `origin/main`** (v3.4.0) — discarded 10 stale commits
4. **Ported unique work** as 3 clean commits:
   - `/forge-init` + `/forge-update` skills added to manifest
   - `/ingest` structured scope prompt + `/context-health` child node recommendations
   - `category:` field added to all 92 skill frontmatters
5. **Force-pushed** branch to remote — clean at v3.4.0 + 3 commits

Key artifacts updated:
- `global/.claude/skills/forge-init/SKILL.md` — new skill (ported)
- `global/.claude/skills/forge-update/SKILL.md` — new skill (ported)
- `global/.claude/commands/forge-init.md` — new command stub
- `global/.claude/commands/forge-update.md` — new command stub
- `global/.claude/skills/manifest.json` — forge-init and forge-update added at v1.0.0
- `global/.claude/skills/ingest/SKILL.md` — structured scope prompt replacing open-ended question
- `global/.claude/skills/context-health/SKILL.md` — Intent Layer child node scan added
- All 92 `*/SKILL.md` frontmatters — `category:` field added

---

## Next Action

Raise a PR from `claude/forge-learning-on-go-STAq0` into `main` to land the 3 commits,
or run `/user:changelog` first to record the ported skills as a v3.5.0 entry.

---

## Context the Next Session Will Need

- The **company-setup rename** (company-add → company-setup) from the original stale branch
  was intentionally NOT ported. The migration-support and repo-config enhancements could still
  be worth porting as incremental improvements to `company-add` if desired.
- The **Codex compatibility scaffold** (`compatibility:` frontmatter + `## Agent Notes` sections)
  was not ported — tightly coupled to the rename. Needs a fresh pass if Codex support is a goal.
- `caveman` was assigned `category: session` (corrected from the original branch's `metrics`
  assignment, which didn't match the README grouping).

---

## Open Decisions

- **Deferred knowledge-onboard tickets** (#2, #7, #10, #11): Still pending `api.md` template
  design decision. Low urgency — feature shipped in v2.5.6.
- **Codex compatibility**: Whether to proceed with `compatibility:` frontmatter and Codex-specific
  `## Agent Notes` sections across all skills.

---

## Blockers

_None_

---

## Suggested Skills for Next Session

1. `/user:changelog` — record the 3 ported commits as v3.5.0 before raising the PR
2. `/user:critic` — fresh critic pass on the ported skills (forge-init, forge-update)
   against v3.4.0 conventions
