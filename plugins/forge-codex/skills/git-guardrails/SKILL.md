---
name: "git-guardrails"
description: "Install or verify Codex PreToolUse hooks that block dangerous git commands. Use when the user wants hard git safety enforcement at plugin, project, or user scope."
metadata:
  category: code-quality
  origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills) and Glen Sanders (Forge)
---

# Git Guardrails

Codex loads hooks from plugins, `~/.codex/hooks.json`, and trusted project `.codex/hooks.json` files. This plugin already bundles a guardrail in `hooks/hooks.json`.

## Process

1. Check whether the bundled plugin hook is enabled and trusted.
2. If the user wants project or user scope, merge an equivalent `PreToolUse` entry into the selected `hooks.json`; never replace unrelated hooks.
3. Use `commandWindows` for the PowerShell script and `command` for the shell script.
4. Verify by piping a sample payload containing `git push origin main` into the chosen script.
5. Confirm the result contains `permissionDecision: deny`.
6. Tell the user to review changed hooks with `/hooks`.

## Blocked Commands

- `git push`
- `git reset --hard`
- `git clean -f` and `git clean -fd`
- `git branch -D`
- `git checkout .`
- `git restore .`

## Rules

- Never overwrite unrelated hooks.
- Never claim the guardrail is active until the script returns a deny response.
- Never treat hooks as a complete security boundary.
- Never block additional commands without explicit user approval.
