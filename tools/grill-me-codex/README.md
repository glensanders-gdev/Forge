# grill-me-codex — Standalone Tool

Two-act plan hardening: Claude grills you until intent is locked (Act 1), then Codex adversarially reviews the plan in a read-only sandbox until approved (Act 2). Not part of the Forge framework — opt-in only.

## Prerequisites

- OpenAI Codex CLI installed (`codex --version` ≥ 0.130) and authenticated (`codex login`)
- Claude Code

## Usage

Point Claude at this skill manually:

> "Read `tools/grill-me-codex/SKILL.md` and run grill-me-codex on [your task]."

Or copy `SKILL.md` into a project's `.claude/skills/grill-me-codex/` if you want `/grill-me-codex` as a slash command there.

## Related tools

- `tools/codex-review/` — Act 2 only, for when you already have a locked plan
- `/grill-me` (Forge) — Act 1 only, for when Codex is not available
