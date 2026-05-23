---
name: testplan
description: Design the testing strategy for a feature — what to test, at what level, automated vs manual, and which behaviours are critical. Produces a testplan.md that feeds into /tdd and /qa-plan. Use when user runs /testplan, a PRD is written, or before implementation begins.
---

# Test Plan

Design the testing strategy for a feature before implementation begins. Establishes what needs to be tested, at what level, and by whom. Feeds directly into `/tdd` (automated tests) and `/qa-plan` (manual verification).

## When to Use

- After `/write-prd`, before implementation
- When the testing approach for a feature is non-obvious
- When a feature touches multiple layers or systems
- When stakeholder sign-off requires documented test coverage

## Process

1. Read the active PRD from `docs/prd/active/`.
2. Read `docs/CONTEXT.md` — test names must use domain language.
3. Read relevant `~/.claude/knowledge/systems/*/known-issues.md` — known constraints affect what can be tested.
4. Identify behaviours from the PRD's user stories and Definition of Done.
5. Classify each behaviour by test type (see below).
6. Identify critical paths — behaviours that absolutely must work at Go/No Go.
7. Present the draft testplan for confirmation.
8. **Assign TC IDs** — for each confirmed test case:
   - Read `docs/tests/registry.md` — get next TC number (continuing from last issued)
   - Assign sequential IDs: `TC-NNN`, `TC-NNN+1`, etc.
   - Prefix each test case in the testplan with its ID
   - Update `docs/tests/registry.md` with all new entries:
     ```markdown
     | TC-NNN | [Behaviour] | [feature-name] | testplan-[feature].md | Automated/Manual | Defined |
     ```
9. Save to `docs/testplan-[feature-name].md`.
10. Suggest: "Run `/user:tdd` to implement automated tests, `/user:qa-plan` for manual verification."

## Test Classification

### Automated Tests (covered by `/tdd`)
Behaviours that can be verified programmatically through public interfaces:
- Happy path through public API
- Known edge cases with deterministic outcomes
- Error states that can be triggered programmatically
- Data transformations and calculations

### Manual Tests (covered by `/qa-plan`)
Behaviours that require human judgement or are hard to automate:
- UI/UX verification
- Cross-browser or cross-device behaviour
- Integration with external systems in production
- Accessibility and visual correctness
- Performance under real conditions

### Not Tested (explicit exclusion)
Be explicit about what is NOT being tested and why:
- Out of scope per PRD
- Covered by existing tests
- Too costly to automate relative to risk

## Testplan Output Format

```markdown
# Test Plan: [Feature Name]

**PRD:** [link or filename]
**Date:** YYYY-MM-DD
**Sprint:** Sprint-NN
**TC range:** TC-NNN through TC-NNN

---

## Critical Path Behaviours
Behaviours that must pass at Go/No Go:

1. TC-NNN — [Behaviour] — [why critical]
2. TC-NNN — [Behaviour] — [why critical]

---

## Automated Tests

### [Module or Layer]

| TC | Behaviour | Test Type | Priority | Notes |
|----|-----------|-----------|----------|-------|
| TC-NNN | [User story behaviour] | Integration | P1 | |
| TC-NNN | [Edge case] | Integration | P2 | |
| TC-NNN | [Error state] | Integration | P2 | |

### Mocking Strategy
[What external dependencies will be mocked and why]

### Prior Art
[Existing tests in the codebase to reference or extend]

---

## Manual Tests

| TC | Behaviour | Steps | Expected Outcome | Priority |
|----|-----------|-------|-----------------|----------|
| TC-NNN | [UI behaviour] | [steps] | [outcome] | P1 |
| TC-NNN | [Integration behaviour] | [steps] | [outcome] | P2 |

---

## Not Tested

| Item | Reason |
|------|--------|
| [behaviour] | [out of scope / covered elsewhere / too costly] |

---

## Definition of Test Complete

- [ ] All P1 automated tests (TC-NNN–TC-NNN) written and passing
- [ ] All P2 automated tests written and passing
- [ ] All P1 manual tests verified by human
- [ ] No known P1 bugs outstanding
- [ ] Test coverage reviewed against critical path behaviours
```

## Rules

- Test names must use `docs/CONTEXT.md` domain language — not implementation language
- Every user story in the PRD must have at least one test item
- The "Not Tested" section is mandatory — silence is not acceptable
- Critical path behaviours must be identified before implementation begins
- Do not write tests during testplan — this is design only
- The testplan is a living document — update it if PRD scope changes

## Token Recording (Automatic)

After `testplan-[feature].md` is saved, record in `docs/tokens/[feature-name].md`:

```markdown
### Testplan
**Date range:** YYYY-MM-DD
**Sessions:** N
**Input:** ~Nk tokens — Read: [PRD, CONTEXT.md, source files]
**Output:** ~Nk tokens — [testplan-*.md]
**Total:** ~Nk ([band])
**Notes:**
```

See `~/.claude/skills/token-report/TOKEN-RECORDING.md` for estimation guidance.
