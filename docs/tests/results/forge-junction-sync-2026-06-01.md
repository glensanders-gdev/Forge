# QA Report: Forge Junction-Based Sync

**Date:** 2026-06-01
**Feature:** forge-junction-sync
**Tester:** Glen Sanders
**QA Plan:** `docs/qa-plan-forge-junction-sync.md`
**Testplan:** `docs/testplan-forge-junction-sync.md`
**CI run:** n/a — no automated tests
**Screenshots:** n/a

---

## Results

| TC | Behaviour | Priority | Result | Notes |
|----|-----------|----------|--------|-------|
| TC-001 | Windows junction install — ReparsePoint confirmed | P1 | ⏭ Waived | Deferred to future QA cycle. Partially verified during build session migration 2026-06-01 |
| TC-002 | Edit in `~/.claude/skills/` reflects in `git status` | P1 | ⏭ Waived | Deferred to future QA cycle. Verified informally during build session |
| TC-003 | Migration preserves user data dirs | P1 | ⏭ Waived | Deferred to future QA cycle. Migration ran successfully on Windows 2026-06-01 with no data loss reported |
| TC-004 | Migration flow end-to-end — legacy copy → junction | P1 | ⏭ Waived | Deferred to future QA cycle. Migration executed during build session (commit 1993e30) |
| TC-005 | `/forge-update` uses `git pull`, no `update.sh` | P1 | ⏭ Waived | Deferred to future QA cycle |
| TC-006 | iOS guidance branch — no junction attempted | P2 | ⏭ Waived | Deferred — iOS device out of scope |
| TC-007 | Idempotency — re-run `install.sh` → Already linked | P2 | ⏭ Waived | Deferred to future QA cycle |
| TC-008 | Wrong remote guard — stops with warning | P2 | ⏭ Waived | Deferred to future QA cycle |
| TC-009 | `install.sh` failure surfaced — `✗ Failed` visible | P2 | ⏭ Waived | Deferred to future QA cycle |
| TC-010 | `update.sh` deprecation notice at top of file | P2 | ⏭ Waived | Deferred to future QA cycle |

---

## Waived Items

| TC | Reason | Approved By |
|----|--------|-------------|
| TC-001 | Deferred — partially verified during build session migration 2026-06-01 | Glen Sanders |
| TC-002 | Deferred — verified informally during build session | Glen Sanders |
| TC-003 | Deferred — migration ran on Windows with no data loss 2026-06-01 | Glen Sanders |
| TC-004 | Deferred — migration executed during build session (commit 1993e30) | Glen Sanders |
| TC-005 | Deferred to future QA cycle | Glen Sanders |
| TC-006 | iOS device not set up — out of scope for this cycle | Glen Sanders |
| TC-007 | Deferred to future QA cycle | Glen Sanders |
| TC-008 | Deferred to future QA cycle | Glen Sanders |
| TC-009 | Deferred to future QA cycle | Glen Sanders |
| TC-010 | Deferred to future QA cycle | Glen Sanders |

---

## Summary

**Total items:** 10
**Passed:** 0
**Failed:** 0
**Waived:** 10 (all deferred — P1s partially verified during build session)
**Overall result:** ⚠️ Waived — approved for release with deferred formal verification

---

## Approve Gate

**Status: Clear**
Rationale: No unresolved failures. All P1 waivers approved by Glen Sanders. Build-session evidence exists for TC-001–TC-004. Formal QA deferred to a follow-up cycle.
