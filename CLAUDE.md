# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

Forge is a skill/workflow framework for Claude Code and Codex. It ships as:
- **Claude Code** — skills in `global/.claude/skills/`, commands in `global/.claude/commands/`
- **Codex plugin** — generated output committed to `plugins/forge-codex/`

`install.sh` symlinks `~/.claude/skills/`, `~/.claude/commands/`, and `~/.claude/rules/` directly into `global/.claude/`. Edits in `~/.claude/` are edits to this repo — no copy step.

## Key Commands

```bash
# Install (creates symlinks from ~/.claude/ into this repo)
bash install.sh

# Update after git pull
bash update.sh

# Regenerate Codex plugin after changing shared skills
./tools/build-forge-codex.ps1          # PowerShell / Windows

# Verify Codex plugin is not stale and Claude/Codex are in parity
./tools/test-forge-parity.ps1          # PowerShell / Windows
```

CI (`forge-parity.yml`) runs on every push/PR and fails if:
1. The Codex plugin output is stale (not committed after a shared skill change)
2. Claude and Codex skill parity checks fail

## Architecture

```
global/.claude/         ← source of truth for all shared skills
  skills/               ← one folder per skill; each contains SKILL.md + assets
  commands/             ← one .md per skill, command entry points
  rules/common/         ← language-agnostic coding standards (always active)
  rules/[lang]/         ← language-specific rule sets, installed via /lang-rules
  manifest.json         ← version registry for all 104 skills
  SOUL.md               ← agent identity and behavioural constraints
  PRINCIPLES.md         ← design philosophy; read before writing a new skill

plugins/forge-codex/    ← generated Codex plugin (committed, do not edit manually)
tools/
  build-forge-codex.ps1           ← generates plugins/forge-codex/ from global/.claude/
  test-forge-parity.ps1           ← enforces Claude/Codex skill parity
  update-forge-codex-overrides.ps1 ← reviews Codex-native overrides when shared source changes

project-template/       ← scaffold copied into consumer projects (not used by Forge itself)
docs/                   ← Forge's own DEVLOG, kanban, and PRD history
```

## Skill Authoring Rules

Each skill lives at `global/.claude/skills/[skill-name]/SKILL.md`. Before writing or editing a skill, read `global/.claude/PRINCIPLES.md`. Key constraints:

- Every skill must declare a human gate (`[HITL]`) or autonomous mode (`[AFK]`) — never leave execution mode implicit
- Every skill must have explicit "never" rules (negative space), not just positive instructions
- Consequential or irreversible actions require a typed confirmation (`CONFIRM`, `APPROVE`, `GO`, or `ROLLBACK [version]`)
- Skills must reference artifacts by path — never reproduce content that lives elsewhere
- Size each skill to fit in a single context window (~100k tokens smart zone); if it can't, it needs a `/break-down` path

After changing any shared skill, run `build-forge-codex.ps1` and commit the output before pushing. If the changed skill has a Codex-native override, run `update-forge-codex-overrides.ps1 -ConfirmReview` after reviewing the diff.

## Windows Shell Convention

When `install.sh` or any script needs Windows-specific operations, use `powershell -NoProfile -Command "..."` not `cmd.exe /c`. To detect whether a path is a junction (not a real directory), check for the `ReparsePoint` attribute — `test -d` returns true for both real dirs and junctions on Windows.

## Versioning

Framework version is in `global/.claude/skills/manifest.json` under `forge_version`. Bump this on any release. Both Claude Code and Codex share the same version line.
