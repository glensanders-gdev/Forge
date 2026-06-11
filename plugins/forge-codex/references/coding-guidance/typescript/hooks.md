# TypeScript Hooks

> This file extends [common/quality-checklist.md](../common/quality-checklist.md) with TypeScript specific content.

> **Starter stub** — scaffolded by $lang-rules 2026-06-11. Review and extend. Hooks must be configured in settings.json to take effect — these are the recommended commands.

## Recommended PostToolUse Hooks (Edit/Write on *.ts)

| Tool | Command | Purpose |
|------|---------|---------|
| Prettier | `npx prettier --write <file>` | Formatting — never hand-format |
| ESLint | `npx eslint --fix <file>` | Lint + autofix (typescript-eslint, no-floating-promises) |
| tsc | `npx tsc --noEmit` | Type check (project-wide; run on stop or pre-commit, not per-edit) |

## Pre-commit

- `npx tsc --noEmit && npx vitest run` as the minimum pre-commit gate.
- Never bypass with `--no-verify` (common git-safety rule applies).
