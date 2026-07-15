# Forge for Codex

Codex-native adaptation of [glensanders-gdev/Forge](https://github.com/glensanders-gdev/Forge).

This plugin packages the complete Forge `3.18.0` skill portfolio from this repository and adapts it for Codex:

- reusable workflows are invoked as `$skill-name`
- global Forge data lives under `~/.codex/forge/`
- durable project guidance uses `AGENTS.md`
- project-specific Forge skills belong under `.agents/skills/`
- Claude command stubs are omitted because Codex discovers skills directly
- a path-independent Codex `PreToolUse` git guardrail is bundled in `hooks/hooks.json`

Start with `$forge-codex`, `$commands`, or `$onboard`.

See [ADAPTATION.md](ADAPTATION.md) for compatibility decisions and known limitations.

## Install

```bash
codex plugin marketplace add glensanders-gdev/Forge
codex plugin add forge-codex@forge
```

Start a new Codex thread after installation.
