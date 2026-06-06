# Handoff: Forge Framework Development

**Last updated:** 2026-05-22
**Session type:** Build
**Prepared by:** $handoff

---

## Current Ticket

**Forge v2.3.7 — Active development**
Status: In Progress — no single active ticket, framework-level iteration
**Current phase:** Framework maintenance — ongoing

---

## What Just Happened

Extended the Forge framework across a long session covering: P2/P3 critic fixes, new skills ($pii-check, $onboard, $pi-end, $build, $deploy, $deploy-pi, $rollback, $rollback-pi, $save-state, $estimate, $token-report, $lookup, $handoff, $add-term), AGENTS.md split into reference files, known-issues.md, unique ID system (IDEA/PROJ/TC-NNN), token recording across all 11 phases, sequence diagram updates, Confluence documentation, and PRINCIPLES.md.

Key artifacts updated this session:
- `forge/global.codex/forge/skills/manifest.json` — v2.3.7, 51 skills
- `forge/global.codex/forge/CHANGELOG.md` — full version history v1.0.0 through v2.3.7
- `forge/global.codex/forge/PRINCIPLES.md` — 8 Forge design principles (new)
- `forge/global.codex/forge/registry.md` — global ID registry (new)
- `forge/global.codex/forge/tokens/ledger.md` — global token ledger (new)
- `forge/project-template/AGENTS.md` — split to ~186 lines, references 4 on-demand files
- `forge/project-template.codex/forge/CODING-STANDARDS.md` — extracted from AGENTS.md (new)
- `forge/project-template.codex/forge/ERROR-HANDLING.md` — extracted from AGENTS.md (new)
- `forge/project-template.codex/forge/SECURITY.md` — extracted from AGENTS.md (new)
- `forge/project-template.codex/forge/TESTING.md` — extracted from AGENTS.md (new)
- `forge/project-template/docs/known-issues.md` — project-level issue tracking (new)
- `forge/project-template/docs/tests/registry.md` — TC-NNN + KI-NNN registry (new)
- `forge/project-template/docs/tokens/_template.md` — per-feature token record (new)
- `forge/global.codex/forge/knowledge/company/context.md` — company domain concepts (new)
- `forge-confluence.md` — Confluence page with 9 sections (output)
- `forge-sequence-v4.mmd` — updated sequence diagram (output)

---

## Next Action

No immediate blocking tasks. Recommended next steps in priority order:

1. **Run `critic`** — the framework has grown significantly and a fresh P1/P2 sweep is warranted before the next major feature
2. **Address P3 items** from previous critics that remain unresolved (see backlog)
3. **Deploy Forge to a real project** — the framework is production-ready; real usage will surface gaps that design review cannot
4. **Backlog item:** cross-project prioritisation framework discussion (P3, `~/.codex/forge/backlog.md`)

---

## Open Decisions

None — all grilled items have been fully resolved and implemented.

---

## Blockers

None.

---

## Suggested Skills for Next Session

1. `critic` — the framework hasn't had a fresh critique since v2.3.5 and is now at v2.3.7 with significant additions
2. `backlog-list` — review what's accumulated in the global backlog
3. `idea` — if starting a real project, this is the entry point

---

## Framework State Summary

| Metric | Value |
|--------|-------|
| Forge version | 2.3.7 |
| Skills | 51 |
| Commands | 52 |
| Pipeline phases | 8 (Ideation → Deploy) |
| Token phases recorded | 11 |
| Reference files | 4 (CODING-STANDARDS, ERROR-HANDLING, SECURITY, TESTING) |
| Design principles | 8 (PRINCIPLES.md) |
| Confluence sections | 9 |
| Sequence diagram | v4 |

Forge zip: `/mnt/user-data/outputs/forge.zip`
Confluence page: `/mnt/user-data/outputs/forge-confluence.md`
Sequence diagram: `/mnt/user-data/outputs/forge-sequence-v4.mmd`
