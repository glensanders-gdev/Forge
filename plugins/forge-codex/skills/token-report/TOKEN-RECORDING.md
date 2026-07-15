# Codex Usage Recording

Record measured usage evidence without inventing token counts. Codex does not expose a stable per-thread token ledger to skills, and `ccusage` reads Claude Code data rather than Codex data.

## Accepted sources

Use the first available source:

1. An exact Codex usage export supplied by the user or exposed by the current Codex environment.
2. A user-provided measured total with its date range and provenance.
3. No measurement: record `Source: unavailable` and leave Input, Output, and Total blank.

Never estimate token counts from memory, transcript length, file size, model context, elapsed time, or Claude tooling.

## Phase record

```markdown
### [Phase] — [date]
**Source:** [Codex export | user-provided measurement | unavailable]
**Source detail:** [export/report identifier, date range, or reason unavailable]
**Input:** [exact value or —]
**Output:** [exact value or —]
**Total:** [exact value or —]
**Sessions:** [known count or —]
```

When exact totals cover several phases but cannot be split reliably, record one feature-level total and leave phase totals blank. Do not allocate the total proportionally.

## Corrections

Correct a record only from a better exact source. Preserve the previous value in a short correction note with the date and reason. Legacy `~Nk` estimates remain labelled `estimated`; never relabel them as actuals.

## Completion

A recording pass is complete when every relevant phase has either a cited exact source or an explicit `Source: unavailable`, and aggregate reports distinguish actuals, estimates, and unavailable values.
