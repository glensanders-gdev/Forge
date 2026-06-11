# TypeScript Testing

> This file extends [common/quality-checklist.md](../common/quality-checklist.md) with TypeScript specific content.

> **Starter stub** — scaffolded by $lang-rules 2026-06-11. Review and extend.

## Framework

- **Vitest** is the default test runner (Jest-compatible API, native TS/ESM, fast watch mode).
- Coverage via the `v8` provider; enforce the Forge 80% floor on pure logic modules in CI (`coverage.thresholds`).

## Organisation

- Co-locate tests: `foo.ts` → `foo.test.ts` in the same directory.
- Name tests for behaviour, not implementation: `it("depletes the pool only on catch")`, never `it("calls decrementPool")`.

## Determinism

- Inject all sources of nondeterminism (time, randomness, I/O) so tests never mock globals — pass a clock/RNG in, assert pure outputs.
- No `setTimeout`-based waits in tests; use fake timers (`vi.useFakeTimers()`) when time matters.
