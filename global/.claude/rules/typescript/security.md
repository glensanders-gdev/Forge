# TypeScript Security

> This file extends [common/security.md](../common/security.md) with TypeScript specific content.

> **Starter stub** — scaffolded by /lang-rules 2026-06-11. Review and extend.

## Dependencies

- Run `npm audit` (or `osv-scanner`) in CI; fail the build on high/critical vulnerabilities.
- Pin via lockfile and commit it; review `postinstall` scripts of new dependencies before adopting.

## Secrets & Config

- Secrets come from environment variables only; validate required env at startup with a Zod schema — fail fast with a clear error (extends the common fail-fast rule).
- Never commit `.env` files; commit `.env.example` with placeholder keys instead.

## Untrusted Input

- Never `eval()`, `new Function()`, or dynamic `import()` on external input (common rule, restated because JS makes it easy).
- `JSON.parse` output is `unknown` in spirit — always parse external JSON through a Zod schema before use.
