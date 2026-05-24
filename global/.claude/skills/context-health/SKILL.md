---
name: context-health
description: Audit the token load profile of the current project's context files. Measures every file loaded into a session, estimates token cost, flags files that are growing too large, and recommends specific trimming actions. Run weekly or at sprint start. Saves a report to docs/context-health-report.md. Use when user runs /context-health or when sessions are regularly hitting context limits.
---

# Context Health

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
| `docs/HANDOFF.md` | 1,200 | 2,500 | Recompact via `/save-state` |
| `docs/DEVLOG.md` | 1,500 | 3,000 | Archive entries older than 3 sessions |
| `docs/kanban.md` | 800 | 1,500 | Archive completed tickets to `kanban-archive.md` |
| `docs/CONTEXT.md` | 2,000 | 4,000 | Review for redundancy; merge near-duplicate terms |
| `CLAUDE.md` (project) | 2,500 | 5,000 | Review for sections that can reference external files |
| `~/.claude/PRINCIPLES.md` | 1,800 | 3,500 | Framework file — flag but do not modify |
| `~/.claude/knowledge/company/acronyms.md` | 1,000 | 2,000 | Review for stale or duplicate entries |

### On-demand (loaded when relevant)

| File | Amber | Red | Default action |
|------|-------|-----|----------------|
| `docs/prd/active/*.md` | 8,000 | 15,000 | Archive completed sections; split large PRDs |
| `~/.claude/knowledge/CLAUDE.md` | 2,500 | 5,000 | Move format specs to `FORMATS.md` |
| Per-system knowledge (all files) | 3,000 | 6,000 | Review `schema.md` for outdated fields |
| Per-project knowledge (all files) | 2,500 | 5,000 | Review for outdated decisions |
| Single skill (when invoked) | 1,000 | 2,000 | Flag for skill author review |

---

## Process

### Phase 1 — Measure (AFK)

Read and measure every file below. Do not produce output during this phase.

**Auto-loaded files:**
1. `CLAUDE.md` in the current project root
2. `docs/HANDOFF.md`
3. `docs/DEVLOG.md`
4. `docs/kanban.md`
5. `docs/CONTEXT.md`
6. `~/.claude/SOUL.md`
7. `~/.claude/PRINCIPLES.md`
8. `~/.claude/preferences.md`
9. `~/.claude/knowledge/company/acronyms.md`
10. `~/.claude/knowledge/company/context.md`

**On-demand files (measure if they exist):**
11. All files in `docs/prd/active/`
12. `~/.claude/knowledge/CLAUDE.md`
13. All files in `~/.claude/knowledge/systems/*/Wiki/` (if any systems exist)
14. All files in `~/.claude/knowledge/projects/*/Wiki/` (if any projects exist)
15. All files in `docs/adr/` (ADRs loaded per-session in some workflows)

For each file: record path, character count, estimated tokens (`chars ÷ 4`), and status
(✅ Green / ⚠️ Amber / 🔴 Red) against the thresholds above.

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
   Run `/debrief` at sprint end to keep DEVLOG compact automatically.

---

*Generated by /context-health — read-only audit, no files were modified.*
```

### Phase 4 — Save and Notify

Save the report to `docs/context-health-report.md` (overwrite previous).

Update `~/.claude/preferences.md`:
```
context-health-last-run: YYYY-MM-DD
```

If overall status is 🔴 Red, surface a prominent warning:
```
🔴 Context load is in the RED zone. Sessions will likely hit the 100k limit.
   Top action: [single most impactful fix from recommended actions]
   Full report: docs/context-health-report.md
```

---

## Sprint-Start Integration

`/sprint-start` checks `context-health-last-run` in `preferences.md`. If more than 7 days ago:

```
⚠️ Context health check overdue (last run: N days ago).
Consider running /context-health before this sprint begins.
```

---

## Running Weekly via /loop

To schedule weekly context health checks:

```
/loop 7d /context-health
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

---

## Rules

- Read-only throughout — never modify any file during the audit
- Token estimates use `chars ÷ 4` consistently — never use exact counts
- Never flag `~/.claude/SOUL.md` or `~/.claude/PRINCIPLES.md` for modification — they are
  framework files; flag them for awareness only
- Always include a Trend section — single data points are less useful than direction
- Recommended actions must be specific: file path, estimated saving, exact command
