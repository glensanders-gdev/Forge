---
name: qa-plan
description: Generate a human QA checklist from the active PRD's user stories and definition of done. Use when user runs /qa-plan, implementation is complete, or the feature is ready for human review before /approve.
---

# QA Plan

Generate a structured human QA checklist from the active PRD. This is the bridge between implementation complete and `/approve`.

## Process

1. Read `docs/prd/active/` — the active PRD.
2. Read `docs/testplan-[feature-name].md` if it exists — use the manual test items with their TC-NNN IDs as the basis for the QA checklist. Carry TC IDs through to the QA plan so results can be reconciled with `docs/tests/registry.md`.
3. Read `docs/known-issues.md` — surface any Active or Deferred issues that affect the feature being tested. Include them as a "Known Issues to Verify" section in the QA plan.
4. Read `docs/kanban.md` — confirm all tickets are marked Done.
5. Extract user stories, edge cases, and the Definition of Done from the PRD.
6. Generate a checklist a human can follow without needing to read the PRD or testplan.
7. Save to `docs/qa-plan.md`.
8. Tell the user: "Work through this checklist, then run `/user:approve` when satisfied."

## Output Format

```markdown
# QA Plan: [Feature Name]

**Date:** YYYY-MM-DD
**Feature:** [PRD name]
**Tester:** [Human name]
**TC range:** TC-NNN through TC-NNN (from testplan-[feature].md)

---

## Pre-QA Checks

- [ ] All kanban tickets marked Done
- [ ] No known blockers outstanding
- [ ] App/server running and accessible

---

## Known Issues to Verify

_From docs/known-issues.md — issues that may affect this feature._

| KI | Issue | Impact | Workaround |
|----|-------|--------|-----------|
| KI-NNN | [issue title] | High | [workaround or None] |

_None_ if no active or deferred issues affect this feature.

---

## User Story Verification

- [ ] **TC-NNN — [Story 1]:** [Plain English steps to verify] → Expected: [outcome]
- [ ] **TC-NNN — [Story 2]:** [Plain English steps to verify] → Expected: [outcome]

---

## Edge Cases

- [ ] **TC-NNN — [Edge case 1]** → Expected: [safe outcome]
- [ ] **TC-NNN — [Edge case 2]** → Expected: [safe outcome]

---

## Error States

- [ ] **TC-NNN — [Error scenario 1]** → Expected: [error handled gracefully]

---

## Definition of Done

- [ ] [Done criterion 1]
- [ ] [Done criterion 2]

---

## Sign-Off

- [ ] All items above checked
- [ ] No regressions observed in existing features
- [ ] Ready to run `/user:approve`

**Tested by:** _______________  **Date:** _______________

---

## QA Results

*Completed by human during QA. Fill in as each item is tested.*

| TC | Test Item | Result | Notes |
|----|-----------|--------|-------|
| TC-NNN | [test item] | ✅ Pass / ❌ Fail / ⚠️ Waived | |

### Failed Items
| TC | Test Item | Failure Detail | Resolution |
|----|-----------|---------------|------------|
| | | | Fixed / Deferred / Waived |

### Waived Items
| TC | Test Item | Reason for Waiver | Approved By |
|----|-----------|------------------|-------------|
| | | | |

### QA Summary
**Total items:** N
**Passed:** N
**Failed:** N (resolved: N, deferred: N)
**Waived:** N
**Overall result:** Pass | Fail | Pass with conditions
```

## Rules

- Write test steps in plain English — assume the tester is not the developer.
- Every user story in the PRD must have at least one QA item.
- Include at least one negative test (what happens when something goes wrong).
- Do not mark any QA items as passed — that is the human's job.
- If the PRD has no Definition of Done, flag it before generating the plan.
- The QA Results section is completed by the human during testing — never pre-fill it.
- Deferred failures must have a reason and owner before `/approve` is run.
- Waived items require explicit approval — never waive silently.
- For any feature with a UI component, include the accessibility QA checklist from the `/user:accessibility` skill. Flag it as a section in the QA plan.

## Token Recording (Automatic)

After QA plan and PII check are complete, record in `docs/tokens/[feature-name].md`:

```markdown
### QA (/qa-plan + /pii-check)
**Date range:** [start date] → [end date]
**Sessions:** N
**Input:** ~Nk tokens — Read: [PRD, testplan, pii-report, source files]
**Output:** ~Nk tokens — [qa-plan.md, pii-report.md]
**Total:** ~Nk ([band])
**Notes:**
```

See `~/.claude/skills/token-report/TOKEN-RECORDING.md` for estimation guidance.
