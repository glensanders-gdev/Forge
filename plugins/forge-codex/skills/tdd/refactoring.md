# Refactoring Guidelines

Refactoring is restructuring code without changing behaviour. All tests must pass before and after every refactor step.

## The Rule

**Never refactor while RED. Get to GREEN first.**

If you're tempted to refactor before tests pass, stop. The tests are your safety net — you need them green before you move anything.

## When to Refactor

After each RED→GREEN cycle, ask:
- Is there duplication that can be extracted?
- Is there a module that should be deeper (complexity hidden behind a simpler interface)?
- Does the code reveal intent clearly?
- Are there SOLID violations worth addressing?

Don't refactor speculatively. Refactor in response to what you just built.

## Refactor Steps

Each step should be small enough that if tests go RED, you know exactly what caused it.

1. Identify one refactor target
2. Make the change
3. Run tests — must stay GREEN
4. Commit if GREEN
5. Repeat

## Safe Refactors

These rarely break tests:
- Renaming internal variables and functions (not public interface names)
- Extracting private helper functions
- Reordering code within a function
- Replacing a value with a named constant

## Risky Refactors

These can break tests — proceed carefully:
- Changing public interface names or signatures
- Merging or splitting modules
- Changing data structures
- Moving logic between layers (`[UI]` → `[LOGIC]` etc.)

For risky refactors, check: does this change appear in `docs/CONTEXT.md` or any ADR? If so, the change may have wider implications than the codebase.

## Refactoring and the Forge Layer Model

When refactoring crosses layers (`[UI]`, `[DATA]`, `[LOGIC]`, `[SYNC]`, `[INFRA]`), flag it as a multi-layer change in the DEVLOG and consider whether an ADR is warranted.
