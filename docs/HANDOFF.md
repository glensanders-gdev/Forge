# Handoffs: Forge Framework

**Last updated:** 2026-08-22 12:05
**Register version:** 2

Pointer rows only — each stream's handoff lives at `docs/handoffs/<slug>.md`. Schema, resolution
rules, lifecycle and the conflict guard are specified in `~/.claude/skills/handoff/STREAMS.md`.

| Stream | Title | Status | Updated | Next action | Touches |
|---|---|---|---|---|---|
| `skill-naming` | Skill naming — collision policy and verb-first convention | Active | 2026-08-22 12:05 | Add the built-in name-collision check to `/write-a-skill` and `/skill-health` | `skills/write-a-skill/`, `skills/skill-health/`, `skills/manifest.json` ⚠️ |
| `ai-requirements` | AI as the subject of a requirement | Blocked | 2026-08-22 12:05 | Rebase `claude/ai-requirements-ruleset` onto `main`, renumber 3.25.0 → 3.26.0 | `rules/requirements/ai.md`, `CHANGELOG.md`, `README.md`, `skills/manifest.json` ⚠️ |

⚠️ Both streams write `global/.claude/skills/manifest.json` (`forge_version` and skill versions).
Whichever lands second rebases; do not edit the version in both at once.

Closed streams are archived to `docs/handoffs/archive/`. The pre-v3.24.0 single-document handoff is
at `docs/handoffs/archive/2026-06-19-forge-framework.md`.
