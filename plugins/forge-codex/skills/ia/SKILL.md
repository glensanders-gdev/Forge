---
name: "ia"
description: "Impact assessment for a proposed change — searches all knowledge sources, conducts a full grill-with-docs session to sharpen the change, then produces a severity-tagged impact summary, adaptive PRD or change brief, and draft artefacts. Use when user runs $ia, proposes a change to a knowledge file, process, or system and wants to understand the blast radius before committing."
metadata:
  category: knowledge
  version: 1.3.0
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# IA — Impact Assessment

Assess the impact of a proposed change before it is committed. Produces a severity-tagged summary, an adaptive PRD or change brief, and draft artefacts for any affected knowledge files — all written to an isolated IA folder. Never writes to the live knowledge structure.

## Process

### 1. Assign an ID and Search Knowledge Sources

Create `docs/ia/` if it does not exist. Scan for the highest existing `NNNN` on today's date in `docs/ia/` and increment — if none exist for today, start at `0001`. Assign the ID:

`IA-YYYYMMDD-NNNN` (e.g. `IA-20260604-0001`)

Output folder: `docs/ia/IA-YYYYMMDD-NNNN/`

**Use the actual assigned ID in all file paths throughout this skill — never the placeholder.**

Then search all of the following in parallel — results feed directly into the grill:

| Source | Location |
|--------|----------|
| Knowledge | `~/.codex/forge/knowledge/` (includes company knowledge) |
| Domain glossary | `docs/CONTEXT.md`, `docs/CONTEXT-MAP.md` |
| ADRs | `docs/adr/` |
| RAID log | `docs/**/*raid*.md` |
| Backlog | `docs/**/*backlog*.md` |

### 2. Grill the Proposed Change (HITL)

Run a full `$grill-with-docs` session using the knowledge sources loaded in step 1 as live context:

- Ask questions **one at a time** — provide your recommended answer before waiting
- If a question can be answered from the loaded knowledge sources, answer it directly instead of asking
- Challenge terminology against `docs/CONTEXT.md` if it exists — flag conflicts before continuing
- Walk each branch depth-first in this order:

```
What changes
  └── Affected dependencies
Why
Scope
  ├── Rollback strategy
  ├── Deployment timing
  └── Feature toggle required?
```

End the grill with a **Shared Understanding Summary** (decisions made, open questions if any) and wait for explicit confirmation before proceeding.

Write the confirmed summary to `docs/ia/[assigned IA ID]/grill-summary.md`.

### 3. Write Artefacts

Write all files to `docs/ia/[assigned IA ID]/`:

**`summary.md`** — header line: `# Impact Assessment [assigned IA ID] — YYYY-MM-DD`. Then an overall severity verdict (High / Medium / Low), followed by a severity-tagged impact list: each row shows the affected item, severity, and a one-line rationale.

If no impacted sources are found, write `summary.md` with an explicit **"No impacts identified"** verdict and omit `.proposed.md` files.

**`change-brief.md`** or **`prd.md`** — adaptive format:
- Knowledge or process change → `change-brief.md` with these headings:
  ```
  ## Problem
  ## Proposed Change
  ## Affected Areas
  ## Success Criteria
  ## Rollback
  ```
- Feature or system addition → full `prd.md`

**`[source-slug].proposed.md`** — one draft file per affected source. Derive the slug from the source file path: join path segments with hyphens and strip the `.md` extension (e.g. `~/.codex/forge/knowledge/company/context.md` → `knowledge-company-context.proposed.md`).

Each `.proposed.md` uses this structure:
```
## Before
[original content of the affected section]

## After
[proposed replacement content]
```

These are advisory drafts; they do not replace or modify the originals.

### 4. Stop

Present a closing line with the resolved ID:
`[assigned IA ID] complete. Output written to docs/ia/[assigned IA ID]/`

Do not suggest next steps. The user decides whether to act on the assessment.

## Rules

- Never write to live knowledge files — all output is isolated to the IA folder
- Never suggest next steps or stakeholder actions — that is the user's responsibility
- Never skip the grill phase — a vague input produces a vague assessment
- Ask grill questions one at a time, always provide the recommended answer first
- Use the actual assigned ID in all file paths — never the placeholder `IA-YYYYMMDD-NNNN`
- The IA ID must appear in the folder name, `summary.md` header, and PRD/change brief title
