# Handoffs: Forge Framework

**Last updated:** 2026-08-24 10:27
**Register version:** 2

Pointer rows only — each stream's handoff lives at `docs/handoffs/<slug>.md`. Schema, resolution
rules, lifecycle and the conflict guard are specified in `~/.claude/skills/handoff/STREAMS.md`.

| Stream | Title | Status | Updated | Next action | Touches |
|---|---|---|---|---|---|
| `standalone-skills` | Standalone skills distribution | Active | 2026-08-24 10:27 | Fix setup.sh copying company skills into the Forge repo; then commit split, publish 4.6.1 | `global/.claude/`, `dist/forge-standalone/`, `plugins/forge-codex/`, `tools/` |

`skill-naming` (v4.1.2) and `ai-requirements` (v4.2.0) closed on 2026-08-23.

Closed streams are archived to `docs/handoffs/archive/`. The pre-v3.24.0 single-document handoff is
at `docs/handoffs/archive/2026-06-19-forge-framework.md`.
