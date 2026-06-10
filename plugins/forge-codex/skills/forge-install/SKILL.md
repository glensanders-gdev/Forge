---
name: "forge-install"
description: "Install or verify the Forge for Codex plugin through a Codex marketplace. Use when Forge is unavailable, a new device needs setup, or the user wants to verify plugin discovery."
metadata:
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Forge Install

Install or verify Forge using Codex plugin mechanics. Never run upstream Forge's Claude-oriented `install.sh`.

## Process

1. Check whether `$forge-codex` and `$commands` are available.
2. If available, report that the plugin is installed and validate the plugin manifest and skill count.
3. If unavailable and a local marketplace exists, inspect it and install or refresh the marketplace using `codex plugin marketplace add` only when the marketplace is non-default.
4. Ask the user to restart Codex or open a new thread after installation.
5. Run `$forge-init` only when the user wants global Forge guidance and data initialized.

## Rules

- Never create junctions under `~/.claude/` or `~/.codex/`.
- Never overwrite an existing marketplace entry without confirmation.
- Never claim installation succeeded until Codex can discover a Forge skill.
