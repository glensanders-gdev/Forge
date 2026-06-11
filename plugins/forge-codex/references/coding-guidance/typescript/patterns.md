# TypeScript Patterns

> This file extends [common/coding-style.md](../common/coding-style.md) with TypeScript specific content.

> **Starter stub** — scaffolded by $lang-rules 2026-06-11. Review and extend.

## Boundary Validation

- Validate all external data (file content, JSON, API responses, save files) with **Zod** schemas at the boundary; derive static types with `z.infer<typeof Schema>` — one source of truth, never parallel hand-written types.

## Exhaustiveness

- Switch on discriminated unions must be exhaustive — end with a `never` check so adding a variant breaks compilation, not production:
  ```ts
  default: { const _exhaustive: never = value; throw new Error(`Unhandled: ${_exhaustive}`); }
  ```

## Dependency Injection

- Pass dependencies (RNG, clock, storage, loggers) as parameters or constructor args — no module-level singletons. This is what makes the common immutability and testing rules achievable.

## Module Boundaries

- Enforce architectural import boundaries with lint rules (e.g. `eslint-plugin-boundaries` or `no-restricted-imports`) — a declared boundary that isn't lint-enforced will erode.
