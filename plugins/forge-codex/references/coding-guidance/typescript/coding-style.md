# TypeScript Coding Style

> This file extends [common/coding-style.md](../common/coding-style.md) with TypeScript specific content.

> **Starter stub** — scaffolded by $lang-rules 2026-06-11. Review and extend; rules here are minimal and verifiably idiomatic only.

## Compiler Strictness

- `"strict": true` in tsconfig — non-negotiable baseline.
- Enable `noUncheckedIndexedAccess` — indexed access returns `T | undefined`, forcing real bounds handling.
- No `any`. Use `unknown` at boundaries and narrow with type guards or schema parsing.

## Types & Idioms

- Use `import type { … }` for type-only imports.
- Model state with discriminated unions, not boolean flags or optional-field soup.
- Prefer `const` everywhere; use `readonly` properties and `ReadonlyArray`/`Readonly<T>` to enforce the common immutability rule at the type level.
- `interface` for object shapes that may be extended; `type` for unions, intersections, and function types.

## Error Handling

- No floating promises — every promise is awaited, returned, or explicitly voided (`@typescript-eslint/no-floating-promises`).
- Catch clauses receive `unknown` — narrow before use; never assume `Error`.
- Throw `Error` subclasses (or typed result objects), never strings.

## Naming

- `camelCase` functions/variables, `PascalCase` types/classes/enums, `UPPER_SNAKE_CASE` module-level constants — extends the common naming rules unchanged.
