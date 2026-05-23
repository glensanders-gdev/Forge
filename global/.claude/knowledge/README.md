# Forge Knowledge Base

A personal knowledge layer available across all projects. The AI references these files during sessions — either automatically on session start (for company-wide context) or on demand when a ticket or task requires it.

---

## Structure

```
knowledge/
  company/
    acronyms.md          ← company terminology, loaded every session
    framework/
      example-process.md ← template: copy for each business process
  systems/
    [system-name]/
      overview.md        ← what the system is and what AI can/can't do
      schema.md          ← data structures and field definitions
      known-issues.md    ← constraints, limitations, hard stops
```

---

## Adding a New Process

1. Copy `company/framework/example-process.md`
2. Rename it to the process name (lowercase, hyphens — e.g. `onboarding.md`, `invoice-approval.md`)
3. Fill in the systems involved, steps, inputs, outputs, and AI capabilities/limits
4. Reference it in your project's `CLAUDE.md` or kanban tickets where relevant

---

## Adding a New System

1. Create a folder under `systems/` named after the system (lowercase, hyphens)
2. Copy the three template files from `systems/example-system/`
3. Fill in what you know — incomplete is fine, add to it over time
4. Reference it in your project's `CLAUDE.md` or kanban tickets where relevant

---

## How the AI Uses This

### Loaded automatically every session
- `knowledge/company/acronyms.md` — via the global `CLAUDE.md` session start

### Loaded on demand
- `knowledge/systems/[name]/overview.md` — when a session or ticket involves that system
- `knowledge/systems/[name]/schema.md` — when working with that system's data
- `knowledge/systems/[name]/known-issues.md` — before proposing any solution involving that system

### Referenced from project CLAUDE.md
Add a line to a project's `CLAUDE.md` to auto-load system knowledge relevant to that project:
```
- Read `~/.claude/knowledge/systems/salesforce/overview.md` on session start
```

### Referenced from kanban tickets
```
- [ ] [AFK] #4 Build Salesforce sync `ref: ~/.claude/knowledge/systems/salesforce/`
```

---

## Conventions

- Keep files focused — one system or one process per file
- "Do Not Attempt" in `known-issues.md` are hard stops — the AI must flag before proceeding
- "What an AI Cannot Do Here" in process files defines human-only steps — the AI defers on these
- Update `Last updated` date when making significant changes
- Never delete entries from `known-issues.md` — mark resolved ones as such with a date
- Process files in `framework/` should reference system files in `systems/` rather than duplicating system detail
