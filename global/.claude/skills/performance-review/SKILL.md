---
name: performance-review
category: code-quality
description: Structured performance audit of project code. AI-led static analysis and architectural review, layered with optional tool invocation (Lighthouse, webpack-bundle-analyzer, language profilers). Writes a gitignored report to docs/performance/. Findings use PERF-YYYYMMDD-NNN IDs and can be promoted to kanban tickets. Use when user runs /performance-review or before a major release.
---

# Performance Review

Structured performance audit of the current project codebase. AI-led static and
architectural analysis, layered with optional tool invocation. Follows the same
pattern as `/security-assessment` — scoped, gitignored, finding IDs, kanban promotion.

---

## Usage

```
/performance-review                      ← full codebase audit
/performance-review --scope frontend     ← rendering, bundle size, assets
/performance-review --scope api          ← request handling, sync operations, N+1
/performance-review --scope db           ← queries, indexes, fetch patterns
/performance-review src/payments/        ← specific path
```

---

## Pre-flight

### 1 — Gitignore setup

Check if `docs/performance/` appears in `.gitignore`. If not, add it:

```
# Performance review reports
docs/performance/
```

Create `docs/performance/` if it does not exist.

### 2 — Query tools registry

Load available tools for the `performance-analyser` category:

1. Read `~/.claude/companies/[active_company]/tools.md` (if company is set) — company entries take priority
2. Read `~/.claude/tools/global.md` — global fallback
3. For each tool in `performance-analyser`:
   - `prohibited` → skip entirely; note in the announcement
   - `required` → check `check-command`; if missing, note (pre-flight will have already blocked `/build`)
   - `approved` / `global-only` → check `check-command`; use if installed

The first installed tool found per category wins.

### 3 — Announce scope

```
🔍 Performance Review — [Project Name]
   Scope: [Full codebase / --scope X / path]
   AI analysis: ✅
   [tool-name] (performance-analyser): ✅ installed / ❌ missing / 🚫 prohibited / ➖ not applicable

Running review — this may take a few minutes...
```

If no performance-analyser tools are installed, note: "No performance-analyser tools installed — running AI analysis only. Run /tool-check for recommendations."

---

## Phase 1 — Orient (AFK)

Read silently:
- `CLAUDE.md` — architecture, tech stack, known bottlenecks
- `docs/CONTEXT.md` — domain context, system boundaries
- Package manifest — identify frameworks (React, Django, Rails, etc.)
- Directory structure — identify hot paths, data-heavy modules

---

## Phase 2 — AI-Led Static Analysis

Scan for specific code-level performance patterns. High confidence — directly observed.
Do not produce output during this phase.

### Frontend scope
- Unnecessary re-renders (React: missing memo/useMemo/useCallback, derived state in render)
- Synchronous operations blocking the main thread
- Large imports without tree-shaking (`import _ from 'lodash'` vs named imports)
- Missing lazy loading for routes and large components
- Unoptimised images or assets referenced in code

### API scope
- Synchronous I/O on request paths (blocking file reads, sync crypto)
- Missing pagination on endpoints returning unbounded collections
- Sequential awaits that could be parallelised (`await a; await b` → `Promise.all`)
- Response payloads returning more data than the client uses (over-fetching)
- Missing HTTP caching headers on cacheable endpoints

### Database scope
- N+1 query patterns in ORM usage (loop with query inside)
- Missing `.select()` — fetching all columns when only a subset is needed
- Queries inside loops that could be batched
- Missing indexes on columns used in WHERE, ORDER BY, or JOIN conditions (inferred from query patterns)
- Unbounded queries without LIMIT

---

## Phase 3 — AI-Led Architectural Analysis

Higher-level patterns. Medium confidence — inferred from design, requires verification.
Flag each finding with `[Requires verification]`.

- Absent caching layer on expensive or frequently-repeated computations
- Chatty service calls (many small requests that could be batched or aggregated)
- Synchronous cross-service calls on critical paths that could be async/queued
- Hot paths with no rate limiting or back-pressure
- Session or auth lookups not cached (repeated on every request)
- Missing CDN or edge caching for static assets

---

## Phase 4 — Tool Invocation (if available)

`[scope-path]` resolves as: `.` for full or category scans, the provided path for path-scoped runs.

Write output to `docs/performance/tmp/`. Clean up after Phase 5.

For each tool identified as installed in Pre-flight Step 2, invoke it using the `usage`
guidance from its registry entry. Follow the `anti-patterns` field to avoid common misuse.

**Common invocation patterns** (override by registry `usage` if they differ):

- Lighthouse (web — requires running dev server):
  ```bash
  lighthouse [dev-server-url] --output json --output-path docs/performance/tmp/lighthouse.json --quiet
  ```
  If no dev server URL is available, skip and note: "Lighthouse skipped — provide a running dev server URL with `/performance-review --url http://localhost:3000`"

- webpack-bundle-analyzer (JS projects):
  ```bash
  npx webpack-bundle-analyzer [stats-file] --mode static --report docs/performance/tmp/bundle-report.html --no-open
  ```

- py-spy (Python — requires a running process):
  ```bash
  py-spy record -o docs/performance/tmp/profile.svg --pid [pid] --duration 30
  ```
  Skip if no process is running — note for manual profiling.

- go pprof (Go projects):
  ```bash
  go test -cpuprofile docs/performance/tmp/cpu.prof -memprofile docs/performance/tmp/mem.prof ./...
  go tool pprof -text docs/performance/tmp/cpu.prof > docs/performance/tmp/pprof-report.txt
  ```

For any tool not installed:
```
❌ [tool] not installed — [description from registry]. Install: [install-hint]
```

For any tool marked `prohibited` in company config:
```
🚫 [tool] prohibited by company policy — skipped.
```

---

## Phase 5 — Consolidate Findings

Merge AI and tool findings. Assign `PERF-YYYYMMDD-NNN` IDs (sequential within report).

| Severity | Criteria |
|----------|----------|
| 🔴 Critical | Proven bottleneck with measurable user impact — blocking main thread, O(n²) query patterns, N+1 on high-traffic endpoints |
| 🟠 High | Significant inefficiency — missing pagination on large collections, large synchronous operations on request paths |
| 🟡 Medium | Optimisation opportunity — missing caching, sequential awaits, over-fetching |
| 🔵 Low | Best practice gap — missing lazy loading, suboptimal imports, minor over-fetching |
| ℹ️ Info | Architectural observations at Medium confidence — verify before acting |

Assign confidence per finding (same model as `/security-assessment`):
- **High** — directly observed in code at a specific file and line
- **Medium** — inferred from patterns, requires verification
- **Low** — architectural concern, context-dependent

Critical severity requires High confidence. Medium/Low confidence findings cap at High severity.

Delete `docs/performance/tmp/` after consolidation.

---

## Phase 6 — Write Report

Write `docs/performance/review-YYYY-MM-DD.md`:

```markdown
# Performance Review — [Project Name]

**Date:** YYYY-MM-DD
**Scope:** [Full / --scope X / path]
**Tools run:** [list or "AI-only"]

---

## Executive Summary

[2–4 sentences: overall performance posture, critical bottlenecks, priorities]

**Finding counts:** 🔴 N Critical | 🟠 N High | 🟡 N Medium | 🔵 N Low | ℹ️ N Info

---

## Findings

### 🔴 Critical

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### 🟠 High

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### 🟡 Medium

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### 🔵 Low

| ID | Location | Description | Confidence | Recommendation |
|----|----------|-------------|------------|----------------|

### ℹ️ Info (Medium/Low confidence — verify before acting)

| ID | Observation | Confidence | Suggestion |
|----|-------------|------------|------------|

---

## Tool Output Summary

[Lighthouse scores, bundle sizes, profiler hotspots — or note tools not run]

---

## Recommended Actions

[Numbered list, Critical first. Each: PERF-YYYYMMDD-NNN, location, specific fix, estimated impact.]

---

*This report is gitignored. Performance findings in tickets use PERF-YYYYMMDD-NNN IDs only.*
```

---

## Phase 7 — Kanban Promotion (optional)

```
Found N Critical and N High findings.

Would you like to create kanban tickets for these findings?
[List PERF-YYYYMMDD-001 through PERF-YYYYMMDD-N with one-line summaries]

Create tickets? (yes / no / select)
```

Ticket format:
```markdown
- [ ] PERF-20260524-001 — Performance finding (see docs/performance/review-2026-05-24.md) | High | performance
```

---

## Phase 8 — Update Preferences and Confirm

Update `~/.claude/preferences.md`:
```
performance-review-last-run: YYYY-MM-DD
```

```
✅ Performance review complete.

   Report: docs/performance/review-YYYY-MM-DD.md  (gitignored)
   Findings: 🔴 N Critical | 🟠 N High | 🟡 N Medium | 🔵 N Low | ℹ️ N Info
   Kanban tickets: N created (PERF-YYYYMMDD-001 … PERF-YYYYMMDD-N)
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No source code found | Note and skip AI analysis — run tools if available |
| Tool fails | Capture stderr, note in report, do not block |
| Lighthouse needs running server | Skip with note — suggest `--url` flag |
| `docs/performance/` gitignore fails | Warn and do not write report until confirmed |
| No findings | Write report noting "no significant performance concerns identified" |

---

## Rules

- Never write the report before confirming `docs/performance/` is gitignored
- Critical severity requires High confidence — cap Medium/Low confidence at High
- ℹ️ Info findings must always be marked with their confidence level
- Tool output is temporary — always clean up `docs/performance/tmp/` after consolidation
- The report is always dated — never overwrite a previous report
- This skill is read-only for source files — never modify code during the review
