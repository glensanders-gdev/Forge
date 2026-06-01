# QA Plan: Forge Junction-Based Sync

**Date:** 2026-06-01
**Feature:** forge-junction-sync — `docs/prd/active/forge-junction-sync.md`
**Tester:** Glen Sanders
**TC range:** No testplan exists for this feature — items sourced directly from PRD Testing Decisions and user stories.

---

## Pre-QA Checks

- [ ] All kanban tickets marked Done (#1–#7)
- [ ] No known blockers outstanding
- [ ] Git Bash available on Windows for running install.sh

---

## Known Issues to Verify

_None — no `docs/known-issues.md` found for this project._

---

## User Story Verification

- [ ] **Story 1 — Windows junction install:** After running `bash ~/forge/install.sh`, confirm `~/.claude/skills/` is a junction (not a real directory).
  - Run: `powershell -Command "(Get-Item ~\.claude\skills -Force).Attributes"`
  - Expected: output includes `ReparsePoint`

- [ ] **Story 1 (smoke test) — Edit reflects in repo:** Edit any skill file via `~/.claude/skills/` (e.g. add a blank line to any SKILL.md), then run `git status` in `~/forge`.
  - Expected: modified file appears in `git status` with no copy step

- [ ] **Story 3 — Migration flow:** From a fresh machine (or test scenario), confirm `/forge-install` detects a legacy copy-based install, presents the migration plan, and on MIGRATE creates junctions correctly.
  - Expected: `~/.claude/skills/` becomes a junction; user data dirs (`knowledge/`, `instincts/`, etc.) are untouched real directories

- [ ] **Story 4 — iOS guidance:** In a Claude Code session, run `/forge-install` in an environment without `ln`. Confirm iOS guidance branch appears.
  - Expected: message explains PR-only branch workflow; no junction creation attempted

- [ ] **Story 5 — /forge-update uses git pull:** Run `/forge-update`. Confirm it runs `git pull` and does NOT invoke `update.sh`.
  - Expected: version check shown, pull executed, `update.sh` not mentioned in output

- [ ] **Story 6 — git status reflects edits:** Edit a skill file directly in `~/.claude/skills/[skill]/SKILL.md`, check `git status` in the repo.
  - Expected: file shows as `M` (modified) immediately, no manual sync needed

---

## Edge Cases

- [ ] **Idempotency — re-run install.sh when already linked:** Run `bash ~/forge/install.sh` a second time on a machine where junctions are already in place.
  - Expected: all dirs report `↩ Already linked` — no error, no re-creation

- [ ] **User data preserved — migration:** After running the migration, confirm `~/.claude/knowledge/`, `~/.claude/instincts/`, `~/.claude/tokens/`, `~/.claude/preferences.md` are untouched.
  - Expected: all user data dirs exist and contain their original content

- [ ] **Wrong remote guard:** If `~/forge` exists but points to a different remote, confirm `/forge-install` stops with a warning rather than proceeding.
  - Expected: error message naming the wrong remote; no file system changes made

---

## Error States

- [ ] **install.sh failure — target in use:** If a file inside `~/.claude/skills/` is locked (e.g. open in an editor), confirm the installer surfaces an error rather than silently failing.
  - Expected: PowerShell error output visible; `✗ Failed to create junction` message printed; script does not exit with a silent success

- [ ] **update.sh deprecation notice visible:** Open `update.sh` and confirm the deprecation notice is at the top of the file.
  - Expected: first comment block clearly states the file is deprecated and directs users to `git pull` / `/forge-update`

---

## Definition of Done

- [ ] All kanban tickets #1–#7 marked complete
- [ ] HITL tasks #1 and #6 signed off
- [ ] `~/.claude/skills/`, `~/.claude/commands/`, `~/.claude/rules/` are junctions on Windows (ReparsePoint attribute confirmed)
- [ ] Editing a skill in `~/.claude/` immediately appears in `git status` without a copy step
- [ ] `/forge-update` skill no longer references `update.sh`
- [ ] `update.sh` has a deprecation notice at the top
- [ ] README updated to reflect new install model (noted as open item — not yet done)

---

## Sign-Off

- [ ] All items above checked
- [ ] No regressions in existing Forge skills or commands
- [ ] Ready to run `/user:qa-report`

**Tested by:** _______________  **Date:** _______________

---

## QA Results

*Completed by human during QA. Fill in as each item is tested.*

| # | Test Item | Result | Notes |
|---|-----------|--------|-------|
| 1 | Windows junction install | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 2 | Edit reflects in repo (smoke test) | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 3 | Migration flow | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 4 | iOS guidance branch | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 5 | /forge-update uses git pull | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 6 | git status reflects edits | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 7 | Idempotency — re-run install.sh | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 8 | User data preserved after migration | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 9 | Wrong remote guard | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 10 | install.sh failure surfaced | ✅ Pass / ❌ Fail / ⚠️ Waived | |
| 11 | update.sh deprecation notice | ✅ Pass / ❌ Fail / ⚠️ Waived | |

### Failed Items
| # | Test Item | Failure Detail | Resolution |
|---|-----------|---------------|------------|
| | | | Fixed / Deferred / Waived |

### Waived Items
| # | Test Item | Reason for Waiver | Approved By |
|---|-----------|------------------|-------------|
| | | | |

### QA Summary
**Total items:** 11
**Passed:** 
**Failed:** 
**Waived:** 
**Overall result:** 
