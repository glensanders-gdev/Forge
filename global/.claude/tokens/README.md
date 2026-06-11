# Forge Token Ledger

Global cross-project token usage records. Populated automatically at `/approve` for each completed feature.

---

## Files

- `ledger.md` — global ledger of all approved features with token totals by phase

Per-project records live inside each repo at `docs/tokens/[feature-name].md`.

---

## How to Read It

Each entry in `ledger.md` represents one approved feature. Entries include:
- Phase-by-phase token breakdown (input, output, total, band, sessions)
- Grand total and band
- Estimate vs actual comparison

The summary table at the top aggregates across all entries.

---

## Reporting

Run `/user:token-report` for full analysis:
- By feature — phase breakdown and calibration
- By sprint — all features in a sprint
- By PI — cross-project totals
- Calibration — estimate accuracy over time

---

## Data Quality

Token counts are **measured actuals** sourced from `ccusage` (Claude Code's local session logs), recorded at `/debrief` and `/sprint-end`. Records created before this approach are agent estimates, marked `~Nk` — treat those as coarse signals only. Reports label the two distinctly.

---

## Correction

If a record needs correction (e.g. misattributed feature or phase), re-run ccusage for the affected dates, edit `docs/tokens/[feature-name].md` in the project repo, and note the correction. The ledger entry can be annotated manually — see `TOKEN-RECORDING.md` in the `token-report` skill folder for the correction procedure.
