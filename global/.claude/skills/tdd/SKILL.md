---
name: tdd
category: pipeline
description: Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions "red-green-refactor", wants integration tests, or asks for test-first development.
---

# Test-Driven Development

## Philosophy

Tests should verify behaviour through public interfaces, not implementation details. Code can change entirely — tests shouldn't.

Good tests are integration-style: they exercise real code paths through public APIs, describe *what* the system does rather than *how*, and survive refactors because they don't care about internal structure.

See [tests.md](tests.md) for good/bad examples and [mocking.md](mocking.md) for mocking guidelines.

## Anti-Pattern: Horizontal Slices

**Never write all tests first, then all implementation.** This produces tests that verify imagined behaviour rather than actual behaviour.

```
WRONG (horizontal):
  RED:   test1, test2, test3, test4, test5
  GREEN: impl1, impl2, impl3, impl4, impl5

RIGHT (vertical):
  RED→GREEN: test1→impl1
  RED→GREEN: test2→impl2
  RED→GREEN: test3→impl3
```

## Workflow

### 1. Plan

Before writing any code:

- Read `docs/CONTEXT.md` — test names and vocabulary must match domain language
- Confirm with user what interface changes are needed
- Confirm which behaviours to test — you can't test everything, prioritise critical paths
- Identify opportunities for deep modules — see [deep-modules.md](deep-modules.md)
- Design interfaces for testability — see [interface-design.md](interface-design.md)
- List the behaviours to test (not implementation steps)
- Get user approval on the plan

### 2. Tracer Bullet

Write ONE test that confirms ONE thing end-to-end:

```
RED:   Write test for first behaviour → test fails
GREEN: Write minimal code to pass → test passes
```

This proves the path works before building out.

### 3. Incremental Loop

For each remaining behaviour:

```
RED:   Write next test → fails
GREEN: Minimal code to pass → passes
```

Rules:
- One test at a time
- Only enough code to pass the current test
- Don't anticipate future tests
- Keep tests focused on observable behaviour

### 4. Refactor

After all tests pass — see [refactoring.md](refactoring.md):

- Extract duplication
- Deepen modules (move complexity behind simple interfaces)
- Run tests after each refactor step
- **Never refactor while RED — get to GREEN first**

## Checklist Per Cycle

```
[ ] Test describes behaviour, not implementation
[ ] Test uses public interface only
[ ] Test would survive internal refactor
[ ] Code is minimal for this test
[ ] No speculative features added
[ ] Test name matches CONTEXT.md domain language
```

## Integration with Forge

- Run `/user:testplan` before `/user:tdd` to establish what needs testing
- TDD satisfies the automated test items from the testplan
- `/user:qa-plan` covers the manual verification items
- Reference the testplan's behaviour list when choosing what to test next
