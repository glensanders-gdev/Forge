# Context Health Report

**Project:** Forge (framework repo)
**Generated:** 2026-07-13
**Previous report:** 2026-06-11

---

## Session Budget

| Layer | Tokens | % of 100k |
|-------|--------|-----------|
| Auto-loaded (every session) | 14,168 | 14% |
| On-demand (knowledge, ADR, memory) | 8,335 | 8% |
| **Estimated session load** | **22,503** | **23%** |
| Remaining for conversation | 77,497 | 77% |

**Overall status:** ✅ Green

Notes:
- Active company is **nbn** — company knowledge measured from `~/.claude/companies/nbn/knowledge/`.
- This repo injects `Forge/global/.claude/rules/` (12 files: README + 6 common + 5 typescript, 4,848 tokens) into every session via global instructions — included in the auto-loaded total.
- On-demand load is dominated by skill invocations (1–8.8k tokens each, variable per session) plus the per-project knowledge below, which only loads when working those projects.

---

## File Breakdown

### 🔴 Red — Immediate Action Required

| File | Tokens | Threshold | Action |
|------|--------|-----------|--------|
| `~/.claude/knowledge/projects/fftcg-simulator/Wiki/` (6 files) | 5,347 | 5,000 | Largest files: `fftcg-faq-rulings.md` (2,147), `fftcg-errata.md` (1,544). Only loads in fftcg-simulator sessions, not Forge — review those two for entries that can be condensed or split when next working that project. |
| Skill portfolio (carried from 2026-06-11) | 2,076–8,765 each | 2,000/skill | 20 skills still exceed the single-skill red threshold — see `docs/skill-size-audit.md`. Top offenders: company-add (8,765), graphify (8,486), dashboard-tokens (8,375). Fix: extract embedded templates to `references/` folders. |

### ⚠️ Amber — Monitor or Trim

| File | Tokens | Threshold | Action |
|------|--------|-----------|--------|
| `docs/DEVLOG.md` | 1,831 | 1,500 | Archive entries older than 3 sessions; `/debrief` keeps it compact. |
| `docs/kanban.md` | 1,260 | 800 | Board is fully Done (Junction Sync approved 2026-06-01) — archive completed tickets to `docs/kanban-archive.md`. Estimated saving: ~1,000 tokens. Same finding as last report, still outstanding. |
| Injected rules set (12 files) | 4,848 | ~5,000 (watch set 2026-06-11) | Crossed the watch line flagged last report (was 3,526; TypeScript rules + README now injected). Consider excluding `rules/README.md` (567 tokens) from injection — it's contributor docs, not standards. |

### ✅ Green — Within Budget

| File | Tokens |
|------|--------|
| CLAUDE.md (project, `Forge/CLAUDE.md`) | 943 |
| docs/HANDOFF.md | 807 |
| ~/.claude/CLAUDE.md (forge-init output) | 430 |
| ~/.claude/PRINCIPLES.md | 1,508 (framework file — awareness only) |
| ~/.claude/SOUL.md | 629 (framework file — awareness only) |
| ~/.claude/preferences.md | 143 |
| nbn `knowledge/company/acronyms.md` | 898 (near 1,000 amber — watch) |
| nbn `knowledge/company/context.md` | 785 |
| Memory index + 2 memory files | 86 auto + 653 on-demand |
| `docs/adr/0001-…symmetric-ids.md` | 1,433 (on-demand) |
| `~/.claude/knowledge/projects/lilydale-bowmen/Wiki/` (3 files) | 902 (on-demand) |

**Missing (not errors):** `docs/CONTEXT.md`, `~/.claude/knowledge/CLAUDE.md`. No active PRD in `docs/prd/active/`. No system knowledge folders (global or nbn). nbn systems/projects knowledge folders exist but are empty.

---

## Trend

| Date | Auto-load | On-demand | Total | Status |
|------|-----------|-----------|-------|--------|
| 2026-07-13 | 14,168 | 8,335 | 22,503 | ✅ |
| 2026-06-11 | 8,070 | 0 (+skills) | ~8,070 | ✅ |

Auto-load grew +6,098 tokens (+76%) in a month. Drivers: nbn company setup (acronyms + context + expanded global CLAUDE.md, ~1,700), TypeScript rules installed via /lang-rules (~1,320), DEVLOG/kanban/HANDOFF growth (~3,600). Still comfortably Green, but the growth rate would reach Amber (30k) in roughly 3 months if unchecked.

---

## Recommended Actions

1. `docs/kanban.md` (1,260 tokens ⚠️, outstanding since 2026-06-11) — archive all Done tickets to `docs/kanban-archive.md` under a "Junction Sync" heading. Saving: ~1,000 tokens per session. Happens automatically at next `/sprint-end`.
2. `docs/DEVLOG.md` (1,831 tokens ⚠️) — archive entries older than the last 3 sessions to `docs/devlog-archive.md`. Saving: ~800–1,000 tokens per session.
3. Injected rules set (4,848 tokens, crossed the ~5k watch line) — stop injecting `rules/README.md` (contributor documentation, not a coding standard). Saving: ~570 tokens per session across **all** projects.
4. Skill slimming (🔴, recurring per-invocation cost, carried from last report) — extract dashboard-tokens' embedded HTML template to `references/dashboard-template.html`. Saving: ~5–6k tokens per invocation.
5. fftcg-simulator knowledge (5,347 tokens 🔴) — when next in that project, condense `fftcg-faq-rulings.md` or split it by card set. No impact on Forge sessions.

---

## Child Node Recommendations

No standard source roots (src/, app/, lib/, packages/, services/, api/, components/) exist — scan performed on `Forge/` first-level directories instead:

| Directory | Tokens (est) | Existing node? | Action |
|-----------|--------------|----------------|--------|
| Forge/global/ | ~281,600 | No | Create child AGENTS.md — this is the source of truth for 108 skills; a node stating skill-authoring invariants (HITL/AFK declaration, never-rules, Codex regen requirement) would save re-deriving them per session. |
| Forge/plugins/ | ~260,900 | No | Minimal AGENTS.md: "Generated output from tools/build-forge-codex.ps1 — never edit manually, regenerate instead." Cheap insurance against accidental hand-edits. |
| Forge/graphify-out/ | ~514,000 | No | Generated output — no node recommended; consider gitignoring or pruning if not needed in the repo. |
| Forge/docs/ | ~19,950 | No | Just under 20k threshold — no action; monitor. |
| Forge/tools/ | ~19,850 | No | Just under threshold, only 10 files — no action. |

**Child node template** — create `[directory]/AGENTS.md`:

```markdown
# [Directory Name] — Context Node

> Scope: [one sentence — what this directory owns]

## Ownership
[Which team, person, or system is responsible for this directory]

## Invariants
[Rules that must always hold — things that will break if violated]

## Common Confusion Points
[Things that surprise new contributors or cause repeated mistakes]

## Enforced Patterns
[Conventions that must be followed — how things are done here]
```

---

*Generated by /context-health — read-only audit, no files were modified.*
