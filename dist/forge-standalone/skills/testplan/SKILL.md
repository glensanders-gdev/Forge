---
name: testplan
category: pipeline
description: Design the testing strategy for a feature or a release — what to test, at what level, automated vs manual, and which behaviours are critical. Runs in feature mode against a PRD, or operational mode (--operational) against an ORD register. Produces a testplan.md that feeds into /tdd and /qa-plan. Use when user runs /testplan, a PRD or ORD is written, or before implementation begins.
---

# Test Plan

Design the testing strategy before implementation begins. Establishes what needs to be tested, at what level, and by whom. Feeds directly into `/tdd` (automated tests) and `/qa-plan` (manual verification).

**Execution mode:** `[AFK]` to read sources, classify behaviours and triage requirements; `[HITL]` from the confirmation gate onward. TC IDs are never issued before the human confirms the draft.

## Two Modes — read this first

The two source documents have different scopes, so they produce different artefacts. Mixing them is the failure this split exists to prevent.

| Mode | Source | Scope | Output | Issued |
|---|---|---|---|---|
| **Feature** (default) | PRD stories + Definition of Done | one feature | `docs/testplan-[feature-name].md` | once per feature |
| **Operational** (`--operational`) | ORD requirement register §§3–8 | the release | `docs/testplan-operational.md` | once per release |

An ORD requirement belongs to the release, not to one feature. Pulling register rows into a
feature testplan restates the same commitment in every feature that touches it and issues a fresh
TC for each — the duplication that `rules/requirements/tables.md` § View Tables forbids.

**A feature testplan never restates an operational requirement.** Where a feature depends on one,
reference the TC ID issued by the operational testplan and add no new value — the same view-table
discipline applied to tests.

## When to Use

- After `/write-prd`, before implementation — feature mode
- After `/write-ord` or `/write-reqs`, once per release — operational mode
- When the testing approach for a feature is non-obvious
- When a feature touches multiple layers or systems
- When stakeholder sign-off requires documented test coverage

---

## Process — Feature Mode [AFK → HITL]

1. Read the active PRD from `docs/prd/active/`.
2. Read `docs/CONTEXT.md` — test names must use domain language.
3. Read relevant `~/.claude/knowledge/systems/*/known-issues.md` — known constraints affect what can be tested.
4. Read `docs/testplan-operational.md` if it exists — note which operational TCs already cover this feature's non-functional surface. Reference them; never reissue them.
5. Identify behaviours from the PRD's user stories and Definition of Done.
6. Classify each behaviour by test type (see Test Classification below).
7. Identify critical paths — behaviours that absolutely must work at Go/No Go.
8. **Present the draft testplan for confirmation. [HITL]**
9. **Assign TC IDs** — see TC Registry below. Each row's `Requirement` is the originating `PRD-NNN.N`.
10. Save to `docs/testplan-[feature-name].md`.
11. Suggest: "Run `/user:tdd` to implement automated tests, `/user:qa-plan` for manual verification."

---

## Process — Operational Mode [AFK → HITL]

Run once per release, not per feature.

1. Read the ORD at `docs/ord/*.md` — the requirement register at §§3–5, 7 and 9. Each row carries
   `ORD#`, an active `Requirement Title`, a declarative `Business Tolerance` holding its own value
   and its measurement population, a `KPP` column, `MoSCoW`, a `Status` and a named `Owner`.
   Also read **Appendix D** (conformance) — a demand-side ORD carries no `Verification` column, and
   Appendix D is where the design response's instrument is recorded once it is issued.
   An ORD authored before the demand-side convergence carries the earlier columns
   (`Requirement Description`, `Verification`, `Delivery Agent`, `Timing`, inline `[KPP]`). Read it
   as the same register and do not rewrite the source document.
2. Read `docs/CONTEXT.md` — test names must use domain language.
3. Read relevant `~/.claude/knowledge/systems/*/known-issues.md`.
4. **Triage every register row by verification venue** (see ORD Verification Triage below). Every
   row lands in exactly one bucket. A row that is hard to place is presented for a human call —
   never dropped.
5. **Reconcile.** Count the register rows read and the rows placed. The two must match. Report the
   count in the Triage Summary. A row that appears in no bucket is a defect in this run, not an
   omission in the ORD.
6. Identify the operational critical path — **[KPP]** rows whose verification is executable
   pre-release. These gate Go/No Go.
7. **Present the triage for confirmation. [HITL]** Show the bucket assignment for every row before
   any TC is issued.
8. **Assign TC IDs** to the Test bucket only — see TC Registry below. Each row's `Requirement` is
   the originating `ORD-NNN`.
9. Save to `docs/testplan-operational.md`.
10. Report the Inspection and In-Service buckets explicitly as handoffs — they carry no TC and are
    verified outside this test chain.

### ORD Verification Triage

Read the row's **measurement population** — stated inside the `Business Tolerance` — together with
its **Appendix D** instrument where one has been recorded. Population plus instrument is what
determines whether a requirement can become a test case.

**Where Appendix D is still pending**, the design response has not been issued and no instrument
exists yet. Triage the row on its population alone: it still lands in a venue, and its TC records
`instrument: pending design response`. A row is never dropped for want of an instrument, and an
instrument is never invented to fill the gap — inventing one re-introduces the pre-emption the
demand-side rule exists to prevent.

| Ask | Answer | Venue | Gets a TC? |
|---|---|---|---|
| Can it be executed on demand, before release, against a build or environment? | yes | **Test** | yes |
| Is it proven by a document, config, or sign-off that exists before release? | yes | **Inspection** | no — Go/No Go evidence |
| Does it need elapsed time in production or real user traffic to measure? | yes | **In service** | no — monitoring commitment |

Apply the tests in order; the first match wins.

**Split a row rather than forcing it into one bucket.** Many reliability and performance rows have
an executable part and an in-service part. *"Service availability is 99.9% per calendar month,
verified by monitoring and failover drill"* yields a **Test** row (the failover drill, executable
now) and an **In service** row (the monthly threshold). Record both against the same `ORD-NNN`. A
forced binary either invents a test that cannot pass or discards a test that could.

**Check `Owner` before absorbing a row.** A demand-side register names the *business* owner of the
tolerance, not a delivery team — so a row's verification may well belong to another department. It
still gets triaged and still appears in the plan, with the owner named. Never silently move another
team's verification into this repo's test suite.

**Rows that yield no TC in any bucket:**

- `MoSCoW` = `Won't` — no verification for this release. Consistent with `/write-ac`.
- `Business Tolerance` still `[TBD — source: "…"]` — record it in Not Verifiable Yet. Never
  invent a threshold to make a row testable (`rules/requirements/language.md`).
- No measurement population stated in the tolerance — an authoring defect in the ORD. Report it; do
  not guess one. A pending Appendix D is **not** a defect: it is the expected state before the
  design response is issued.

---

## Test Classification

### Automated Tests (covered by `/tdd`)
Behaviours that can be verified programmatically through public interfaces:
- Sunny Day through public API
- Edge Cases with deterministic outcomes
- Rainy Day states that can be triggered programmatically
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

**"Not Tested" is not the home for an operational requirement.** Its reasons are out of scope,
covered elsewhere, or too costly — none of which is true of an availability threshold. Those belong
in the operational testplan's In Service section, where they stay visible without entering the gate.

---

## TC Registry

Both modes issue IDs from the same sequence in `docs/tests/registry.md`. Read it, take the next
number, continue from the last issued — never assign ad hoc.

```markdown
| TC-NNN | [Behaviour] | [feature-name / release] | [artefact filename] | [PRD-NNN.N / ORD-NNN / —] | Automated/Manual | Defined |
```

Columns: `TC` · `Behaviour` · `Feature/Area` · `Artefact` · **`Requirement`** · `Type` · `Status`.

`Requirement` is the originating requirement ID. It is what makes a test traceable back to the
document that demanded it, and it is the column that carries ORD coverage through to `/qa-report`.
Write `—` only where a test genuinely has no requirement origin.

**Migrating an existing registry. [HITL]** A registry written before this column exists has six
columns, and `/qa-report`, and `/test-coverage` all parse it. Adding a column is a schema
change to a shared artefact, so present it and require a typed `CONFIRM`:

```
## Registry migration — docs/tests/registry.md
Adding column: Requirement (position 5 of 7)
N existing rows backfilled to `—`.
Skills that read this file: /qa-report, /test-coverage.
Type CONFIRM to apply.
```

On decline, issue the new TCs in the existing six-column shape and report that requirement
traceability is not recorded for this run. Never apply a partial migration.

---

## Feature Testplan Output Format

```markdown
# Test Plan: [Feature Name]

**PRD:** [link or filename]
**Date:** YYYY-MM-DD
**Sprint:** Sprint-NN
**TC range:** TC-NNN through TC-NNN
**Operational TCs referenced:** [TC-NNN, TC-NNN — from testplan-operational.md, or "none"]

---

## Critical Path Behaviours
Behaviours that must pass at Go/No Go:

1. TC-NNN — [Behaviour] — [why critical]
2. TC-NNN — [Behaviour] — [why critical]

---

## Automated Tests

### [Module or Layer]

| TC | Requirement | Behaviour | Test Type | Priority | Notes |
|----|-------------|-----------|-----------|----------|-------|
| TC-NNN | PRD-001.1 | [User story behaviour] | Integration | P1 | |
| TC-NNN | PRD-001.2 | [Edge case] | Integration | P2 | |
| TC-NNN | PRD-002.1 | [Error state] | Integration | P2 | |

### Mocking Strategy
[What external dependencies will be mocked and why]

### Prior Art
[Existing tests in the codebase to reference or extend]

---

## Manual Tests

| TC | Requirement | Behaviour | Steps | Expected Outcome | Priority |
|----|-------------|-----------|-------|-----------------|----------|
| TC-NNN | PRD-003.1 | [UI behaviour] | [steps] | [outcome] | P1 |

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

---

## Operational Testplan Output Format

```markdown
# Operational Test Plan: [Release / System Name]

**ORD:** [path]
**Release:** PI-N-RN
**Date:** YYYY-MM-DD
**TC range:** TC-NNN through TC-NNN

Values are carried verbatim from the ORD register. The ORD is authoritative — this document adds
no new commitments. Change a value there and re-run.

---

## Triage Summary

| Venue | Rows | ORD IDs |
|-------|------|---------|
| Test — executable pre-release | N | ORD-NNN, … |
| Inspection — evidence pre-release | N | ORD-NNN, … |
| In service — measured in production | N | ORD-NNN, … |
| No verification this release | N | ORD-NNN, … |

Register rows read: **N.** Rows placed: **N.** *(These must match.)*

---

## Critical Path — Operational
**[KPP]** rows whose verification is executable before release. These gate Go/No Go:

1. TC-NNN — ORD-NNN — [requirement] — [why critical]

---

## Executable Tests

| TC | ORD# | Requirement | Verification Method | Level | Owner | Priority |
|----|------|-------------|--------------------|-------|-------|----------|
| TC-NNN | ORD-004 | [declarative end state, carrying its value] | [verbatim from Appendix D] | System | [Owner, from the register] | P1 |
| TC-NNN | ORD-009 | [requirement] | instrument: pending design response | Environment | [Owner, from the register] | P2 |

`Level`: Unit / Integration / System / Environment.

### Test Environment Requirements
[What must exist to run these — sized environment, seeded data, failover pair, load generator]

---

## Verified by Inspection — no TC

Proven before release by evidence, not by execution. Routed to the Go/No Go evidence pack.

| ORD# | Requirement | Evidence Required | Owner | Due |
|------|-------------|------------------|-------|-----|
| ORD-NNN | [requirement] | [document / config / sign-off] | [Owner, from the register] | [milestone] |

---

## Verified in Service — no TC

Measurable only after time in production. **These never gate Go/No Go** — a gate that must be
waived is not a gate.

| ORD# | Requirement | Monitoring Method | Owner | First Review |
|------|-------------|------------------|-------|--------------|
| ORD-NNN | [threshold, verbatim] | [verbatim from Appendix D] | [Owner, from the register] | [date or milestone] |

---

## Not Verifiable Yet

| ORD# | Reason |
|------|--------|
| ORD-NNN | Threshold still `[TBD]` — no measurable target to test against |
| ORD-NNN | No measurement population stated in the tolerance — undefined |
| ORD-NNN | `MoSCoW: Won't` — out of scope for this release |

---

## Definition of Operational Test Complete

- [ ] All P1 executable tests (TC-NNN–TC-NNN) run and passing
- [ ] Every **[KPP]** row is covered by a passing test, an accepted inspection, or a recorded waiver
- [ ] Inspection evidence collected and attached to the Go/No Go brief
- [ ] In-service commitments have a named owner and a monitoring method in place before deployment
- [ ] Every `[TBD]` row is either resolved in the ORD or accepted as a known gap
```

---

## Rules

- Test names must use `docs/CONTEXT.md` domain language — not implementation language
- Every user story in the PRD must have at least one test item (feature mode)
- Every ORD register row must land in exactly one triage bucket (operational mode)
- The "Not Tested" section is mandatory — silence is not acceptable
- Critical path behaviours must be identified before implementation begins
- Do not write tests during testplan — this is design only
- The testplan is a living document — update it if PRD or ORD scope changes

## Never

- Never pull an ORD register row into a feature testplan — reference the operational TC instead.
- Never issue two TCs for the same commitment. One requirement, one test, referenced everywhere else.
- Never put an in-service threshold on the Go/No Go critical path — it cannot pass at the gate, and a routinely waived gate stops being a gate.
- Never invent a threshold to make a `[TBD]` row testable, and never guess an instrument the ORD's Appendix D does not state.
- Never edit a value carried from the ORD — the register is authoritative; change it there and re-run.
- Never silently drop a register row. If it fits no bucket, present it for a human call.
- Never assign TC IDs before the human confirms the draft, and never assign them ad hoc outside `docs/tests/registry.md`.
- Never migrate the registry schema without a typed `CONFIRM`, and never apply a partial migration.
- Never absorb another department's verification without naming them as `Owner`.
- Never write tests here — that is `/tdd`.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No PRD and no ORD | Stop — behaviours come from a PRD's user stories or an ORD's register. Author one first. |
| No PRD, ORD present | Run operational mode and say so. Feature-level behaviour is uncovered until a PRD exists. |
| PRD present, no ORD, `--operational` passed | Stop. "No ORD found at `docs/ord/` — operational mode reads the requirement register." |
| `docs/tests/registry.md` missing | Create it with all seven columns and start numbering from TC-001 — never assign TC IDs ad hoc. |
| Registry exists without a `Requirement` column | Offer the migration and require `CONFIRM`. On decline, use the six-column shape and report the loss of traceability. |
| A user story has no test item | Add one — every story needs at least one test before the plan is saved. |
| An ORD row states no measurement population | Do not guess. List it under Not Verifiable Yet and report it as an ORD authoring defect. |
| The ORD's Appendix D is pending | Expected before the design response is issued. Triage on the population and record `instrument: pending design response`. Not a defect. |
| An ORD row is still `[TBD]` | List it under Not Verifiable Yet. Never invent a threshold. |
| Triage counts do not reconcile | Stop before issuing TCs. A missing row is a defect in this run — find it. |
| A row has both an executable and an in-service part | Split it. Record both against the same `ORD-NNN` in their respective sections. |
| No **[KPP]** tagged in the ORD | Proceed, and flag: "No KPP designated — confirm the release has no program-failure threshold." |
| Every ORD row is `Won't` | Stop. "All operational requirements are marked Won't for this release — no operational tests to design." |
| `docs/testplan-operational.md` already exists | Stop. Confirm overwrite, or confirm this is a re-run after an ORD change. |
| "Not Tested" section left empty | Fill it — silence on exclusions is not acceptable; state what's excluded and why. |
| Tempted to write tests now | Stop — testplan is design only; tests are written in `/tdd`. |
| PRD or ORD scope changes later | Update the testplan — it's a living document, not a one-shot artefact. |
