---
name: fy-review
category: metrics
description: Generate a financial year or mid-year review. Aggregates ideas submitted, projects delivered, incidents, token spend, value observed, and discovered metrics across all Forge data for the period. Produces a manager-facing summary and an internal team retrospective. Year-over-year comparison when prior data exists. Use when user runs /fy-review at mid-year or FY end.
---

# FY Review

Generate a structured period review from all available Forge data. Produces two documents:
a manager-facing summary for the reporting line manager, and an internal team retrospective
with full technical detail.

These are **private documents** — never committed to git, never published to Confluence.

---

## Usage

```
/fy-review              ← auto-detect period from current date
/fy-review --mid        ← mid-year review (July–December)
/fy-review --full       ← full FY review (July–June)
/fy-review FY2026       ← specific FY (July 2025 – June 2026)
/fy-review --from 2025-07-01 --to 2026-06-30  ← custom period
```

---

## Phase 1 — Configure Period

### Read company config

Read from `~/.claude/companies/[active_company]/config.md`:
- `fy_start` — default `July 1` if not set (Australian FY)
- `review_display_name` — default `FY Review` if not set
- `token_cost_per_1k` — optional; enables cost-per-feature and cost-per-story-point metrics

### Determine period

| Flag | Period |
|------|--------|
| `--mid` | FY start → December 31 of same calendar year |
| `--full` | FY start → June 30 of following calendar year |
| `FY2026` | July 1 2025 → June 30 2026 |
| `--from`/`--to` | exact dates provided |
| No flag | Auto-detect: if current month is July–December → mid-year; if January–June → full FY for the period just ended |

### FY label

Name the FY after the year it ends (Australian convention):
- July 2025–June 2026 = **FY2026**
- July 2025–December 2025 (mid-year) = **FY2026 Mid-Year**

### Storage path

```
~/.claude/companies/[active_company]/reviews/FY2026/
  manager-summary.md
  team-retrospective.md
```

If the directory already exists, warn before overwriting:
```
⚠️ A review already exists for FY2026. Overwrite? (yes/no)
```

---

## Phase 2 — Discover Data Sources (AFK)

Silently scan all available Forge data. Note what is found and what is missing —
absent sources are skipped gracefully, not errored.

**Company-level sources:**
- `~/.claude/companies/[active_company]/registry.md` — ideas, projects, systems
- `~/.claude/companies/[active_company]/ideas/active/` and `archive/`
- `~/.claude/companies/[active_company]/incidents/`
- `~/.claude/companies/[active_company]/reviews/` — prior FY reviews for year-over-year
- `~/.claude/companies/[active_company]/pir/` — PIR outcome assessments per project and PI
- `~/.claude/companies/[active_company]/retrospectives/` — sprint retrospective summaries

**Per-project sources** (scan all known projects from registry):
- `docs/kanban.md` — completed and carried tickets
- `docs/sprints/sprint-NN.md` — sprint records
- `docs/tokens/[feature].md` — token spend per feature
- `docs/metrics/metrics-log.md` — critic sessions, diagnose events, lookup activity, sprint velocity
- `docs/tech-debt.md` — debt register
- `docs/security/assessment-*.md` — security assessments
- `docs/performance/review-*.md` — performance reviews
- `docs/feature-flags.md` — flag register
- `docs/prd/active/` and `docs/prd/archived/` — PRDs
- `docs/known-issues.md` — known issues
- `~/.claude/pi/[pi]/plan.md` — PI plans

Filter all records to the review period using dates in each document.

---

## Phase 3 — Compute Core Metrics (AFK)

Calculate the following. Where data is unavailable, note "No data" rather than omitting.

### Ideas Pipeline
| Metric | How to calculate |
|--------|-----------------|
| Ideas submitted | Count ideas created within the period (from registry + idea files) |
| Ideas progressed to projects | Count ideas with linked PROJ-NNN created in period |
| Ideas archived/declined | Count ideas moved to archive in period |
| Conversion rate | Ideas progressed ÷ ideas submitted × 100% |

### Project Delivery
| Metric | How to calculate |
|--------|-----------------|
| Projects started | Count PROJ entries created in period |
| Projects delivered | Count projects with a GO release in period |
| Projects in progress at period end | Count projects with Active status |
| On-time delivery rate | Delivered by original target date ÷ total delivered × 100% |

### Token Spend
| Metric | How to calculate |
|--------|-----------------|
| Total tokens in period | Sum all feature token totals within period |
| Tokens per project | Per-project totals from `docs/tokens/` |
| Average tokens per ticket | Total tokens ÷ total tickets completed |
| Estimate calibration accuracy | % of features where actual band = estimated band |
| Token efficiency trend | Compare average tokens per ticket: first half of period vs second half |

The token efficiency trend is the key knowledge base ROI metric: as the knowledge base
grows, sessions should require fewer tokens per task. A declining trend confirms the
investment in `/ingest` and `/add-system` is paying off.

### Incidents
| Metric | How to calculate |
|--------|-----------------|
| Total incidents | Count INC records within period |
| By severity | Count per SEV1/SEV2/SEV3 (or configured model) |
| Mean time to resolution | Average duration from declared to resolved |
| Incident rate per release | Total incidents ÷ releases deployed |
| Repeat incidents | Incidents sharing root cause with a prior incident |
| Post-mortem completion rate | Incidents with postmortem.md ÷ total incidents × 100% |

### Security
| Metric | How to calculate |
|--------|-----------------|
| Assessments run | Count dated reports in `docs/security/` within period |
| Critical/High findings | Sum across all reports |
| Resolution rate | Resolved findings ÷ total findings × 100% |
| Mean days to resolve Critical findings | Average days from report date to resolution |

### Technical Debt
| Metric | How to calculate |
|--------|-----------------|
| Items added | Count TD entries with added date in period |
| Items resolved | Count TD entries resolved in period |
| Net change | Added − resolved (positive = debt growing) |
| High priority items at period end | Count open High items at end of period |

### Sprint Health
| Metric | How to calculate |
|--------|-----------------|
| Sprints completed | Count sprint records in period |
| Average carry-over rate | Average % of tickets carried from one sprint to next |
| Sprint goal hit rate | Sprints where all goals met ÷ total sprints × 100% |

### Knowledge Base
| Metric | How to calculate |
|--------|-----------------|
| Wiki articles created | Count entries in `_changelog.md` with type `created` in period |
| Wiki articles updated | Count entries with type `updated` in period |
| Systems documented | Count systems with Wiki coverage |
| Raw items ingested | Count `_compiled.log` entries in period |

### Feature Flags
| Metric | How to calculate |
|--------|-----------------|
| Flags created | Count FF entries created in period |
| Flags removed | Count FF entries resolved in period |
| Average flag lifetime | Average days from creation to removal for resolved flags |
| Overdue flags at period end | Count flags past removal date |

### AI Assistance Quality
Read from `docs/metrics/metrics-log.md` (Critic Sessions + Diagnose Events tables).

| Metric | How to calculate |
|--------|-----------------|
| Critic sessions run | Count rows in Critic Sessions table within period |
| Average P1 findings per session | Sum P1 ÷ session count |
| Diagnose events — total | Count rows in Diagnose Events table within period |
| Diagnose trigger split | Explicit count vs Failed-twice count |
| Diagnose resolution rate | Resolved ÷ total diagnose events × 100% |
| HITL-to-AFK ratio | Count `[HITL]` tickets ÷ count `[AFK]` tickets in kanban within period |

The HITL-to-AFK ratio indicates how much human oversight is applied to AI output.
A high HITL ratio means the human is reviewing most AI work. Neither extreme is inherently good — context matters.

### AI Knowledge Base ROI
Read from `docs/metrics/metrics-log.md` (Lookup Activity + Sprint Velocity tables) and token data.

| Metric | How to calculate |
|--------|-----------------|
| Lookup frequency per sprint | Total lookup rows ÷ sprint count |
| Lookup hit rate | Found lookups ÷ total lookups × 100% |
| Token efficiency trend | Average tokens/ticket: first half of period vs second half (from sprint + token data) |
| Token efficiency improvement | % change: (first-half avg − second-half avg) ÷ first-half avg × 100% |

A positive token efficiency improvement (fewer tokens per ticket in H2) confirms the knowledge
base is paying off. Compare year-on-year: this should improve each FY as KB matures.

### Cost Metrics
Only calculated if `token_cost_per_1k` is set in company config.

| Metric | How to calculate |
|--------|-----------------|
| Total cost (period) | Total tokens ÷ 1000 × token_cost_per_1k |
| Average cost per feature | Total cost ÷ features delivered |
| Average cost per story point | Total cost ÷ total story points completed |
| Cost trend | Compare H1 vs H2 cost per story point — should decline with KB growth |

If `token_cost_per_1k` is not set, note "Configure token_cost_per_1k in company config to enable cost metrics."

---

## Phase 4 — Discover Additional Metrics

After computing core metrics, scan available data for additional calculable signals.
Surface any metric where a meaningful number can be derived — note the source.

Examples (compute if data exists):
- Dependency vulnerability resolution rate (from `/dependency-update` runs)
- Performance finding resolution rate (from `docs/performance/`)
- ADRs written (architectural decision volume)
- PRD accuracy: estimated tickets vs actual tickets per project
- Session count per project (DEVLOG entry count)
- Average sprint velocity trend (story points per sprint, first half vs second half)
- Known issues resolution rate (`docs/known-issues.md`)

Present any discovered metrics in a dedicated section of the retrospective.

---

## Phase 5 — Draft Value Observations (HITL)

For each **delivered project** in the period:

1. Check `~/.claude/companies/[active_company]/pir/PROJ-NNN/` for PIR records within the period.
   If PIR records exist: use their outcome assessments as the primary source — they already
   contain human-confirmed observations. Skip to step 4 using PIR data directly.
2. If no PIR exists: read the project's archived PRDs for stated goals and user story outcomes.
3. Read what was actually shipped (kanban completed tickets, release records) and note
   any incidents, known issues, or carry-forward items.
4. Draft a value observation paragraph (3–5 sentences):
   - What was delivered
   - How it relates to the stated goals
   - Observable outcomes (qualitative where quantitative not available)
   - Any caveats (incidents, incomplete items)

Present each draft to the human:

```
Value observation draft — [Project Name]

[Draft paragraph]

Edit this, confirm as-is, or skip? (edit / ok / skip)
```

If the human edits: accept and record. If skip: note "Value not recorded — add manually."
Confirmed observations become the value section of the manager summary.

---

## Phase 6 — Year-over-Year Comparison

Check `~/.claude/companies/[active_company]/reviews/` for a prior FY review covering
the equivalent period.

- Full FY review → compare to previous full FY
- Mid-year review → compare to previous mid-year (H1 vs H1)

If prior data exists, compute deltas for key metrics:

```markdown
## Year-on-Year Comparison (FY2026 vs FY2025)

| Metric | FY2025 | FY2026 | Change |
|--------|--------|--------|--------|
| Ideas submitted | 12 | 18 | +50% ↑ |
| Projects delivered | 4 | 6 | +50% ↑ |
| Total tokens spent | ~1.2M | ~980k | -18% ↓ ✅ |
| Avg tokens per ticket | ~8,200 | ~5,400 | -34% ↓ ✅ |
| Incident rate / release | 1.2 | 0.6 | -50% ↓ ✅ |
| Estimate calibration | 58% | 74% | +16pts ↑ |
| Sprint carry-over rate | 28% | 19% | -9pts ↓ ✅ |
| Lookup hit rate | 71% | 84% | +13pts ↑ ✅ |
| Diagnose events (Failed twice) | 8 | 3 | -63% ↓ ✅ |
| Cost per story point | $4.20 | $2.80 | -33% ↓ ✅ |
```

Direction indicators: ↑ ↓ with ✅ where the direction is positive (lower incidents = ✅,
lower tokens per ticket = ✅, higher calibration = ✅).

If no prior data: note "First [review_display_name] — year-on-year comparison available from [next FY label]."

---

## Phase 7 — Generate Manager Summary

Write `manager-summary.md`. Audience: reporting line manager. Plain language — no
ticket IDs, no technical jargon, no token counts in the headline section.

```markdown
# [review_display_name] — [Period Label]
## [Company Name] | [Employee / Team Name if known]

**Period:** [start date] → [end date]
**Prepared:** [date]

---

## Overview

[2–3 sentence executive summary: what the period achieved at a high level]

---

## Work Delivered

[For each delivered project — one paragraph each, written from confirmed value observations]

### [Project Name]
[Value observation paragraph — plain language, outcome-focused]

---

## Ideas and Innovation

- **[N] ideas submitted** — [N] progressed to active projects, [N] in evaluation
- Conversion rate: [N]%
- Notable ideas: [list 1–3 significant ideas by title]

---

## Headline Metrics

| Area | Result | vs Prior Year |
|------|--------|--------------|
| Projects delivered | N | +N / −N / First year |
| On-time delivery | N% | |
| Production incidents | N (SEV1: N, SEV2: N) | |
| Team efficiency trend | [Improving / Stable / Declining] | |

---

## Key Observations

[3–5 bullet points: significant achievements, challenges, or patterns worth highlighting.
Written for a manager who will use this in performance conversations.]

---

## Looking Ahead

[1–2 sentences: what is in flight or planned for the next period, framed for the manager]

---

*Prepared using Forge AI-assisted development framework.*
*For technical detail see: team-retrospective.md (internal)*
```

---

## Phase 8 — Generate Team Retrospective

Write `team-retrospective.md`. Audience: engineering team. Full technical detail.

```markdown
# [review_display_name] — Team Retrospective
## [Period Label] | [Company Name]

**Period:** [start date] → [end date]
**Prepared:** [date]

---

## Ideas Pipeline

| Metric | Value |
|--------|-------|
| Ideas submitted | N |
| Progressed to projects | N (N%) |
| Archived / declined | N |

---

## Project Delivery

| Metric | Value |
|--------|-------|
| Projects started | N |
| Projects delivered | N |
| In progress at period end | N |
| On-time delivery rate | N% |

---

## Token Spend

| Metric | Value |
|--------|-------|
| Total tokens (period) | ~Nk |
| Average per project | ~Nk |
| Average per ticket | ~Nk |
| Estimate calibration accuracy | N% |

### Token Efficiency Trend
[First half of period avg tokens/ticket] → [Second half avg tokens/ticket]
[Direction and % change — confirms knowledge base ROI if declining]

### Spend by Project
| Project | Total | Band | Calibration |
|---------|-------|------|------------|
| [name] | ~Nk | L | Over / On / Under |

---

## Incidents

| Metric | Value |
|--------|-------|
| Total incidents | N |
| SEV1 / SEV2 / SEV3 | N / N / N |
| Mean time to resolution | Nh Nm |
| Incident rate per release | N |
| Repeat incidents | N |
| Post-mortem completion | N% |

---

## Security

| Metric | Value |
|--------|-------|
| Assessments run | N |
| Critical / High findings | N / N |
| Resolution rate | N% |
| Mean days to resolve Critical | N days |

---

## Technical Debt

| Metric | Value |
|--------|-------|
| Items added | N |
| Items resolved | N |
| Net change | +N / −N |
| High priority items at period end | N |

---

## Sprint Health

| Metric | Value |
|--------|-------|
| Sprints completed | N |
| Average carry-over rate | N% |
| Sprint goal hit rate | N% |

---

## Knowledge Base

| Metric | Value |
|--------|-------|
| Wiki articles created | N |
| Wiki articles updated | N |
| Systems documented | N |
| Raw items ingested | N |

---

## Feature Flags

| Metric | Value |
|--------|-------|
| Flags created | N |
| Flags removed | N |
| Average lifetime | N days |
| Overdue at period end | N |

---

## AI Assistance Quality

| Metric | Value |
|--------|-------|
| Critic sessions run | N |
| Average P1 findings per session | N |
| Diagnose events total | N |
| Diagnose trigger split | N Explicit / N Failed-twice |
| Diagnose resolution rate | N% |
| HITL-to-AFK ratio | N% HITL |

---

## AI Knowledge Base ROI

| Metric | Value |
|--------|-------|
| Lookup frequency per sprint | N |
| Lookup hit rate | N% |
| Token efficiency H1 | ~Nk tokens/ticket |
| Token efficiency H2 | ~Nk tokens/ticket |
| Efficiency improvement | N% ↓ (improving) / N% ↑ (growing) |

---

## Cost Metrics

[Only included if token_cost_per_1k is configured]

| Metric | Value |
|--------|-------|
| Total cost (period) | $N.NN |
| Average cost per feature | $N.NN |
| Average cost per story point | $N.NN |
| H1 vs H2 cost per point | $N.NN → $N.NN |

---

## Additional Metrics

[Discovered metrics with source noted — only present if data exists]

---

## Year-on-Year Comparison

[Comparison table from Phase 6, or "First review" note]

---

## What Went Well

[3–5 bullet points: genuine strengths observed in the data and patterns]

## What to Improve

[3–5 bullet points: specific, actionable — anchored to data where possible]

## Recommendations for Next Period

[Numbered list of concrete actions for the next FY or half-year]

---

*Internal document — not for distribution outside the team.*
```

---

## Phase 9 — Write and Confirm

Write both files to `~/.claude/companies/[active_company]/reviews/FY2026/`.

```
✅ [review_display_name] generated — FY2026

   Manager summary:      ~/.claude/companies/[active_company]/reviews/FY2026/manager-summary.md
   Team retrospective:   ~/.claude/companies/[active_company]/reviews/FY2026/team-retrospective.md

   These are private documents — not committed to git, not published to Confluence.

   Data coverage:
   ✅ Ideas pipeline     ✅ Project delivery    ✅ Token spend
   ✅ Incidents          ⚠️ Security (no reports found)
   ✅ Tech debt          ✅ Sprint health        ✅ Knowledge base
   [full list of what was found and what was missing]

   Year-on-year: ✅ FY2025 comparison included / ℹ️ First review — no prior data
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No company configured | Offer to run against current project only — note metrics will be incomplete |
| Period produces no data | Warn and ask to confirm — may indicate wrong period or fresh install |
| FY start not in company config | Default to July 1, note the assumption |
| `review_display_name` not set | Default to "FY Review" |
| Prior FY review not found | Skip year-on-year, note it |
| All value observations skipped | Manager summary value section notes "Value observations not recorded — add manually" |
| Overwrite existing review | Require explicit yes/no confirmation |

---

## Rules

- Never commit review files to git — they are private documents
- Never publish to Confluence — these are between employee and reporting manager only
- Value observations require human confirmation — never write unreviewed AI-drafted value claims
- Year-on-year comparison uses equivalent periods only — full FY vs full FY, mid-year vs mid-year
- All metrics are sourced from Forge data only — never invent or estimate numbers not in the records
- Missing data sources are noted explicitly — silence on a metric implies absence, not zero
- The manager summary must be readable by a non-technical manager — no ticket IDs, token counts in headlines, or jargon
