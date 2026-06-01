# Test Plan: Forge Junction-Based Sync

**PRD:** `docs/prd/active/forge-junction-sync.md`
**Date:** 2026-06-01
**Sprint:** Standalone
**TC range:** TC-001 through TC-010

---

## Critical Path Behaviours

Behaviours that must pass at Go/No Go:

1. **TC-001** — Junction created at `~/.claude/skills/` on Windows — core install contract
2. **TC-002** — Skill edit in `~/.claude/` immediately visible in `git status` — the entire point of the feature
3. **TC-003** — Migration preserves user data dirs — data loss risk

---

## Automated Tests

None. Forge has no test runner for shell scripts or skill markdown files. All verification is manual.

### Not Automated — Reasons

| Item | Reason |
|------|--------|
| `install.sh` junction creation | No shell test framework in project; requires live filesystem with junction support |
| `/forge-install` scenario detection | Skill logic is markdown — no executable under test |
| `update.sh` deprecation | Static file check — covered in manual pass |

---

## Manual Tests

| TC | Behaviour | Steps | Expected Outcome | Priority |
|----|-----------|-------|-----------------|----------|
| TC-001 | Windows junction install | Run `bash ~/forge/install.sh`; check `(Get-Item ~\.claude\skills -Force).Attributes` | Output includes `ReparsePoint` | P1 |
| TC-002 | Edit reflects in `git status` | Edit any SKILL.md via `~/.claude/skills/`; run `git status` in `~/forge` | File shows as `M` — no copy step | P1 |
| TC-003 | Migration preserves user data | Run migration via `/forge-install`; check `knowledge/`, `instincts/`, `tokens/`, `preferences.md` | All user dirs and files intact with original content | P1 |
| TC-004 | Migration flow end-to-end | From legacy copy-based install, run `/forge-install`; confirm it detects legacy, presents migration plan, creates junctions on MIGRATE | `~/.claude/skills/` becomes junction; user data untouched | P1 |
| TC-005 | `/forge-update` uses git pull | Run `/forge-update`; observe output | `git pull` executed; `update.sh` not mentioned or invoked | P1 |
| TC-006 | iOS guidance branch | Run `/forge-install` in environment without `ln`/`mklink` | iOS guidance displayed; no junction creation attempted | P2 |
| TC-007 | Idempotency — re-run `install.sh` | Run `install.sh` a second time on already-linked machine | All dirs report `↩ Already linked`; no error | P2 |
| TC-008 | Wrong remote guard | With `~/forge` pointing to a different remote, run `/forge-install` | Error naming wrong remote; no filesystem changes | P2 |
| TC-009 | `install.sh` failure surfaced | Lock a file inside `~/.claude/skills/` and run `install.sh` | `✗ Failed to create junction` visible; script does not exit silently | P2 |
| TC-010 | `update.sh` deprecation notice | Open `update.sh` | First comment block states file is deprecated; directs to `git pull` / `/forge-update` | P2 |

---

## Not Tested

| Item | Reason |
|------|--------|
| Mac symlink install | Deferred — Mac device not yet set up |
| iOS git workflow end-to-end | iOS terminal setup out of scope per PRD |
| Multi-user / shared install | Out of scope per PRD |
| Windows symlinks (`mklink /D`) | Junctions used instead — per PRD decision |

---

## Definition of Test Complete

- [ ] All P1 manual tests (TC-001–TC-005) verified by human
- [ ] P2 tests TC-006–TC-010 verified or waived with reason
- [ ] No known P1 issues outstanding
