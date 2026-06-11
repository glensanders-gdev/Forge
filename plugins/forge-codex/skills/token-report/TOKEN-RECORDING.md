# Token Recording — Actuals Guide

Token usage is recorded from **measured actuals**, not agent estimates. The source of truth is [ccusage](https://github.com/ryoppippi/ccusage), which reads Codex's local session logs. Recording happens at session close (`$debrief`) and sprint close (`$sprint-end`) — individual pipeline skills do not record token usage.

---

## When to Record

- **`$debrief`** — at every session close, record the session's actuals against the current feature and phase.
- **`$sprint-end`** — at sprint close, cross-check the sprint-period total against the per-feature records and fill any gaps.

Pipeline skills (`$idea`, `$grill-with-docs`, `$build`, `$qa-plan`, etc.) never write token records. One recording point per session prevents both duplicate entries and per-phase guessing.

---

## How to Measure

Run ccusage for the period being recorded:

```bash
# Session close — today's usage
npx ccusage daily --since YYYYMMDD --until YYYYMMDD --json

# Sprint close — sprint period total
npx ccusage daily --since [sprint-start] --until [sprint-end] --json
```

Use the input and output token totals from the result. Round to the nearest 1k.

**Attribution:** the day's total is attributed to the phase worked this session (from `HANDOFF.md` / the conversation). If a single day spanned two features or phases, split the total by judgement and note the split — an approximate split of a real number beats a guess.

---

## Fallback — Never Guess

If ccusage is unavailable (no network, no npx) or returns no data for the period:

- Record the entry with `**Source:** no data` and leave the token fields as `—`.
- Never reconstruct token counts from memory or file-size heuristics. A missing number is recoverable later (ccusage logs persist); a fabricated one poisons calibration.
- The next `$debrief` or `$sprint-end` with ccusage available should backfill missing entries using `--since`/`--until` for the gap dates.

---

## Recording Format

Append to or update `docs/tokens/[feature-name].md`. Create the file from `_template.md` if it doesn't exist.

Each phase keeps one accumulating record. At session close, add the session's actuals to the current phase's running totals and increment its session count:

```markdown
### [Phase Name]
**Date range:** YYYY-MM-DD (→ YYYY-MM-DD if multi-session)
**Sessions:** N
**Input:** Nk tokens
**Output:** Nk tokens
**Total:** Nk ([S/M/L/XL])
**Source:** ccusage actuals
**Notes:** [optional — anything that drove unusual cost, or attribution splits]
```

### Band derivation
- S: < 20k total
- M: 20–80k total
- L: 80–200k total
- XL: 200k+ total

---

## File Initialisation

**Feature name convention:** Derive from the PRD filename — take the filename without the `.md` extension, lowercase, hyphens preserved. Example: `prd/active/user-auth.md` → token file is `docs/tokens/user-auth.md`.

When recording the first entry for a feature:
1. Derive the feature name from the active PRD in `docs/prd/active/`
2. Check if `docs/tokens/[feature-name].md` exists
3. If not, copy from `docs/tokens/_template.md` and fill in the header fields (PRD name, project, sprint, PI)
4. If no active PRD exists yet (e.g. recording during the `$idea` phase), use the idea name slug as the feature name — it will be updated when the PRD is written

---

## Session Count

Increment the phase's session count at each `$debrief` that attributes work to it. Track the current phase and its session count in `HANDOFF.md` so it persists across sessions:
```
## Current Ticket
Phase: Grill — Session 2 of current phase
```

---

## Multi-PI Features

When a feature spans multiple PIs (starts in PI-N, completes in PI-N+1):
- The token file `docs/tokens/[feature-name].md` accumulates across all sessions regardless of PI
- The global ledger entry is created at `$approve` and tagged with the PI in which the feature was approved
- The phase date ranges in the token file show the actual dates — spanning the PI boundary naturally
- In `$token-report`, multi-PI features appear in the PI they were approved in, with a note: "Phase dates span PI-N and PI-N+1"
- For accurate PI-level cost accounting, the PI report notes: "N features approved this PI; N phases from prior PI included"

---

## Manual Correction

If a recorded entry is wrong (e.g. misattributed to the wrong feature or phase):
1. Re-run ccusage for the affected dates to get the correct figures
2. Update the phase record in `docs/tokens/[feature-name].md` and add a note: "Corrected YYYY-MM-DD — [reason]"
3. If the feature is already approved and in the ledger, the ledger entry is stale — note in the ledger entry: "Token record corrected post-approval — see docs/tokens/[feature-name].md for updated figures"
4. The next `$token-report` will flag the discrepancy if ledger and file totals differ

---

## Legacy Records

Records written before this guide (agent-estimated, marked `~Nk`) remain valid as coarse signals. Do not retrofit them. `$token-report` labels them "estimated" and ccusage-sourced entries "actual" — never mix the two without labelling.
