---
name: "forge-init"
description: "Initialize Forge for Codex by creating its data directories and proposing concise global AGENTS.md guidance. Use after plugin installation or when global Forge configuration changes."
metadata:
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Forge Init

Initialize Forge without duplicating plugin skills or bloating Codex's global instructions.

## Process

1. Create missing user-owned directories under `~/.codex/forge/`: `companies/`, `ideas/`, `instincts/`, `knowledge/`, `pi/`, `sprints/`, and `tokens/`.
2. Seed `preferences.md` and registry files from plugin references only when absent.
3. Read existing `~/.codex/AGENTS.md` if present.
4. Propose a short Forge section that states:
   - use Forge skills for structured delivery workflows
   - consequential actions require explicit human confirmation
   - global Forge data lives under `~/.codex/forge/`
   - project guidance belongs in the closest `AGENTS.md`
5. Show the exact proposed change and wait for confirmation before editing `~/.codex/AGENTS.md`.
6. Report what was created and what was preserved.

## Rules

- Never copy plugin skills into `~/.codex/forge/`.
- Never overwrite user-owned files.
- Never replace the full global `AGENTS.md`; merge a concise Forge section.
