# Handoff: BRD readiness — business definition, readiness projection and the path to readiness

**Stream:** `brd-readiness`
**Status:** Closed 2026-10-26 — everything merged; Forge v4.25.0 → v4.27.2, requirements pack v1.17 → v1.19
**Last updated:** 2026-10-26
**Session type:** Ad Hoc
**Prepared by:** /debrief (stream opened and closed at debrief)
**Touches:** `global/.claude/skills/{review-brd,review-ord,write-ac,write-brd,write-ord,add-company}/` · `global/.claude/copilot/` · `tools/build-review-criteria.py` · `tools/build-forge-standalone.ps1` · `plugins/forge-codex/` · `dist/forge-standalone/` · `../requirements-documents/`

---

## Current Ticket

**BRD review enhancements** `[HITL]` — ad hoc, not on kanban
Status: Done — PRs #108, #109, #110, #111, #112 and #113 merged
**Current phase:** Closed — Session 1

---

## What Just Happened

Feedback on `/review-brd` became requirements pack v1.17–v1.19 and Forge v4.25.0–v4.27.2. A BRD review
now answers three separate questions: the handoff gate, business definition readiness (BD-1 to BD-10)
and acceptance derivability. It also projects the ORD's lead time, tier and confidence from the BRD's
readiness rating, stakeholder count, resourcing and allocation, and lays out a path to readiness.
The pack's lead-time tables were regenerated with line overhead split by allocation, and twelve
hand-applied `†` marks were corrected. Public skills no longer mention PI planning or Forge's PI
release scheme.

Key artifacts updated this session:
- `../requirements-documents/reference/brd-standard.md` — business definition, projection, path
- `../requirements-documents/reference/ord-intake-standard.md` — D1 split, S5–S7, OH-16, leave, business days
- `global/.claude/skills/review-brd/` — steps 4–7, gate protocol, regenerated criteria
- `global/.claude/skills/{review-ord,write-ac,write-ord}/` — OH-16, not safely derivable, design support
- `global/.claude/copilot/review-brd.md` — projection added; 20,000-character limit lifted
- `~/.claude/companies/nbn/calendars/AU-VIC-public-holidays.md` — Victorian holidays 2026–27 (local)

---

## Next Action

None — the stream is closed. If the review skills are extended, open a new stream.

---

## Context the Next Session Will Need

- **The pack is the source of truth.** Change `../requirements-documents/` first, run
  `tools/check-pack.py`, commit, then `tools/build-review-criteria.py` here. Never hand-edit an extract.
- **The lead-time tables are generated.** The script that reproduced and then regenerated them lived in
  this session's scratchpad and is gone. Its method is `ord-intake-standard.md` §4.3 (`round()` of
  effort hours ÷ productive hours × 5, floored at the latency floor, capped at 60) and §4.7.2.
- **Build order:** edit the changelog *before* running `build-forge-codex.ps1`. #108 failed CI because
  the plugin's copy of the changelog was built before the last edit.
- **Hand-maintained Codex overrides** (`token-report` among them) need the same edit, then
  `update-forge-codex-overrides.ps1 -ConfirmReview`.
- **The 2027 AFL Grand Final Friday** in the nbn Victorian calendar is provisional. Refresh it when
  the AFL publishes its schedule, and each December for the following year.
- Pack v1.17–v1.19 are committed in `requirements-documents`, which has no remote.

---

## Open Decisions

_None_

---

## Blockers

_None_

---

## Suggested Skills for Next Session

1. `/review-brd` — run it on a real BRD, which is the first test of the projection and the path.
2. `/skill-health` — confirm the six skills changed this session against the standards register.
