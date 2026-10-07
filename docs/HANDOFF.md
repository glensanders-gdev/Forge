# Handoffs: Forge Framework

**Last updated:** 2026-10-07 16:00
**Register version:** 2

Pointer rows only — each stream's handoff lives at `docs/handoffs/<slug>.md`. Schema, resolution
rules, lifecycle and the conflict guard are specified in `~/.claude/skills/handoff/STREAMS.md`.

| Stream | Title | Status | Updated | Next action | Touches |
|---|---|---|---|---|---|
| `style-manual` | Style Manual adoption for requirements documents | Active | 2026-10-07 16:00 | `/assimilate` Style Manual batch 3 from a fresh branch off `origin/main` | `global/.claude/standards/requirements/`, `global/.claude/skills/write-*`, `plugins/`, `dist/` |

**One Active stream.** `write-ord` was opened and closed on 2026-10-07 — v4.17.0 released
(`docs/handoffs/archive/2026-10-07-write-ord.md`). Earlier closed streams: `correction-standards`
(2026-09-27), `standalone-skills` (2026-09-07), `skill-naming` and `ai-requirements` (2026-08-23).

Work on this repository is currently driven from the **workspace register** at `../docs/HANDOFF.md`,
where `requirements-pack` is Active and writes `global/.claude/`, `dist/forge-standalone/` and
`plugins/forge-codex/`. **Open a stream here before taking up Forge-repo work that is not the
requirements pack's** — the collision warning this register used to carry is gone because the stream
it warned about is gone, not because the paths stopped being shared.

Closed streams are archived to `docs/handoffs/archive/`. The pre-v3.24.0 single-document handoff is
at `docs/handoffs/archive/2026-06-19-forge-framework.md`.
