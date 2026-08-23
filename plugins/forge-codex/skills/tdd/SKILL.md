---
name: "tdd"
description: "Test-driven development with red-green-refactor loop. Use when user wants to build features or fix bugs using TDD, mentions \"red-green-refactor\", wants integration tests, or asks for test-first development."
metadata:
  category: pipeline
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Test-Driven Development

## Philosophy

Tests should verify behaviour through public interfaces, not implementation details. Code can change entirely — tests shouldn't.

Good tests are integration-style: they exercise real code paths through public APIs, describe *what* the system does rather than *how*, and survive refactors because they don't care about internal structure.

See [tests.md](tests.md) for good/bad examples and [mocking.md](mocking.md) for mocking guidelines.

## Where TDD Applies — Seams

A **seam** is the boundary at which behaviour becomes observable through a public interface. That is where a test attaches. Naming the seams is part of Step 1 — Plan, agreed with the human before the tracer bullet, not discovered mid-cycle: *this module boundary, this HTTP handler, this CLI invocation.*

Not every ticket has one of its own. Where there is no seam, a RED test asserts either the framework's behaviour or nothing at all — writing one is theatre, and it hides that the work was never verified. Those tickets keep the verification obligation and change only the evidence that satisfies it:

| Ticket shape | Why there is no seam | Evidence required instead |
|---|---|---|
| Dependency or version bump | The behaviour under test belongs to the dependency | Full suite green before and after; the version delta recorded on the ticket |
| Configuration, env, or infra declaration | No code path of ours to exercise | Config applied in a real environment, output recorded |
| One-shot data migration | Runs once — a unit test asserts a fixture, not the migration | Rehearsal against a copy of production-shaped data; row counts before and after |
| Scaffolding or generated code | Asserting a generator's output tests the generator | The next ticket — the one putting behaviour behind the scaffold — carries the tests |
| Pure visual or layout change | No observable behaviour through a public interface | `qa-plan` manual item plus an `accessibility` check |
| `prototype` spike | Throwaway by definition — the spike answers a question, it does not ship | The prototype's own findings note; the ticket that follows from the PRD is TDD'd normally |

**The exemption is human-agreed, never agent-declared.** "Where possible" is an escape hatch the moment an agent gets to decide what was possible. A ticket is exempt only when a human agreed it in Plan, and the reason is recorded on the ticket so the gap is visible at `qa-plan` rather than discovered in production:

```
no-seam: [why no test attaches] — verified by [evidence]
```

If a ticket looks seamless mid-cycle, that is a Plan defect, not a licence — stop and put it to the human with the proposed evidence.

> The seam framing is adapted from Matt Pocock's `implement` skill (github.com/mattpocock/skills) — "use TDD where possible, at pre-agreed seams". This skill keeps the pre-agreement and makes the exemption a recorded human decision carrying its own evidence.

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
- Name the seams the tests attach to, and agree any ticket that has none (see Where TDD Applies — Seams)
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

- Run `testplan` before `tdd` to establish what needs testing
- TDD satisfies the automated test items from the testplan
- `qa-plan` covers the manual verification items
- Reference the testplan's behaviour list when choosing what to test next

## Rules

- Never write all tests first then all implementation — run one RED→GREEN cycle at a time (see Anti-Pattern: Horizontal Slices).
- Never refactor while RED — get to GREEN first.
- Never test implementation details — only observable behaviour through public interfaces.
- Never add code a current failing test doesn't require — no speculative features.
- Never start the tracer bullet without user approval of the behaviour list and the seams the tests attach to.
- Never declare a ticket exempt from TDD on your own judgement — "no seam" is a human decision recorded on the ticket, not a call made mid-cycle (see Where TDD Applies — Seams).
- Never treat a no-seam ticket as unverified work — the exemption changes what the evidence is, never the obligation to produce it.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| User hasn't run `$testplan` | Suggest it first; if proceeding anyway, agree the behaviour list with the user before the tracer bullet. |
| No `docs/CONTEXT.md` | Proceed, but flag that test names can't be checked against domain language. |
| New test passes on first run (never RED) | Stop — the test isn't proving anything; fix the test or the behaviour before writing code. |
| Tempted to write several tests at once | Horizontal-slice anti-pattern — write one test, make it pass, then the next. |
| A refactor turns tests RED | You're refactoring behaviour rather than structure, or refactoring while already RED — revert to GREEN first. |
| A behaviour can't be tested through the public interface | The interface needs redesign for testability — see [interface-design.md](interface-design.md) before mocking internals. |
| A ticket looks like it has no seam | Stop and put it to the human with the proposed evidence — never skip silently, and never invent a test that asserts the framework instead. |
| Seams weren't agreed during Plan | Return to Step 1 and name the interfaces the tests attach to before writing the tracer bullet. |
| "Where possible" invoked on a ticket that does have a seam | It has one — the work is being avoided, not exempted. Write the test. |
| A no-seam ticket reaches `qa-plan` with no recorded evidence | It is not Done. Produce the evidence named in the seam table, or raise the gap explicitly. |
