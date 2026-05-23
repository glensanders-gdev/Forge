# Token Recording — Phase Guide

All pipeline skills record token usage automatically at phase end. This file defines the standard recording format and estimation approach.

---

## When to Record

At the natural close of each phase — when the phase produces its artifact and suggests the next stage. Record before writing DEVLOG or HANDOFF.

---

## Estimation Approach

Claude Code does not expose exact token counts. Estimate as follows:

### Input tokens
Count what was loaded into context:
- Each file read: estimate based on file type and typical size
  - `CONTEXT.md`, `HANDOFF.md`, `kanban.md`: ~1–3k each
  - Source files: ~2–8k each depending on size
  - PRD: ~3–6k
  - Research files: ~2–5k each
- Conversation history: estimate based on session length
  - Short session (<30 min): ~5–15k
  - Medium session (30–90 min): ~15–40k
  - Long session (90+ min): ~40–100k

### Output tokens
Estimate based on what was generated:
- Q&A grill (10 questions): ~3–8k
- PRD document: ~5–12k
- Code written (per ticket): ~5–20k
- Research file: ~2–5k
- Report or plan: ~3–8k

### Band derivation
- S: < 20k total
- M: 20–80k total
- L: 80–200k total
- XL: 200k+ total

---

## Recording Format

Append to `docs/tokens/[feature-name].md`. Create the file from _template.md if it doesn't exist.

```markdown
### [Phase Name]
**Date range:** YYYY-MM-DD (→ YYYY-MM-DD if multi-session)
**Sessions:** N
**Input:** ~Nk tokens — Read: [brief summary e.g. "CONTEXT.md, kanban.md, 6 source files"]
**Output:** ~Nk tokens
**Total:** ~Nk ([S/M/L/XL])
**Notes:** [optional — anything that drove unusual cost]
```

---

## Phase-Specific Notes

| Phase | Typical input drivers | Typical output drivers |
|-------|----------------------|----------------------|
| Idea | Conversation only | idea.md, diagrams |
| Grill | CONTEXT.md, ADRs, source files | Q&A, CONTEXT.md updates, ADRs |
| Research | External content, source files | research/*.md files |
| Prototype | Source files | Spike code, LOGIC.md, UI.md |
| Write PRD | Codebase exploration, research files | PRD document |
| Estimate | PRD, kanban | Estimate table |
| Testplan | PRD, testplan | testplan-*.md |
| Build | Source files, testplan, PRD | Code, tests |
| QA | qa-plan, pii-report, source | QA plan, PII report |
| Deploy | deploy.md, deploy-log | Log entries |

---

## File Initialisation

**Feature name convention:** Derive from the PRD filename — take the filename without the `.md` extension, lowercase, hyphens preserved. Example: `prd/active/user-auth.md` → token file is `docs/tokens/user-auth.md`.

When recording the first phase for a feature:
1. Derive the feature name from the active PRD in `docs/prd/active/`
2. Check if `docs/tokens/[feature-name].md` exists
3. If not, copy from `docs/tokens/_template.md` and fill in the header fields (PRD name, project, sprint, PI)
4. If no active PRD exists yet (e.g. recording for `/idea` phase), use the idea name slug as the feature name — it will be updated when the PRD is written

---

## Session Count

Increment the session count each time the phase continues in a new Claude Code session. A single uninterrupted session = 1. A phase resumed after closing and reopening Claude Code = 2, etc.

Track session count in HANDOFF.md under the current phase note so it persists across sessions:
```
## Current Ticket
Phase: Grill — Session 2 of current phase
```

---

## Multi-PI Features

When a feature spans multiple PIs (starts in PI-N, completes in PI-N+1):
- The token file `docs/tokens/[feature-name].md` accumulates across all sessions regardless of PI
- The global ledger entry is created at `/approve` and tagged with the PI in which the feature was approved
- The phase date ranges in the token file show the actual dates — spanning the PI boundary naturally
- In `/token-report`, multi-PI features appear in the PI they were approved in, with a note: "Phase dates span PI-N and PI-N+1"
- For accurate PI-level cost accounting, the PI report notes: "N features approved this PI; N phases from prior PI included"

---

## Manual Correction

If an agent estimate is clearly wrong (e.g. estimated S but session was clearly L):
1. Open `docs/tokens/[feature-name].md` directly
2. Update the phase record with the corrected estimate and add a note: "Corrected: original estimate was [band]"
3. If the feature is already approved and in the ledger, the ledger entry is stale — note in the ledger entry: "Token record corrected post-approval — see docs/tokens/[feature-name].md for updated figures"
4. The next `/token-report` will flag the discrepancy if ledger and file totals differ
