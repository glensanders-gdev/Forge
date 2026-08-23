# Handoff: AI as the subject of a requirement

**Stream:** `ai-requirements`
**Status:** Closed
**Last updated:** 2026-08-23 04:50
**Session type:** Ad Hoc (requirements ruleset)
**Prepared by:** stream close — the rebase and renumber completed and merged as v4.2.0
**Touches:** `global/.claude/rules/requirements/ai.md`, `global/.claude/CHANGELOG.md`, `README.md`, `global/.claude/skills/manifest.json`, `docs/adr/`

> **Closed.** Everything this stream carried is on `main`. Archived per `STREAMS.md`; the register
> row is dropped. Nothing here is a resume point — it is the record of what the stream delivered.

---

## Current Ticket

No kanban ticket — ad-hoc. Shipped and merged.

---

## What The Stream Delivered

| Version | Change | PR |
|---|---|---|
| v4.2.0 | AI as the subject of a requirement — `rules/requirements/ai.md`, the evaluative criterion form, `EVL-NNN` / `MDL-NNN`, ADR-0003 | [#57](https://github.com/glensanders-gdev/Forge/pull/57) |

The ruleset is the third shared one and the first **conditional** one: it applies on top of
`language.md` and `tables.md` when a delivered component's behaviour is learned or generated rather
than specified, and relaxes neither. `/write-prd` 2.7.0, `/write-ord` 1.5.0, `/write-ac` 1.5.0,
`/write-reqs` 1.3.0 and `/write-brd` 1.1.0 cite it.

Key artifacts — read these rather than this file:

- `global/.claude/rules/requirements/ai.md` — the ruleset itself
- `docs/adr/0003-ai-requirements-extend-the-pack.md` — why AI requirements extend the pack rather
  than forming a fourth document, and the ISO/IEC 25059 watch item
- `global/.claude/CHANGELOG.md` — the v4.2.0 entry carries the reasoning

---

## What The Rebase Corrected

The branch sat unpushed while `skill-naming` shipped v3.27.0 through v4.1.2, so three things had
gone stale that a clean apply would not have surfaced. Recorded because the same trap applies to
any long-parked branch:

- **ADR number collision.** This stream's ADR claimed `0002`; v4.0.0 took that number for the
  verb-first skill renames. The two have different filenames, so git reported no conflict and both
  would have landed as ADR-0002. Renumbered to **ADR-0003** with every reference in `ai.md`,
  `tables.md`, the requirements README and the CHANGELOG.
- **Frontmatter version bumps had nowhere to land.** v4.1.0 made `manifest.json` the sole source of
  a skill's version and deleted the `version:` field this branch bumped in five `SKILL.md` files.
  The bumps moved into the manifest, each layered on the patch level `main` had reached.
- **The release renumbered twice.** The stream's own note called for 3.26.0; `main` was at 4.1.2 by
  the time the rebase ran, so it shipped as **4.2.0**.

Generated `plugins/forge-codex/` conflicts were resolved by re-running `tools/build-forge-codex.ps1`,
never by hand — as the pre-rebase note instructed. `pwsh` is available on macOS via Homebrew.

---

## Next Action

**None — the stream is closed.**

---

## Open Decisions

_None._

---

## Blockers

_None._ The stream was parked behind `skill-naming` by choice; that stream closed 2026-08-23 and
this one followed the same day.
