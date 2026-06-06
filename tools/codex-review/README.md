# codex-review — Standalone Tool

Adversarial two-model plan review loop. Not part of the Forge framework — opt-in only.

## Prerequisites

- OpenAI Codex CLI installed (`codex --version` ≥ 0.130) and authenticated (`codex login`)
- Claude Code

## Usage

Point Claude at this skill manually when you want the cross-model review:

> "Read `tools/codex-review/SKILL.md` and run codex-review on my current plan."

Or copy `SKILL.md` into a project's `.claude/skills/codex-review/` if you want `/codex-review` as a slash command there.

## Why standalone?

Not every user has Codex CLI or a ChatGPT account. This tool only makes sense when both Claude and Codex are available and the plan is high-stakes enough to warrant a second-model adversarial check.
