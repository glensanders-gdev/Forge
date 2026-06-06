---
name: "context-health"
description: "Audit the token load profile of the current project\u0027s context files. Measures every file loaded into a session, estimates token cost, flags files that are growing too large, and recommends specific trimming actions. Also scans project source directories and recommends child AGENTS.md context nodes for directories exceeding the 20k token threshold. Run weekly or at sprint start. Saves a report to docs/context-health-report.md. Use when user runs $context-health or when sessions are regularly hitting context limits."
metadata:
  category: metrics
  origin: Child node recommendations adapted from Railly Hugo (Crafter Station / github.com/crafter-station/skills), drawing from Tyler Brandt's Intent Layer framework.
---

# Context Health

> **Company-aware:** When `active_company` is set in `~/.codex/forge/preferences.md` (configured by `$company-add`), company-specific files (acronyms, context, systems, projects) are measured from `~/.codex/forge/companies/[active_company]/knowledge/` instead of `~/.codex/forge/knowledge/`.

Audit how much of the 100k token soft limit is consumed by loaded files before a single
message is sent. Flags bloated files early, before they cause mid-session compaction.

**Token estimation:** `characters ÷ 4` throughout. This is an approximation — actual token
count varies by content type, but is accurate enough for budgeting decisions.

---

## Budget Tiers

| Status | Estimated session load | Meaning |
|--------|----------------------|---------|
| ✅ Green | < 30k tokens | Healthy — ample room for conversation |
| ⚠️ Amber | 30k–60k tokens | Caution — long sessions may hit the limit |
| 🔴 Red | > 60k tokens | Risk — compaction likely before session ends |

The session load estimate combines auto-loaded files + likely on-demand files (active PRD,
system knowledge, invoked skills). Conversation history is excluded — it is the variable.

---

## File Thresholds

### Auto-loaded (every session)

| File | Amber | Red | Default action |
|------|-------|-----|----------------|
| `docs/HANDOFF.md` | 1,200 | 2,500 | Recompact via `$save-state` |
| `docs/DEVLOG.md` | 1,500 | 3,000 | Archive entries older than 3 sessions |
| `docs/kanban.md` | 800 | 1,500 | Archive completed tickets to `kanban-archive.md` |
| `docs/CONTEXT.md` | 2,000 | 4,000 | Review for redundancy; merge near-duplicate terms |
| `AGENTS.md` (project) | 2,500 | 5,000 | Review for sections that can reference external files |
| `~/.codex/forge/PRINCIPLES.md` | 1,800 | 3,500 | Framework file — flag but do not modify |
| `~/.codex/forge/knowledge/company/acronyms.md` | 1,000 | 2,000 | Review for stale or duplicate entries |

### On-demand (loaded when relevant)

| File | Amber | Red | Default action |
|------|-------|-----|----------------|
| `docs/prd/active/*.md` | 8,000 | 15,000 | Archive completed sections; split large PRDs |
| `~/.codex/forge/knowledge/AGENTS.md` | 2,500 | 5,000 | Move format specs to `FORMATS.md` |
| Per-system knowledge (all files) | 3,000 | 6,000 | Review `schema.md` for outdated fields |
| Per-project knowledge (all files) | 2,500 | 5,000 | Review for outdated decisions |
| Single skill (when invoked) | 1,000 | 2,000 | Flag for skill author review |

---

## Process

### Phase 1 — Measure (AFK)

Read and measure every file below. Do not produce output during this phase.

**Auto-loaded files:**
1. `AGENTS.md` in the current project root
2. `docs/HANDOFF.md`
3. `docs/DEVLOG.md`
4. `docs/kanban.md`
5. `docs/CONTEXT.md`
6. `~/.codex/forge/SOUL.md`
7. `~/.codex/forge/PRINCIPLES.md`
8. `~/.codex/forge/preferences.md`
9. `~/.codex/forge/knowledge/company/acronyms.md`
10. `~/.codex/forge/knowledge/company/context.md`

**On-demand files (measure if they exist):**
11. All files in `docs/prd/active/`
12. `~/.codex/forge/knowledge/AGENTS.md`
13. All files in `~/.codex/forge/knowledge/systems/*/Wiki/` (if any systems exist)
14. All files in `~/.codex/forge/knowledge/projects/*/Wiki/` (if any projects exist)
15. All files in `docs/adr/` (ADRs loaded per-session in some workflows)

For each file: record path, character count, estimated tokens (`chars ÷ 4`), and status
(✅ Green / ⚠️ Amber / 🔴 Red) against the thresholds above.

**Source directories (child node scan):**

Scan the project's first-level source directories — common roots: `src/`, `app/`, `lib/`,
`packages/`, `services/`, `api/`, `components/`. For each:

- List subdirectories one level deep
- Sum all file character counts within each subdirectory (recursively)
- Estimate tokens (`chars ÷ 4`)
- Flag any subdirectory exceeding **20,000 tokens** as a child node candidate

Also check whether each flagged directory already has an `AGENTS.md` file. If it does,
skip it — the node already exists. Record: directory path, token estimate, existing node
(yes/no).

### Phase 2 — Calculate Budget

```
Auto-load total    = sum of tokens for files 1–10
On-demand total    = sum of tokens for files 11–15
Estimated session  = auto-load total + on-demand total
Remaining for conv = 100,000 - estimated session
```

Assign overall session budget status using the Budget Tiers table.

### Phase 3 — Report

```markdown
# Context Health Report

**Project:** [project name]
**Generated:** YYYY-MM-DD
**Previous report:** YYYY-MM-DD (or "First check")

---

## Session Budget

| Layer | Tokens | % of 100k |
|-------|--------|-----------|
| Auto-loaded (every session) | N | N% |
| On-demand (PRD, knowledge, skills) | N | N% |
| **Estimated session load** | **N** | **N%** |
| Remaining for conversation | N | N% |

**Overall status:** ✅ Green / ⚠️ Amber / 🔴 Red

---

## File Breakdown

### 🔴 Red — Immediate Action Required
| File | Tokens | Threshold | Action |
|------|--------|-----------|--------|
| docs/prd/active/feature.md | 18,400 | 15,000 | Archive completed sections |

### ⚠️ Amber — Monitor or Trim
| File | Tokens | Threshold | Action |
|------|--------|-----------|--------|
| docs/DEVLOG.md | 1,800 | 1,500 | Archive entries older than 3 sessions |

### ✅ Green — Within Budget
| File | Tokens |
|------|--------|
| docs/HANDOFF.md | 910 |
| docs/kanban.md | 230 |

---

## Trend

| Date | Auto-load | On-demand | Total | Status |
|------|-----------|-----------|-------|--------|
| YYYY-MM-DD | N | N | N | ✅ / ⚠️ / 🔴 |
| [previous] | N | N | N | |

(Trend populated from previous reports — shows whether load is growing or stable)

---

## Recommended Actions

[Numbered list of specific actions, highest priority first. Each action includes
the exact command or file to edit.]

1. `docs/prd/active/feature.md` (18,400 tokens 🔴) — archive the completed Implementation
   section to `docs/prd/archived/`. Estimated saving: ~6,000 tokens.
2. `docs/DEVLOG.md` (1,800 tokens ⚠️) — entries before [date] can be archived.
   Run `$debrief` at sprint end to keep DEVLOG compact automatically.

---

## Child Node Recommendations

[Only include this section if any source directories exceeded the 20k token threshold
and do not already have an AGENTS.md file. Omit entirely if no candidates found.]

| Directory | Tokens | Existing node? | Action |
|-----------|--------|----------------|--------|
| src/api/ | 34,200 | No | Create child AGENTS.md — see template below |
| src/components/ | 28,700 | No | Create child AGENTS.md — see template below |

**Child node template** — create `[directory]/AGENTS.md`:

```markdown
# [Directory Name] — Context Node

> Scope: [one sentence — what this directory owns]

## Ownership
[Which team, person, or system is responsible for this directory]

## Invariants
[Rules that must always hold — things that will break if violated]
- [e.g. "All API routes must validate the JWT before touching business logic"]

## Common Confusion Points
[Things that surprise new contributors or cause repeated mistakes]
- [e.g. "The `UserContext` here is the auth context, not the React context"]

## Enforced Patterns
[Conventions that must be followed — how things are done here]
- [e.g. "All errors wrapped in Result<T, AppError> — never throw directly"]
```

Run `$context-health` again after creating nodes — they will appear in subsequent scans.

---

*Generated by $context-health — read-only audit, no files were modified.*
```

### Phase 4 — Save and Notify

Save the report to `docs/context-health-report.md` (overwrite previous).

Update `~/.codex/forge/preferences.md`:
```
context-health-last-run: YYYY-MM-DD
```

If overall status is 🔴 Red, surface a prominent warning:
```
🔴 Context load is in the RED zone. Sessions will likely hit the 100k limit.
   Top action: [single most impactful fix from recommended actions]
   Full report: docs/context-health-report.md
```

### Phase 5 — Regenerate Dashboard

After saving the report, run `$dashboard-tokens` automatically to regenerate the token
usage dashboard with the latest context health data.

This keeps `docs/dashboard/index.html` current after every health check without requiring
a separate manual step. If `$dashboard-tokens` is not available or fails, note it but do
not block completion of the context health check.

---

## Sprint-Start Integration

`$sprint-start` checks `context-health-last-run` in `preferences.md`. If more than 7 days ago:

```
⚠️ Context health check overdue (last run: N days ago).
Consider running $context-health before this sprint begins.
```

---

## Running Weekly via /loop

To schedule weekly context health checks:

```
/loop 7d $context-health
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| File not found | Note as missing in report — do not error |
| No active PRD | Skip PRD measurement, note "No active PRD" |
| No systems or projects | Skip knowledge measurement, note accordingly |
| `preferences.md` missing | Create it with `context-health-last-run: YYYY-MM-DD` |
| Previous report missing | Run as first check, show "—" for trend |
| No standard source directories found | Skip child node scan — note "No source directories detected (looked for src/, app/, lib/, packages/, services/, api/, components/)" |
| All candidate directories already have AGENTS.md | Omit Child Node Recommendations section — note "All large directories already have context nodes" |
| Source directory scan is very large (500+ files) | Sample top 10 largest subdirectories only — note sampling in report |

---

## Rules

- Read-only throughout — never modify any file during the audit
- Token estimates use `chars ÷ 4` consistently — never use exact counts
- Never flag `~/.codex/forge/SOUL.md` or `~/.codex/forge/PRINCIPLES.md` for modification — they are
  framework files; flag them for awareness only
- Always include a Trend section — single data points are less useful than direction
- Recommended actions must be specific: file path, estimated saving, exact command
- Child node recommendations are advisory only — never create AGENTS.md files automatically
- Only recommend child nodes for directories without an existing AGENTS.md — never flag already-documented directories
- Never recommend child nodes for test directories, simple utilities, or directories with fewer than 5 files regardless of token count
- Child node scan is read-only — character counts only, no file modification
