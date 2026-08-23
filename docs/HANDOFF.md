# Handoffs: Forge Framework

**Last updated:** 2026-08-23 03:40
**Register version:** 2

Pointer rows only — each stream's handoff lives at `docs/handoffs/<slug>.md`. Schema, resolution
rules, lifecycle and the conflict guard are specified in `~/.claude/skills/handoff/STREAMS.md`.

| Stream | Title | Status | Updated | Next action | Touches |
|---|---|---|---|---|---|
| `ai-requirements` | AI as the subject of a requirement | Blocked | 2026-08-22 12:05 | Rebase `claude/ai-requirements-ruleset` onto `main`, renumber 3.25.0 → 3.26.0 | `rules/requirements/ai.md`, `CHANGELOG.md`, `README.md`, `skills/manifest.json` ⚠️ |

⚠️ `ai-requirements` writes `global/.claude/skills/manifest.json`. The collision that warning
recorded is gone — `skill-naming` closed 2026-08-23 — but the path is still shared with any new
stream that touches skill versions.

Closed streams are archived to `docs/handoffs/archive/`. The pre-v3.24.0 single-document handoff is
at `docs/handoffs/archive/2026-06-19-forge-framework.md`.
