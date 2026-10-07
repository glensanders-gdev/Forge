# Handoff: write-ord 3.0.0 — business-focused ORD

**Stream:** `write-ord`
**Status:** Active
**Last updated:** 2026-10-07 12:40
**Session type:** Ad Hoc
**Prepared by:** /debrief
**Touches:** `global/.claude/skills/write-ord/` · `global/.claude/standards/requirements/` · `global/.claude/skills/{review-ord,write-ac,testplan,write-reqs,write-brd}/` · `plugins/forge-codex/` · `dist/forge-standalone/`

---

## Current Ticket

**write-ord 3.0.0 (v4.17.0)** `[HITL]` — ad hoc, not on kanban
Status: In Progress — [PR #93](https://github.com/glensanders-gdev/Forge/pull/93) open from `write-ord-3.0.0`; Auto-fix on
**Current phase:** Critique fixes before merge — Session 1

---

## What Just Happened

Restructured `/write-ord` from field feedback into an 18-section business-focused ORD (Executive
Summary first, executive-altitude register, §13 Business Rules Appendix in every ORD, §14 Reporting
Requirements Appendix, separate decision / assumption / dependency / related-initiative / referred
registers, §5.2 MoSCoW-KPP-Status definitions). Split REFERENCE.md into REFERENCE / TAXONOMY /
ELICITATION / TEMPLATE. Test-ran Phase 1 and Phase 2 on a synthetic transcript; the companion
reconciled. Two `/critic` passes produced the findings below.

Key artifacts updated this session:
- `global/.claude/skills/write-ord/{SKILL,REFERENCE,TAXONOMY,ELICITATION,TEMPLATE}.md` — restructure
- `global/.claude/standards/requirements/{tables,reporting}.md` — schemas
- `global/.claude/CHANGELOG.md` · `skills/manifest.json` — v4.17.0

Commits on the branch: `eadf174` (restructure + split), `ddfc79f` (§5.2 definitions) — both pushed;
`72fea7d` (fold §14.5 into §14.4) — **committed, not pushed, awaiting the user's yes**.

---

## Next Action

All eleven critic findings are fixed. Merge PR #93 once CI is green — the user's call — then tag
v4.17.0. One small follow-up remains: `llm_companion.py`'s built-in vocabulary has no entries for
the rule statuses `Confirmed` and `Unresolved`, so a companion lists them undefined.

---

## Context the Next Session Will Need

**Critic findings — the stream's remaining work, in fix order:**

| # | Pri | Finding | Fix |
|---|---|---|---|
| 1 | ~~P1~~ Done 2026-10-07 | `/review-ord` keys on "write-ord 3.x" in the Conformance line; the template never writes it | Literal marker in TEMPLATE.md header; review-ord matches it |
| 2 | ~~P1~~ Done 2026-10-07 | §13 is "how decisions are made" but `tables.md` § *Business rule* still bans decision logic (DMN bullet, line ~187) | Add a `Rule` column beside `Required Decision`; reword the DMN bullet |
| 3 | ~~P2~~ Done 2026-10-07 | TAXONOMY.md "ORD relevance" notes steer to technical targets (RTO/RPO, encryption standards, hosting model, protocol standards) | Rewrite each as the business tolerance to look for |
| 4 | ~~P2~~ Done 2026-10-07 | `[D-TBD]` placeholders are uncitable | Numbered `[D-TBD-1]` until `/raid` mints |
| 5 | ~~P2~~ Done 2026-10-07 | BRL status (Confirmed/Provisional/Unresolved) undefined in §5.2 | Add to the §5.2 definitions in `tables.md` |
| 6 | ~~P2~~ Done 2026-10-07 | `/write-ac` and `/testplan` read only §17/§11 — 2.x ORDs (Appendix D/A) unhandled | One-line 2.x fallback in each |
| 7 | ~~P2~~ Done 2026-10-07 | Executive-altitude test has one worked example | Add 2–3 before/after pairs from the reporting class map |
| 8 | ~~P3~~ Done 2026-10-07 | `tables.md` says `/write-prd` may assign `BRL-NNN`; write-prd never mentions it | Drop the claim or make it true |
| 9 | ~~P3~~ Done 2026-10-07 | §5.2 boilerplate emitted as 8 records into every LLM companion | Treat §5.2 as context |
| 10 | ~~P3~~ Done 2026-10-07 | `language.md` Voice-by-Altitude ORD row still says Requirement/Threshold columns | Align with the register schema |
| 11 | ~~P3~~ Done 2026-10-07 | SKILL.md Phase 2 steps numbered 6, 6a, 7, 8, 8a, 9 | Renumber |

- The Skill tool served the cached 2.2.1 text in this session; follow the on-disk 3.0.0 files until
  a new session.
- Test ORD and companion (synthetic, fictional Harbourline Water) are in this session's scratchpad
  only — not in the repo. Regenerate from `/write-ord` on any synthetic transcript if needed.
- The pack's ORD template is unchanged; 3.0.0 is a declared deviation (REFERENCE.md §
  *Deviations*). Raising it to the pack is the user's call.
- A separate background session is fixing `llm_companion.py` view detection for wrapped view notes
  (it folded §7.13 instead of omitting it). It touches `write-ord/scripts/` and will bump write-ord's
  patch version — rebase this branch onto it, or vice versa, before merge.

---

## Open Decisions

- Whether to raise the 3.0.0 structure to the requirements-documents pack — user.

---

## Blockers

_None._ Merge waits on the two P1 fixes, CI and review.

---

## Suggested Skills for Next Session

1. `/pickup write-ord` — resume at the push confirmation and P1-1.
2. `/review-ord` on the regenerated test ORD after P1-1 — proves the gate now reads a 3.0.0 ORD.
