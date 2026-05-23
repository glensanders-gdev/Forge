<!-- Forge v2.3.2 — update from project template when upgrading Forge -->

# Testing Discipline

Reference file — loaded on demand before writing tests or running /tdd. Do not load at session start.

---

## Test Scenarios (Before Building)

Before building a feature, write 3–5 plain English test scenarios:

```
Feature: [name]
Test 1: When [condition], expect [outcome]
Test 2: When [condition], expect [outcome]
Test 3: Edge case — when [unusual condition], expect [safe outcome]
```

After building, verify each scenario explicitly before marking the ticket as done.

---

## Platform & Compatibility Checklist

For browser-based projects, verify on each significant change:

- [ ] Syntax check passes (`node --check` or equivalent)
- [ ] File size within expected range
- [ ] Key elements still present in DOM (check by ID)
- [ ] No native browser dialogs used (`confirm` / `alert` / `prompt`)
- [ ] All event listeners scoped to correct container
- [ ] No `innerHTML` used in error handling code

---

## TDD Discipline

Follow the red-green-refactor cycle strictly:

1. **Red** — write a failing test that describes the behaviour
2. **Green** — write the minimum code to make it pass
3. **Refactor** — clean up without breaking the test

Never skip red. A test written after the code it tests has no value as a safety net.

---

## Test Coverage Rules

- Every user story in the PRD must have at least one test
- Every critical path behaviour (from testplan) must be covered
- Edge cases and error states are as important as happy paths
- Tests should test behaviour, not implementation — test public interfaces only
- Mocks should be minimal — only mock what crosses a process boundary
