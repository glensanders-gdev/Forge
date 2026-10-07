# Handoff: Style Manual adoption for requirements documents

**Stream:** `style-manual`
**Status:** Active
**Last updated:** 2026-10-07 15:55
**Session type:** Ad Hoc
**Prepared by:** /debrief: push branch 2, then assimilate batch 3
**Touches:** `global/.claude/standards/requirements/`, `global/.claude/skills/write-{brd,ord,prd}/`, `global/.claude/skills/manifest.json`, `global/.claude/CHANGELOG.md`, `plugins/forge-codex/`, `dist/forge-standalone/`

---

## Current Ticket

**Ad hoc — Australian Government Style Manual adoption** `[HITL]`
Status: In Progress. Batches 1 and 2 are done, and batch 2 is committed but not pushed.
**Current phase:** Assimilation — Session 1 of this phase

---

## What Just Happened

Batch 1 (voice and tone, sentences, plain language, the 7 grammar pages that matter, and an
overridable locale) merged as PR #97, v4.17.1. Batch 2 (`/assimilate` of *Structuring content*
and *Referencing and attribution*) is committed as `179b2ff` on `docs/style-manual-structure-referencing`,
v4.17.2. It adds the document-structure rules, a reference list in every requirements document,
and citation forms.

Key artifacts updated this session:
- `global/.claude/standards/requirements/language.md` — style
- `global/.claude/standards/requirements/tables.md` — structure
- `global/.claude/skills/write-ord/TEMPLATE.md` — references
- `global/.claude/skills/write-brd/STANDARD.md` — references
- `global/.claude/skills/write-prd/SKILL.md` — references

---

## Next Action

From the worktree `Forge/.claude/worktrees/style-manual-structure`, summarise the push of
`docs/style-manual-structure-referencing` (1 commit for the change, 1 for this debrief), get
confirmation, push, open the PR, and merge on green CI.

---

## Context the Next Session Will Need

- **Batch 3 for `/assimilate`**, after the PR merges and from a fresh branch off `origin/main`.
  These grammar sub-pages were never evaluated:
  - Latin shortened forms (`e.g.`, `i.e.`)
  - abbreviations and contractions
  - common misspellings and word confusion
  - hyphens, dashes, colons and quotation marks (the templates use em dashes heavily)
  - names and terms (government and organisation names)
  - inclusive language
  The other grammar sub-pages were judged not worth reading. Pages already applied are not
  re-assimilated.
- **Decisions already made:** fixed labels keep title case, register cells date `yyyy-mm-dd`,
  locale is overridable with Australian as the default, author–date with no footnotes, ORD §4.5
  is the reference list (18 sections unchanged), BRD Appendix B, PRD § References.
- The pages are fetched with `curl` and text extraction, because WebFetch timed out on
  stylemanual.gov.au.
- `review-brd/CRITERIA.md` holds an older copy of the BRD worked example's gate table. It is
  generated from the locally held requirements pack, so it was left alone.
- Six BRD handoff-gate example cells still have sentences over 25 words. They were left alone so
  their meaning does not shift.

---

## Open Decisions

_None_

---

## Blockers

_None_

---

## Suggested Skills for Next Session

1. `/pickup style-manual` — resume here.
2. `/assimilate` — batch 3, with the URLs listed above.
