> **Archived:** 2026-06-01 — QA passed. Do not reference this document in future sessions.

# PRD: Forge Junction-Based Sync

**Date:** 2026-06-01
**Status:** Active
**Sprint:** Not sprint-tracked
**PI:** Not PI-tracked
**Target Release:** Standalone
**Author:** Forge

**Stakeholder Label:** Cross-device Forge sync via git junctions
**Delivery Type:** Fixed Scope
**Priority:** P2 High
**Due Date (Internal):** None
**Due Date (External):** None
**Estimate (AI Token Cost):** M (20–80k)
**Estimate (Story Points):** 11 pts
**Estimate Status:** Current
**Last estimated:** 2026-06-01

---

## Problem Statement

Forge's install model copies files from the repo into `~/.claude/`. This creates two independent copies of every framework file. When a skill is edited in `~/.claude/` (as happens during normal Forge development), the change does not exist in the repo until manually copied back — causing drift, as happened when `qa-report` was written and the repo had no `.git` history at all.

On multiple devices (Windows PC, Mac, iOS), each `~/.claude/` drifts independently. `/forge-update` closes the gap but only when run — and on Windows, the repo living under OneDrive causes junction/sync conflicts that make the junction-based fix impractical without moving the repo first.

## Solution

Replace the copy-based install with granular junctions (Windows) and symlinks (Mac/Linux) so that `~/.claude/skills/`, `~/.claude/commands/`, and `~/.claude/rules/` point directly into the local `~/forge` clone. Editing a skill file in `~/.claude/` is the same as editing it in the repo. Staying in sync across devices means running `git pull` — no copy step, no drift possible.

iOS cannot use junctions or symlinks but can push changes to a branch via git; those changes are reviewed and merged on Mac or Windows.

## User Stories

1. As a Forge user on Windows, I want to install Forge with junctions so that editing skills in `~/.claude/` automatically updates the repo without a manual copy step.
2. As a Forge user on Mac, I want to install Forge with symlinks so that the same zero-drift behaviour applies on macOS.
3. As an existing Windows user with Forge installed under OneDrive, I want a guided migration that moves the repo to `~/forge` and creates junctions, so that I transition to the new model without losing any user data.
4. As a Forge user on iOS, I want clear guidance on how to contribute skill changes from iOS, so that I can push to a branch and have changes merged on another device.
5. As any Forge user, I want `/forge-update` to simply run `git pull`, so that staying up to date is a single command with no copy step.
6. As a Forge developer, I want edits to `~/.claude/skills/` to be immediately visible in the repo, so that `git status` shows my work and I can commit directly without a copy step.

## Implementation Decisions

- **Junctioned dirs:** `skills/`, `commands/`, `rules/` (directories). Junctioned files: `CHANGELOG.md`, `PRINCIPLES.md`, `SOUL.md`, `forge-sequence.mmd`.
- **User-owned dirs stay real local dirs:** `knowledge/`, `instincts/`, `tokens/`, `backlog/`, `ideas/`, `decisions/`, `projects/`, `preferences.md`, `CLAUDE.md`, `AGENTS.md`. Never junctioned.
- **Windows: `mklink /J`** (junctions — no elevation, no Developer Mode required). Mac/Linux: `ln -s`.
- **Repo canonical path: `~/forge`** (`C:\Users\{user}\forge` on Windows, `~/forge` on Mac). Must not live under OneDrive — junction + OneDrive sync is unreliable.
- **`install.sh` auto-detects platform** via `$OSTYPE` or `uname`. Creates dirs, then junctions/symlinks in place of the copy step.
- **`update.sh` deprecated** — retained in repo with a deprecation notice; no longer called by `/forge-update` or `install.sh`.
- **`/forge-install` auto-detects scenario** — checks whether `~/forge/.git` exists and whether `~/.claude/skills/` is already a junction/symlink. Three branches: fresh install, migration from existing copy-based install, already-linked (no-op).
- **Migration flow** — detects existing repo location (checks `OneDrive/Forge` and other common paths), confirms move to `~/forge`, removes real framework dirs from `~/.claude/`, creates junctions. User data dirs are never touched.
- **iOS branch flow** — `/forge-install` detects iOS (no `mklink` or `ln` available), provides guidance: clone repo to working dir, work normally, push changes to `claude/ios-[slug]` branch, merge on Mac/Windows.
- **Module estimates:** `install.sh` rewrite S/3pts, `update.sh` deprecation S/1pt, `/forge-install` rewrite M/5pts, `/forge-update` simplification S/2pts.

## Task List

### HITL Tasks
- [ ] [HITL] #1 Confirm migration on Windows — review junction creation output and verify `~/.claude/skills/` resolves correctly post-migration

### AFK Tasks
- [ ] [AFK] #2 Rewrite `install.sh` — platform detection, junction/symlink creation, remove copy and backup steps `blocked-by: none`
- [ ] [AFK] #3 Deprecate `update.sh` — add deprecation notice, leave file in repo for backwards compatibility `blocked-by: none`
- [ ] [AFK] #4 Rewrite `/forge-install` skill — auto-detect (fresh/migrate/already-linked), migration flow, iOS guidance branch `blocked-by: none`
- [ ] [AFK] #5 Simplify `/forge-update` skill — replace `update.sh` step with `git pull`, retain version check and CHANGELOG display `blocked-by: none`
- [ ] [HITL] #6 Run migration on Windows machine — execute updated `/forge-install`, confirm junctions resolve, verify skill edits appear in repo `blocked-by: #2, #4`
- [ ] [AFK] #7 Commit and push all changes to `origin/main` `blocked-by: #6`

## Testing Decisions

- Verify `~/.claude/skills/` is a junction/symlink after install, not a real directory (`fsutil reparsepoint query` on Windows, `ls -la` on Mac)
- Verify editing a skill file in `~/.claude/skills/` shows as modified in `git status` in `~/forge`
- Verify user data dirs (`knowledge/`, `instincts/`, etc.) are untouched real directories after migration
- Verify `/forge-update` runs `git pull` and reports version correctly without invoking `update.sh`
- Verify iOS detection branch shows correct guidance (no junction creation attempted)

## Definition of Done

- [ ] All tasks on the kanban board marked complete
- [ ] HITL tasks #1 and #6 signed off by human
- [ ] `~/.claude/skills/` is a junction pointing to `~/forge/global/.claude/skills/` on Windows
- [ ] Editing a skill in `~/.claude/` immediately appears in `git status` without a copy step
- [ ] `/forge-update` no longer references `update.sh`
- [ ] `update.sh` has a deprecation notice at the top
- [ ] README updated to reflect new install model
- [ ] `/approve` issued by human after QA

## Out of Scope

- Windows symlinks (`mklink /D`) — junctions used instead
- Multi-user or shared install scenarios
- iOS git client setup or terminal tooling
- Auto-migration without user confirmation
- Any changes to user-owned dirs or their content

## Further Notes

- Grill session completed 2026-06-01 — all decisions recorded in conversation context.
- Current repo state: `C:\Users\User\OneDrive\Forge` (to be migrated to `C:\Users\User\forge` as part of task #6).
- `decisions/` dir is currently listed in `update.sh` as a framework-owned dir copied on update. Under the junction model it is *not* junctioned (it contains Forge-internal ADRs, not user ADRs) — confirm ownership before task #4.
