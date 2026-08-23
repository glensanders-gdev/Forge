# Handoff: Skill naming — collision policy and verb-first convention

**Stream:** `skill-naming`
**Status:** Closed
**Last updated:** 2026-08-23 03:40
**Session type:** Ad Hoc (framework — name-collision policy, then the verb-first sweep)
**Prepared by:** `/handoff skill-naming --close`: the stream's whole scope shipped and merged
**Touches:** `global/.claude/skills/write-a-skill/`, `global/.claude/skills/skill-health/`, `global/.claude/skills/manifest.json`, `docs/adr/`

> **Closed.** Everything this stream carried is on `main`. Archived per `STREAMS.md`; the register
> row is dropped. Nothing here is a resume point — it is the record of what the stream delivered.

---

## Current Ticket

No kanban ticket — framework work is backlog-driven (`docs/kanban.md` board archived 2026-06-01).
**Final phase:** shipped and merged.

---

## What The Stream Delivered

| Version | Change | PR |
|---|---|---|
| v3.27.0 | Name-collision policy — `RESERVED-NAMES.md`, `/write-a-skill` 1.4.0, `/skill-health` 1.1.0 | [#50](https://github.com/glensanders-gdev/Forge/pull/50) |
| — | ADR-0002 — action skills verb-first, state skills keep noun shape | [#52](https://github.com/glensanders-gdev/Forge/pull/52) |
| v4.0.0 | 26 action skills renamed verb-first | [#52](https://github.com/glensanders-gdev/Forge/pull/52) |
| v4.1.0 | `manifest.json` the sole source of a skill's version | [#53](https://github.com/glensanders-gdev/Forge/pull/53) |
| v4.1.2 | `/skill-health` reads the frontmatter block only, not the whole file | [#54](https://github.com/glensanders-gdev/Forge/pull/54) |

Both of the stream's opening questions are answered and recorded, so neither needs re-deciding:

- **The collision check exists and blocks with a human override.** The list is stale by
  construction, so a hard block on it would refuse names the vendor has since released.
- **The verb-first convention reaches every action skill.** The cheaper review-family-only option
  was recommended on cost grounds and rejected; both the recommendation and the rejection are in
  ADR-0002 § Options Considered, so the trade-off does not have to be reconstructed.

Key artifacts — read these rather than this file:

- `global/.claude/skills/write-a-skill/RESERVED-NAMES.md` — the reserved-name inventory, its
  verification stamp, and the refresh procedure
- `docs/adr/0002-verb-first-action-skill-names.md` — the convention, its rejected alternatives,
  the full 26-name mapping and the costs accepted
- `global/.claude/CHANGELOG.md` — v3.27.0 through v4.1.2 carry the reasoning

---

## Next Action

**None — the stream is closed.** Its successor work is listed under Follow-on below and belongs to
other streams or to the backlog, not to this one.

---

## Follow-on Work — not part of this stream

1. **The convention check in `/write-a-skill`** was deliberately deferred until after the sweep,
   because enforcing it earlier would have failed on 26 non-compliant skills. The portfolio now
   complies, so it is unblocked: check action-vs-state shape and verb position at authoring time,
   beside the existing reserved-name gate.
2. **`RESERVED-NAMES.md` carries no Claude Code version** — `claude` was not on `PATH` on the
   authoring machine, so the stamp records that rather than guessing. The first refresh fills it in;
   the procedure is in the file.
3. **`graphify-out/` is a stale generated snapshot** dated 2026-06-06, deliberately excluded from
   the rename sweep because rewriting a dated record would falsify it. Regenerate via `/graphify`
   when it is next needed.
4. **`ai-requirements` is stale** — its register row still targets `3.26.0`, which no longer means
   anything against a `main` at 4.1.2. Not corrected here: `/handoff` edits only its own stream's
   row. That stream needs its own refresh before anyone resumes it.

---

## Context Worth Keeping

- **A rename has no soft landing.** The old name stops resolving the day it lands, and a
  deprecation stub does not help because the stub sits at the shadowed name too. This is why the
  authoring-time check was worth building and why every rename takes a major version.
- **Absence from the reserved list is not proof a name is free** — it is unchecked against a list
  stamped on a date. `/skill-health` is written to say exactly that and should keep saying it.
- **Historical records were not rewritten** during the sweep — past CHANGELOG entries, README
  version-history rows, prior ADRs, DEVLOG and handoffs record what shipped at the time. Keep that
  rule if the convention triggers further renames.
- **Four defects were found by verifying rather than trusting**, three of them outside this
  stream's own work: the parity gate reported one failure out of many, the Codex build rewrote
  `Claude Code` into false claims about Codex, `graphify` declared a name its directory did not
  use, and the new `version:` check would have flagged `update-forge` as dirty when it was clean.
  All four are fixed and merged.
- **Two defects were in this stream's own sweep tooling** — an exclusion list matching `README.md`
  as a substring, and a boundary regex skipping compound identifiers. Both were caught by
  re-grepping for old names after the pass rather than assuming it had worked.

---

## Blockers

_None._

---

## Suggested Skills for Next Session

1. `/standup` — this stream is closed and `ai-requirements` is the only row left; a fresh session
   should orient rather than resume
2. `/handoff ai-requirements` — refresh that stream before anyone picks it up; its next action
   names a version number that no longer exists
3. `/write-a-skill` — if the follow-on convention check is taken up, it is the skill that gains it
