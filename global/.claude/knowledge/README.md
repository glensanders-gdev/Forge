# Forge Knowledge Base

A personal knowledge layer available across all projects. The AI references these files during sessions — either automatically on session start (for company-wide context) or on demand when a ticket or task requires it.

The AI acts as a librarian: humans add source material to `Raw/`, the AI compiles and maintains `Wiki/`, and generates artifacts into `Outputs/`. See `CLAUDE.md` for full librarian instructions.

---

## Structure

```
knowledge/
  CLAUDE.md              ← librarian instructions (read this first)
  Raw/                   ← source material intake (humans write here)
  Wiki/                  ← compiled knowledge (AI writes and maintains)
  Outputs/               ← generated artifacts (AI produces on demand)
  company/
    acronyms.md          ← company terminology, loaded every session
    context.md           ← domain concepts and business language
    style-guide.md       ← writing standards and approved terminology
    pii-categories.md    ← PII classification reference
    framework/
      example-process.md ← template: copy for each business process
  systems/
    [system-name]/
      Raw/               ← source docs, API dumps, vendor docs, meeting notes
      Wiki/
        overview.md      ← what the system is and what AI can/can't do
        schema.md        ← data structures and field definitions
        known-issues.md  ← constraints, limitations, hard stops
        _index.md        ← system-level wiki index
        _changelog.md    ← significant change log
      Outputs/           ← generated reports, query answers, diagrams
  projects/
    [project-name]/
      Raw/               ← research, meeting notes, requirements, external refs
      Wiki/
        overview.md      ← what the project is and its current state
        decisions.md     ← key decisions and rationale
        known-issues.md  ← constraints, blockers, hard stops
        _index.md        ← project-level wiki index
        _changelog.md    ← significant change log
      Outputs/           ← generated reports, analysis, diagrams
```

---

## Adding a New System

Run `/add-system` — it scaffolds the full `Raw/Wiki/Outputs` structure and stub files automatically.

---

## Adding a New Project

Run `/add-project` — it scaffolds the full `Raw/Wiki/Outputs` structure and stub files automatically.
Distinct from the project's `docs/` directory: `docs/` holds session state; `knowledge/projects/`
holds durable domain knowledge.

After creation:
1. Fill in `Wiki/overview.md` first
2. Add the system to the relevant project's `CLAUDE.md` Knowledge References table

---

## Adding a New Process

1. Copy `company/framework/example-process.md`
2. Rename it to the process name (lowercase, hyphens — e.g. `onboarding.md`, `invoice-approval.md`)
3. Fill in the systems involved, steps, inputs, outputs, and AI capabilities/limits
4. Reference it in your project's `CLAUDE.md` or kanban tickets where relevant

---

## How the AI Uses This

### Loaded automatically every session
- `knowledge/company/acronyms.md` — via the global `CLAUDE.md` session start

### Loaded on demand
- `knowledge/systems/[name]/Wiki/overview.md` — when a session or ticket involves that system
- `knowledge/systems/[name]/Wiki/schema.md` — when working with that system's data
- `knowledge/systems/[name]/Wiki/known-issues.md` — before proposing any solution involving that system

### Referenced from project CLAUDE.md
Add a line to a project's `CLAUDE.md` to auto-load system knowledge relevant to that project:
```
- Read `~/.claude/knowledge/systems/salesforce/Wiki/overview.md` on session start
```

### Referenced from kanban tickets
```
- [ ] [AFK] #4 Build Salesforce sync `ref: ~/.claude/knowledge/systems/salesforce/`
```

---

## Conventions

- `Raw/` files follow the naming convention: `YYYY-MM-DD_[source-slug].[ext]`
- "Do Not Attempt" in `Wiki/known-issues.md` are hard stops — the AI must flag before proceeding
- "What an AI Cannot Do Here" in process files defines human-only steps — the AI defers on these
- Never delete entries from `Wiki/known-issues.md` — mark resolved ones as such with a date
- Process files in `framework/` should reference system files in `systems/` rather than duplicating system detail
- Run `/ingest` after adding new files to any `Raw/` folder to compile them into the Wiki
