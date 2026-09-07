# Handoffs: Forge Framework

**Last updated:** 2026-09-07 20:55
**Register version:** 2

Pointer rows only — each stream's handoff lives at `docs/handoffs/<slug>.md`. Schema, resolution
rules, lifecycle and the conflict guard are specified in `~/.claude/skills/handoff/STREAMS.md`.

| Stream | Title | Status | Updated | Next action | Touches |
|---|---|---|---|---|---|
| `standalone-skills` | Standalone skills distribution | Active | 2026-09-07 20:55 | Publish v4.7.4 from `main` — sync-standalone-skills.sh stages, read the diff, then --push | `dist/forge-standalone/` ⚠️, `.standalone-sync/`, `glensanders-gdev/skills` (public), `global/.claude/` ⚠️, `tools/`, `plugins/forge-codex/` |

`skill-naming` (v4.1.2) and `ai-requirements` (v4.2.0) closed on 2026-08-23.

⚠️ **`dist/forge-standalone/`, `global/.claude/` and `plugins/forge-codex/` collide with the
`requirements-pack` stream**, Active in the workspace register at `../docs/HANDOFF.md`. Its sessions
wrote all three across v4.7.0–v4.7.4. Neither stream owns them alone — check the other register
before writing any of these paths.

Closed streams are archived to `docs/handoffs/archive/`. The pre-v3.24.0 single-document handoff is
at `docs/handoffs/archive/2026-06-19-forge-framework.md`.
