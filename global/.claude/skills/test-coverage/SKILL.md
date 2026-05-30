---
name: test-coverage
category: pipeline
description: Analyze test coverage gaps in an existing codebase, identify under-covered files and functions, then generate missing tests to reach the project coverage threshold (default 80%). Reactive complement to /tdd (which writes tests first for new code). Use when user runs /test-coverage, coverage is below threshold before a release, or /go-nogo flags a coverage gap.
origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)
---

# Test Coverage

Closes coverage gaps in existing code — detect framework, run coverage, rank gaps, confirm
scope, write missing tests, verify, report before/after. Reactive complement to `/tdd`
(which is proactive: test-first for new code). This skill is for code that already exists
but lacks sufficient test coverage.

---

## Usage

```
/test-coverage                        ← full analysis + gap remediation
/test-coverage --analyze-only         ← report gaps, do not write tests
/test-coverage --file src/auth.ts     ← focus on a single file
/test-coverage --threshold 90         ← override default threshold for this run
```

---

## Coverage Threshold

Read from `CLAUDE.md` (project root) if a `coverage-threshold` value is specified.
Default: **80%** (Forge quality-checklist.md standard).

If `--threshold N` is passed, use that value for this run only — do not persist.

---

## Phase 1 [AFK] — Detect Framework and Threshold

**Step 0 — Resolve active company:** Read `~/.claude/preferences.md`. If `active-company:` is set, use that value in place of `[active_company]` throughout this run. If not set, skip all company-config reads and check only `~/.claude/tools/global.md` for the test-runner category.

### 1a. Read project context

- Read `docs/CONTEXT.md` — test names must use domain language throughout
- Read `CLAUDE.md` — check for `coverage-threshold`, test conventions, or project-specific
  test file naming patterns (e.g. `*.spec.ts`, `*_test.go`)
- Read `~/.claude/companies/[active_company]/tools.md` then `~/.claude/tools/global.md` —
  check for a registered `test-runner` tool. If `prohibited`, stop and note it.

### 1b. Detect test framework

Use the registered `test-runner` tool if available. Otherwise detect from project files:

| Indicator | Coverage command |
|-----------|-----------------|
| `jest.config.*` or `"jest"` in `package.json` | `npx jest --coverage --coverageReporters=json-summary` |
| `vitest.config.*` | `npx vitest run --coverage` |
| `pytest.ini` / `pyproject.toml` with pytest | `pytest --cov=src --cov-report=json` |
| `Cargo.toml` | `cargo llvm-cov --json` |
| `pom.xml` with JaCoCo plugin | `mvn test jacoco:report` |
| `go.mod` | `go test -coverprofile=coverage.out ./... && go tool cover -func=coverage.out` |

If no framework can be detected, stop and ask the user to specify the coverage command.

Announce before running:
```
Detected framework: [name]
Coverage command:   [command]
Threshold:         [N]%
```

---

## Phase 2 [AFK] — Run Coverage

Run the detected coverage command. Capture output.

If the command fails:
- Show the exact error output
- Do not proceed — ask the user to fix the test suite first (all existing tests must pass before gap analysis is meaningful)

---

## Phase 3 [AFK] — Analyze Gaps

Parse the coverage output. For each file:
1. Extract statement/line coverage percentage
2. Identify which functions or methods are untested or partially covered
3. Identify missing branch coverage (if/else, switch, ternary, error paths)
4. Note dead code that inflates the denominator without being real coverage

Produce a ranked gap list — worst coverage first:

```
Coverage Analysis — [Project Name]
Threshold: [N]%  |  Overall: [N]%  |  Status: [PASS / FAIL]

Files below threshold (sorted worst-first):
  src/services/auth.ts          45%   — missing: validateToken(), refreshSession(), 3 error branches
  src/utils/validation.ts       32%   — missing: all edge-case branches, null/empty inputs
  src/api/payments.ts           61%   — missing: refund handler, network-failure path

Files at or above threshold: [N] files — not shown
```

**Focus areas to highlight when present:**
- Functions with high cyclomatic complexity (many branches)
- Error handlers and catch blocks
- Utility functions used widely across the codebase
- API endpoint handlers (request → response full flow)

---

## Phase 4 [HITL] — Confirm Scope

Present the gap list and ask which files to address:

```
Found [N] files below [threshold]%. Which would you like to address?

  [1] All files below threshold
  [2] Critical files only (P1 — furthest below threshold)
  [3] Specific file(s) — list them
  [4] Analyze only — do not write tests

Choice:
```

Wait for explicit response. Do not write any tests without this confirmation.

If `--analyze-only` was passed, skip this gate and output the analysis only.
If `--file` was passed, pre-select that file and confirm with the user before writing.

---

## Phase 5 [AFK] — Generate Missing Tests

For each confirmed file, generate tests in this priority order:

1. **Happy path** — core functionality with valid inputs producing expected output
2. **Error handling** — invalid inputs, missing data, network failures, unexpected nulls
3. **Edge cases** — empty arrays, null/undefined, boundary values (0, -1, MAX_INT, empty string)
4. **Branch coverage** — each if/else arm, switch case, ternary, and try/catch path

### Test generation rules

Follow the test generation rules from `/tdd` — same philosophy applies here. Match existing
test patterns (import style, assertion library, mocking approach), mock only external
dependencies, write self-contained tests, and use domain language from `docs/CONTEXT.md` for
naming. Read `CLAUDE.md` for the project file naming convention before writing.

### TC ID assignment

After generating each test (or test group for a file):
1. Read `docs/tests/registry.md` — get the next TC number
2. Assign sequential IDs to each new test case
3. Update `docs/tests/registry.md`:
   ```markdown
   | TC-NNN | [Behaviour tested] | [feature/area] | [test file path] | Automated | Added by /test-coverage |
   ```

If `docs/tests/registry.md` does not exist, note it and skip TC assignment — do not create the file.

---

## Phase 6 [AFK] — Verify

1. Run the full test suite (not just the new tests) — all tests must pass.
   If any existing test breaks, stop and report which test failed and why.
2. Re-run the coverage command.
3. Parse the new coverage percentages.
4. If any file is still below threshold, note the remaining gap — do not loop indefinitely.

---

## Phase 7 [AFK] — Report

```
Coverage Report — [Project Name]
Generated: YYYY-MM-DD

──────────────────────────────────────────────────────
File                          Before    After     Status
──────────────────────────────────────────────────────
src/services/auth.ts           45%       88%       ✅ PASS
src/utils/validation.ts        32%       82%       ✅ PASS
src/api/payments.ts            61%       73%       ⚠️  still below 80%
──────────────────────────────────────────────────────
Overall                        67%       84%       ✅ PASS

Tests written: [N]  |  TC IDs assigned: TC-NNN – TC-NNN
```

If any file is still below threshold:
```
⚠️ [N] file(s) still below [threshold]%:
   src/api/payments.ts — 73% (need 7% more)
   Remaining gaps: [specific functions or branches not yet covered]
   Run /test-coverage --file src/api/payments.ts to address these specifically.
```

---

## Forge Integration Points

| Skill | Relationship |
|-------|-------------|
| `/tdd` | Sibling — `/tdd` is proactive (test-first for new code); `/test-coverage` is reactive (gap remediation for existing code). Both use the same test writing philosophy. |
| `/testplan` | `/testplan` designs the strategy; `/test-coverage` executes gap analysis and remediation against existing code. TC IDs assigned here follow the same registry. |
| `/qa-plan` | `/qa-plan` covers manual verification; `/test-coverage` targets automated coverage gaps. |
| `/go-nogo` | Coverage below threshold is a release gate signal. `/go-nogo` can reference the last coverage run. |
| `/review` | Run after writing new tests — verify the generated tests meet quality standards before committing. |
| `tools/global.md` | `test-runner` category is checked first for framework detection. |
| `quality-checklist.md` | "Coverage meets project minimum (80%)" — this skill closes that gap. |

---

## `/go-nogo` Integration

After `/test-coverage` completes, update `~/.claude/preferences.md`:
```
test-coverage-last-run: YYYY-MM-DD
test-coverage-status: PASS | FAIL
test-coverage-overall: N%
```

`/go-nogo` reads `test-coverage-status`. If `FAIL` or missing:
```
⚠️ Test coverage below threshold (last check: N% on YYYY-MM-DD).
   Run /test-coverage to close gaps before shipping.
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No test framework detected | Ask user to specify the coverage command — do not guess |
| Coverage command fails or exits non-zero | Show the error verbatim; stop — do not attempt gap analysis on a broken test suite |
| Existing tests break after writing new tests | Stop immediately, report the failing test and error — do not commit new tests |
| File has 0% coverage (no tests at all) | Flag as highest priority — start with a single happy-path test to establish the pattern |
| Generated test placement is ambiguous | Ask the user for the correct test directory/naming convention before writing |
| `docs/tests/registry.md` not found | Note it, skip TC assignment, continue with test generation |
| Coverage output format unrecognised | Show raw output and ask the user to identify the coverage percentage manually |
| All files already above threshold | Report "✅ All files above [N]% threshold — no gaps to address" and stop |
| `--file` target not found in coverage output | Report "File not found in coverage data" — check path and re-run |

---

## Rules

- Never write tests without first showing the coverage gap analysis and receiving explicit scope confirmation (Phase 4 HITL gate)
- Never run `--fix` or auto-remediation commands on the test suite — only write new test files
- Never break existing tests to improve coverage metrics — all existing tests must remain passing
- Never mock internal code — only mock external dependencies (database, APIs, file system, network)
- Never write tests that only verify mocks, not real behaviour
- Never inflate coverage with trivially passing tests (e.g. `assert True`) — each test must verify meaningful behaviour
- Test names must use domain language from `docs/CONTEXT.md` — never implementation-internal terms
- Always verify (Phase 6) before reporting — never report estimated coverage improvements
- If overall coverage passes but individual files remain below threshold, report both

---

## Attribution

Adapted from Affaan Mustafa (ECC / [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC/blob/main/commands/test-coverage.md))
