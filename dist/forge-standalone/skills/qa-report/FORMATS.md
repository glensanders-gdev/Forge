# QA Report — Output Format

## File: `docs/tests/results/[feature-name]-YYYY-MM-DD.md`

```markdown
# QA Report: [Feature Name]

**Date:** YYYY-MM-DD
**Feature:** [PRD name]
**Tester:** [Human name]
**QA Plan:** docs/qa-plan-[feature].md
**TC range:** TC-NNN through TC-NNN

---

## Evidence

| Item | Value |
|------|-------|
| CI run | [link or "N/A — no automated tests"] |
| Test output file | [path or "Not provided — automated evidence unverified"] |
| Screenshot folder | [path or "N/A — manual tests only"] |

---

## Results

### Automated Tests

| TC | Behaviour | Priority | Result | Evidence |
|----|-----------|----------|--------|----------|
| TC-NNN | [behaviour] | P1 | ✅ Pass / ❌ Fail / ⚠️ Waived | CI run above / [specific file] |

### Manual Tests

| TC | Behaviour | Priority | Result | Evidence |
|----|-----------|----------|--------|----------|
| TC-NNN | [behaviour] | P1 | ✅ Pass / ❌ Fail / ⚠️ Waived | [screenshot path or description] |

---

## Failed Items

| TC | Behaviour | Failure Detail | Resolution | Owner |
|----|-----------|---------------|------------|-------|
| TC-NNN | [behaviour] | [what went wrong] | Fixed [commit] / Deferred / Waived | [name] |

_None_ if no failures.

---

## Waived Items

| TC | Behaviour | Reason | Approved By |
|----|-----------|--------|-------------|
| TC-NNN | [behaviour] | [reason] | [name] |

_None_ if no waivers.

---

## Summary

| Metric | Count |
|--------|-------|
| Total TCs | N |
| Passed | N |
| Failed — Fixed | N |
| Failed — Deferred | N |
| Waived | N |
| **Overall verdict** | **Pass / Fail / Pass with conditions** |

---

## Sign-Off

**Tested by:** _______________ **Date:** _______________

**Approve gate:** ✅ Clear to run `/user:approve` / ❌ Blocked — resolve deferred P1s first
```

## Approve Gate Logic

The final line of the report is computed automatically:

- **Clear** — all P1 TCs are Pass or Waived (with approver); no Fail-Deferred on any P1.
- **Blocked** — one or more P1 TCs are Fail-Deferred with no resolution. List the TC IDs.

`/approve` reads this line and hard-blocks if status is Blocked.
