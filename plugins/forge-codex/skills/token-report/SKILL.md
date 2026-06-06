---
name: "token-report"
description: "Generate a program-level token usage report across features, sprints, and PIs. Shows phase breakdowns, estimate vs actual calibration, and session counts. Use when user runs $token-report or wants to analyse AI execution costs across projects."
metadata:
  category: metrics
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Token Report

Generate a program-level analysis of token usage. Reads from the global ledger and per-project token files to produce reports at feature, sprint, PI, or program level.

## When to Use

- User runs `token-report` explicitly
- End of PI for program-level cost analysis
- When estimates consistently miss and calibration is needed
- Before PI planning to inform capacity estimates

## Report Scopes

The user can request:
- **Feature** — one feature's phase breakdown and estimate comparison
- **Sprint** — all features in a sprint, total and by phase
- **PI** — all features in a PI across all projects
- **Program** — everything in the ledger, all time
- **Calibration** — estimate vs actual analysis for refining future estimates

If scope not specified, ask once: "Which scope — feature, sprint, PI, program, or calibration?"

---

## Process

1. Read `~/.codex/forge/tokens/ledger.md` — global feature records
2. Read `docs/tokens/[feature].md` files for in-progress features (not yet in ledger)
3. Read `~/.codex/forge/sprints/calendar.md` and `~/.codex/forge/pi/[current-pi]/plan.md` for sprint/PI context
4. Aggregate by requested scope
5. Present the report

---

## Report Formats

### Feature Report

```markdown
## Token Report — [Feature Name]

**Project:** [repo] | **Sprint:** Sprint-NN | **PI:** PI-N
**Status:** In Progress | Approved on YYYY-MM-DD

### Phase Breakdown

| Phase | Input | Output | Total | Band | Sessions |
|-------|-------|--------|-------|------|---------|
| Idea | ~Nk | ~Nk | ~Nk | S | N |
| Grill | ~Nk | ~Nk | ~Nk | M | N |
| Write PRD | ~Nk | ~Nk | ~Nk | S | N |
| Build | ~Nk | ~Nk | ~Nk | L | N |
| QA | ~Nk | ~Nk | ~Nk | S | N |
| **Total** | **~Nk** | **~Nk** | **~Nk** | **M** | **N** |

### Estimate vs Actual
- Pre-build estimate: M (20–80k)
- Actual total: ~Nk (M)
- Result: ✅ On band

### Input Breakdown (top phases by input cost)
1. Grill: ~Nk — read CONTEXT.md, kanban.md, 8 source files
2. Build: ~Nk — read 12 source files, testplan, PRD
3. Write PRD: ~Nk — read codebase (3 modules)
```

### Sprint Report

```markdown
## Token Report — Sprint-NN

**Period:** YYYY-MM-DD → YYYY-MM-DD
**Projects:** [repo1], [repo2]

### Features This Sprint

| Feature | Project | Total Tokens | Band | Sessions | vs Estimate |
|---------|---------|-------------|------|---------|-------------|
| [name] | [repo] | ~Nk | M | N | ✅ On |
| [name] | [repo] | ~Nk | L | N | ⚠️ Over |

### Sprint Totals
| Metric | Value |
|--------|-------|
| Total tokens | ~Nk |
| Input tokens | ~Nk (N%) |
| Output tokens | ~Nk (N%) |
| Total sessions | N |
| Features | N |
| Avg per feature | ~Nk |

### Phase Distribution (% of sprint total)
- Build: N% (~Nk)
- Grill: N% (~Nk)
- Write PRD: N% (~Nk)
- QA: N% (~Nk)
- Other: N% (~Nk)
```

### PI Report

```markdown
## Token Report — PI-N [Name]

**Period:** YYYY-MM-DD → YYYY-MM-DD
**Projects:** [list]

### By Project

| Project | Features | Total Tokens | Avg per Feature | Sessions |
|---------|----------|-------------|-----------------|---------|
| [repo1] | N | ~Nk | ~Nk | N |
| [repo2] | N | ~Nk | ~Nk | N |
| **Total** | **N** | **~Nk** | **~Nk** | **N** |

### By Sprint

| Sprint | Features | Total Tokens | Sessions |
|--------|----------|-------------|---------|
| Sprint-NN | N | ~Nk | N |
| Sprint-NN | N | ~Nk | N |

### Phase Distribution (PI total)
| Phase | Tokens | % of PI total |
|-------|--------|--------------|
| Build | ~Nk | N% |
| Grill | ~Nk | N% |
| Write PRD | ~Nk | N% |
| QA | ~Nk | N% |
| Other | ~Nk | N% |
```

### Calibration Report

```markdown
## Token Calibration Report

**Features analysed:** N approved + N in-progress (partial)
Note: in-progress features marked ⚠️ partial — actuals incomplete

### Estimate Accuracy by Band (approved features only)

| Estimated Band | Features | Actual: Under | Actual: On | Actual: Over |
|---------------|----------|--------------|-----------|-------------|
| S (<20k) | N | N (N%) | N (N%) | N (N%) |
| M (20–80k) | N | N (N%) | N (N%) | N (N%) |
| L (80–200k) | N | N (N%) | N (N%) | N (N%) |

### Recommendation
[Based on the data — e.g. "M estimates consistently land in the upper half — consider treating M as 50–80k rather than 20–80k"]

### Phase Surprises (phases that cost more than expected)
| Phase | Avg expected | Avg actual | Ratio |
|-------|-------------|-----------|-------|
| Grill | ~Nk | ~Nk | N×  |
| Build | ~Nk | ~Nk | N× |

### Session Count Patterns
| Phase | Avg sessions | Range |
|-------|-------------|-------|
| Grill | N | N–N |
| Build | N | N–N |
```

---

## Embedding in Other Skills

### `$standup` — current feature spend line
```
Token spend (current feature): ~Nk so far across N phases
```

### `$sprint-end` — sprint total line
```
Sprint token total: ~Nk (N features, N sessions)
```

### `$pi-end` — PI total line
```
PI token total: ~Nk across N features, N projects, N sessions
```

---

## Rules

- All token counts are agent estimates — label as such in reports
- Only include approved features in calibration reports — in-progress actuals are incomplete
- Round to nearest 1k for readability
- Never fabricate data — if a phase has no record, show "—" not a guess
- Suggest running `estimate` if calibration shows consistent over-band results
