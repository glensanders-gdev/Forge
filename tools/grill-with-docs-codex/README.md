# grill-with-docs-codex — Standalone Tool

Two-act plan hardening with domain awareness. Act 1 grills you against `CONTEXT.md`, ADRs, and the codebase — updating living docs inline. Act 2 has Codex adversarially review the locked plan with domain context, catching language mismatches as well as structural flaws. Not part of the Forge framework — opt-in only.

## Prerequisites

- OpenAI Codex CLI installed (`codex --version` ≥ 0.130) and authenticated (`codex login`)
- Claude Code
- A project with (or ready to create) `docs/CONTEXT.md`

## Usage

Point Claude at this skill manually:

> "Read `tools/grill-with-docs-codex/SKILL.md` and run grill-with-docs-codex on [your task]."

## Related tools

- `tools/codex-review/` — Act 2 only, for when you already have a locked plan
- `tools/grill-me-codex/` — same two-act structure without domain awareness (no CONTEXT.md required)
- `/grill-with-docs` (Forge) — Act 1 only, for when Codex is not available
