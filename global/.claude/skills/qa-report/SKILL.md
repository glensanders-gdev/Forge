---
name: qa-report
category: pipeline
description: Record the results of a completed QA session as a datestamped evidence artefact. Reads the qa-plan and TC registry, captures pass/fail per test case, structured evidence (CI link, test output, screenshots), and produces docs/tests/results/[feature]-YYYY-MM-DD.md. Use when human runs /qa-report after completing the qa-plan checklist, or before /approve is run.
---

# QA Report

Formalise the results of a completed QA session into a dated evidence artefact. The QA plan is a design doc; this report is the proof. `/approve` will hard-block if this report is missing or contains unresolved P1 failures.

## When to Use

- After the human has worked through `docs/qa-plan-[feature].md`
- Before running `/approve`

## Process

0. **Identify active feature** — read `docs/prd/active/` to get the current feature slug. If multiple PRDs are present, surface them and ask which is active. Store as `[active-feature]`. All file reads and saves in this skill use this slug. If the qa-plan filename or report output doesn't match `[active-feature]`, warn before saving.
1. Read `docs/qa-plan-[active-feature].md` — extract all TC-NNN items and their priority.
2. Read `docs/tests/registry.md` — confirm all TC IDs are registered.
3. Prompt the human for the evidence block (see Evidence Prompt below).
4. Present a results table pre-populated from the qa-plan TC list — human fills in Pass/Fail/Waived per item.
5. Validate:
   - All P1 TCs have a result — no blanks allowed.
   - Any Fail entry has a Resolution field (Fixed / Deferred / Waived).
   - Any Waived entry has an approver name.
6. Compute summary: total, passed, failed (resolved / deferred), waived, overall verdict.
7. Confirm save path with human: "Saving QA report as `docs/tests/results/[active-feature]-YYYY-MM-DD.md` — correct? (yes/no)". Save on confirmation.
8. Update `docs/tests/registry.md` — set status of each TC to `Passed`, `Failed`, or `Waived`.
9. Confirm: "QA report saved. Run `/user:approve` to close the feature."

## Evidence Prompt

Ask the human to provide:

```
Before recording results, please supply:

1. CI run link (required for features with automated tests):
   >

2. Automated test output file path (e.g. docs/tests/results/[feature]-test-output.txt):
   >

3. Screenshot folder path (manual tests only — optional):
   >

4. Tester name:
   >
```

If CI link is absent and the feature has automated TCs, warn: "No CI link provided — automated test evidence will be marked unverified. Proceed? (yes/no)"

## Output Format

See `FORMATS.md` for the full report template.

## Rules

- Never pre-fill Pass/Fail results — the human records them.
- Every P1 TC must have a result before the report is saved.
- Deferred failures must have a reason and owner — never silently deferred.
- Waived items require an approver — never auto-waived.
- The report file is immutable once saved — do not overwrite; create a new dated file for re-runs.
- `/approve` must hard-block if: (a) no report exists for the active feature, or (b) the report contains unresolved P1 failures (status Fail with no Resolution of Fixed or Waived).

## Token Recording (Automatic)

After saving the report, record in `docs/tokens/[feature-name].md`:

```markdown
### QA Report (/qa-report)
**Date range:** YYYY-MM-DD
**Sessions:** 1
**Input:** ~Nk tokens — Read: [qa-plan, registry, source files]
**Output:** ~Nk tokens — [qa-report-YYYY-MM-DD.md]
**Total:** ~Nk ([band])
**Notes:**
```
