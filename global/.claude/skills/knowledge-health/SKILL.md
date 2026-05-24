---
name: knowledge-health
version: 1.0.0
description: Run a read-only diagnostic across all Forge knowledge layers — system knowledge, company glossaries, and project CONTEXT.md files. Reports structural health, cross-reference findings, and interesting connections. Saves to ~/.claude/knowledge/health-report.md. Use when user runs /knowledge-health or when /sprint-start flags the last check was more than 30 days ago.
---

# Knowledge Health

Read-only diagnostic across all Forge knowledge layers. Never modifies files. Reports findings with specific actionable suggestions — the human decides what to act on.

## When to Use

- User runs `/user:knowledge-health` explicitly
- `/sprint-start` flags the last health check was more than 30 days ago
- After a period of intensive knowledge base changes
- Before a PI planning session

---

## Phase 1 — AFK Scan

Read all knowledge files before producing any output. Never write during this phase.

### 1. Load Previous Report

Read `~/.claude/knowledge/health-report.md` if it exists — extract last check date and coverage scores for comparison.

### 2. Scan Three-Tier Knowledge Structure

For each knowledge space (global, each system in `systems/`, each project in `projects/`):

- **Raw orphans** — read `Raw/_compiled.log`; identify any Raw files not listed as `compiled`.
  Flag as orphans if older than 7 days (recently added files get a grace period).
- **Wiki conflicts** — scan all `.md` files in `Wiki/` for `conflict: true` in frontmatter.
  Collect title, `conflict_sources`, and `last_updated` for each.
- **Stale Outputs** — list files in `Outputs/` older than `outputs_ttl_days` from
  `~/.claude/knowledge/CLAUDE.md` frontmatter (default 90 days) with no matching
  `source: outputs/[filename]` reference in any Wiki article. Flag as cleanup candidates.
- **Projects coverage** — for each folder in `~/.claude/knowledge/projects/`, check for
  required Wiki files: `overview.md`, `decisions.md`, `known-issues.md`, `_index.md`, `_changelog.md`.

### 3. Scan System Knowledge

For each folder in `~/.claude/knowledge/systems/`:

- Check for required files: `overview.md`, `schema.md`, `known-issues.md`
- Read `Last updated` date from each file header
- Check against `staleness-warning-days` in `~/.claude/preferences.md` (default 90 days)
- Extract all "Do Not Attempt" entries from `known-issues.md`
- Note any system names referenced in `~/.claude/registry.md`, active PRDs, or ADRs that have no folder

### 3. Scan Company Knowledge

Read `~/.claude/knowledge/company/acronyms.md`:
- Check `Last updated` date
- Note any acronyms that appear without definitions

Read `~/.claude/knowledge/company/context.md`:
- Check `Last updated` date
- Extract all `_Needs enrichment_` flagged terms
- Extract all Flagged Ambiguities — note which are unresolved

Check `~/.claude/knowledge/company/style-guide.md`:
- If missing: flag as P1 — "Style guide not found. Run `/user:knowledge-onboard` to set it up."
- If present but all sections are placeholders: flag as P1 — "Style guide exists but is unpopulated. Fill in before running `/user:style-check`."
- If partially populated: flag as P2 — note which sections are still placeholder

### 4. Scan Project CONTEXT.md Files

For each active project (from `~/.claude/registry.md`):
- Read `docs/CONTEXT.md`
- Extract all `_Needs enrichment_` terms
- Extract all Flagged Ambiguities — note age (date flagged vs today)
- Identify terms that appear in multiple project CONTEXT.md files — candidates for promotion to company level
- Identify terms used in project CONTEXT.md that don't exist in `~/.claude/knowledge/company/context.md`

### 5. Cross-Reference Active Projects

For each active project:
- Read `docs/prd/active/` — identify systems and external dependencies mentioned
- Read `docs/adr/` — identify systems referenced in decisions
- Cross-reference against `~/.claude/knowledge/systems/` — flag any referenced system with no knowledge folder
- Cross-reference active PRD content against `known-issues.md` "Do Not Attempt" entries — flag direct conflicts as P1

### 6. Identify Interesting Connections

Reason across all files read:
- Does any system's `known-issues.md` describe a pattern that implies risk for another system?
- Do any flagged ambiguities across projects suggest a company-level disambiguation is needed?
- Are there terms or patterns that appear in multiple projects independently — suggesting shared knowledge worth centralising?

Ground all connections in specific file references — no speculation beyond what the files say.

---

## Phase 2 — Report

### Coverage Scorecard

Calculate and present at the top of the report:

```markdown
## Knowledge Base Coverage — YYYY-MM-DD

| Layer | Coverage | Change |
|-------|----------|--------|
| System knowledge (files complete) | N/N systems (N%) | ↑ +N% / ↓ -N% / — (first check) |
| Company acronyms (defined) | N/N acronyms (N%) | ↑ / ↓ / — |
| Company concepts (enriched) | N/N terms (N%) | ↑ / ↓ / — |
| Project CONTEXT.md (ambiguities resolved) | N/N (N%) | ↑ / ↓ / — |

**Overall health score:** N% (weighted average)
**Last check:** YYYY-MM-DD | **Change since last check:** ↑ improved / ↓ declined / — first check
```

### P1 — Structural Health

```markdown
## P1 — Structural Health

### Wiki Conflicts (requires human resolution)
| Space | Article | Conflict Sources | Flagged |
|-------|---------|-----------------|---------|
| systems/salesforce | overview.md | vendor-docs-2026.md vs meeting-notes.md | 2026-05-01 |

→ Run /ingest [space] after resolving — conflict: true must be manually cleared.

### Raw Orphans (uncompiled source material)
| Space | File | Age |
|-------|------|-----|
| global | 2026-04-10_some-article.md | 44 days |

→ Run /ingest [space] to compile.

### Stale Outputs (no filed-back Wiki entry, older than TTL)
| Space | File | Age | Action |
|-------|------|-----|--------|
| projects/my-project | 2026-02-01_analysis.md | 112 days | File back or delete |

### Stale Files
| File | Last updated | Days stale | Action |
|------|-------------|-----------|--------|
| ~/.claude/knowledge/systems/salesforce/overview.md | 2025-08-01 | 294 days | Run /summarise-system salesforce |

### Missing Required Files
| Space | Type | Missing | Action |
|-------|------|---------|--------|
| systems/legacy-crm | system | Wiki/schema.md | Run /add-system legacy-crm to scaffold |
| projects/my-project | project | Wiki/decisions.md | Run /add-project my-project to scaffold |

### Unresolved Flagged Ambiguities
| File | Term | Flagged | Age | Action |
|------|------|---------|-----|--------|
| PROJ-001/docs/CONTEXT.md | "account" | 2025-11-01 | 203 days | Run /grill-with-docs to resolve |

### Systems Referenced But Not Documented
| Referenced in | System | Action |
|--------------|--------|--------|
| ADR-0003.md | Kafka | Run /add-system kafka to create knowledge folder |

### Company Terms Used But Not Defined
| Term | Used in | Action |
|------|---------|--------|
| "subscriber" | PROJ-002/docs/CONTEXT.md | Run /add-term subscriber |
```

### P2 — Cross-Reference Findings

```markdown
## P2 — Cross-Reference Findings

### Do Not Attempt Conflicts
⚠️ Active PRD conflicts with known system limitations:

| PRD | System | Known Issue | Risk |
|-----|--------|------------|------|
| prd/active/auth-redesign.md | salesforce | "Do not use Bulk API for real-time auth" | Auth PRD proposes Bulk API for session sync |

→ Review auth-redesign.md section 3.2 against salesforce/known-issues.md before building.

### Cross-System Risk Patterns
| System A | Issue | Implied risk for System B |
|----------|-------|--------------------------|
| legacy-db | "No transaction rollback support" | payment-api relies on legacy-db for order commits — rollback failure would leave orders in inconsistent state |

→ Consider adding a known issue entry to payment-api/known-issues.md.
```

### P3 — Interesting Connections

```markdown
## P3 — Interesting Connections

### Promotion Candidates (project terms → company level)
These terms appear in multiple project CONTEXT.md files independently — worth promoting to ~/.claude/knowledge/company/context.md:

| Term | Projects | Suggested definition |
|------|---------|---------------------|
| "service order" | PROJ-001, PROJ-002, PROJ-003 | [synthesised definition from all three files] |

→ Run /add-term "service order" to create a canonical company-level definition.

### New Article Candidates
These patterns in the knowledge base suggest new system articles worth writing:

- salesforce/known-issues.md and legacy-db/known-issues.md both describe data sync timing issues — a "Data Sync Patterns" article in the knowledge base would consolidate this.

### Knowledge Gaps
These topics appear in ADRs or PRDs but have no knowledge base coverage:

- API rate limiting strategies — referenced in 3 ADRs, no system article
- Data retention policies — referenced in 2 PRDs, no company-level guidance
```

---

## Save Report

Write full report to `~/.claude/knowledge/health-report.md`:

```markdown
# Knowledge Health Report

**Generated:** YYYY-MM-DD HH:MM
**Previous report:** YYYY-MM-DD (or "First check")

[Full report content as above]

---
*Generated by /knowledge-health — read-only diagnostic, no files were modified.*
```

Update `Last checked` field in `~/.claude/preferences.md`:
```
knowledge-health-last-run: YYYY-MM-DD
```

---

## Sprint-Start Integration

When `/sprint-start` runs, check `knowledge-health-last-run` in `preferences.md`. If more than 30 days ago:

```
⚠️ Knowledge base health check overdue (last run: N days ago).
Consider running /user:knowledge-health before this sprint begins.
```

---

## Rules

- Never modify any file during the health check — read-only throughout
- Ground all P3 connections in specific file references — no speculation
- P1 findings are problems to fix — always include a specific skill suggestion
- P2 findings are risks to assess — always include the specific file conflict
- P3 findings are opportunities — framed as suggestions, not urgencies
- If no issues found in a section, say "✅ No issues found" — never omit sections
- Coverage scores compare against previous report — first run shows "—" for change

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No system knowledge folder exists | Note "No system knowledge base found. Run /add-system to start building." |
| No company context files | Note "Company context files not found. Run /add-term to start building." |
| No active projects | Run health check on global knowledge only |
| No projects/ folder | Note "No project knowledge base found. Run /add-project to start building." |
| Previous report missing | Run as first check, show "—" for all change fields |
| `preferences.md` missing staleness threshold | Default to 90 days |
| `CLAUDE.md` missing `outputs_ttl_days` | Default to 90 days for stale Outputs check |
