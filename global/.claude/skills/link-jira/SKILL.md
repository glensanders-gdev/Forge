---
name: link-jira
category: framework
description: Link a Forge ID (IDEA-NNN or PROJ-NNN) to a Jira ID (ticket, epic, or capability). Writes the mapping to the source file and updates registry.md. Keeps a full history of superseded IDs. Use when user runs /link-jira, raises a Jira ticket from an idea, or promotes a project to a Jira Epic or Capability.
---

# Link Jira

> **Company-aware:** When `active_company` is set in `~/.claude/preferences.md` (configured by `/company-add`), `registry.md` updates are written to `~/.claude/companies/[active_company]/registry.md` and idea/project files are resolved from the company directory.

Map a Forge ID to a Jira ID. Keeps the full history of external ID changes — never overwrites.

---

## Usage

```
/link-jira [FORGE-ID] [JIRA-ID]
/link-jira [FORGE-ID] [JIRA-ID] --type [ticket|epic|capability]
/link-jira [FORGE-ID] [JIRA-ID] --reason "[reason for change]"
```

Examples:
```
/link-jira IDEA-003 PROJ-123
/link-jira PROJ-001 EPIC-456 --type epic
/link-jira PROJ-001 CAP-12 --type capability --reason "promoted from Epic"
```

If `--type` is omitted, always ask once before writing — do not infer from the Jira ID prefix.
Jira project keys are company-configured and carry no reliable type information.
If `--reason` is omitted and a current ID is being superseded, ask for the reason before writing.

---

## Process

1. **Parse arguments** — extract Forge ID and Jira ID
2. **Infer entity type** from Forge ID prefix:
   - `IDEA-` → idea, file at `~/.claude/ideas/active/[slug]/idea.md`
   - `PROJ-` → project, file at `~/.claude/knowledge/projects/[slug]/Wiki/overview.md`
3. **Look up file path** from `~/.claude/registry.md` using the Forge ID
   - If not found in registry, report error and stop
4. **Read current `external_ids` block** from the file (may not exist yet)
5. **Determine action**:
   - No existing Jira ID → set as `current`, no superseded entry needed
   - Existing Jira ID present → move `current` to `superseded` with today's date and reason,
     set new ID as `current`
6. **Write updated `external_ids` block** to the file:

```yaml
external_ids:
  jira:
    current: [JIRA-ID]
    type: ticket | epic | capability
    linked: YYYY-MM-DD
    superseded:
      - id: [OLD-JIRA-ID]
        type: ticket | epic | capability
        date: YYYY-MM-DD
        reason: [reason]
```

7. **Update `~/.claude/registry.md`** — write Jira ID to the `External ID` column for the Forge ID row
8. **Confirm** — display the updated mapping and the full ID history

---

## External IDs Block Format

```yaml
external_ids:
  jira:
    current: PROJ-123
    type: ticket
    linked: 2026-05-24
    superseded: []
```

When superseded:

```yaml
external_ids:
  jira:
    current: EPIC-456
    type: epic
    linked: 2026-06-01
    superseded:
      - id: PROJ-123
        type: ticket
        date: 2026-06-01
        reason: promoted to Epic
```

---

## Registry Update

In `~/.claude/registry.md`, the Idea Registry and Project Registry tables gain an `External ID` column:

```markdown
| IDEA-003 | My Idea | Active | PROJ-123 (Jira ticket) | ~/.claude/ideas/active/my-idea/ |
| PROJ-001 | My Project | Active | EPIC-456 (Jira epic) | ~/.claude/knowledge/projects/my-project/ |
```

When an ID is superseded, the registry shows the current ID only. Full history lives in the source file.

---

## Rules

- Never overwrite a Jira ID without recording the superseded entry with date and reason
- Always confirm the mapping and display full ID history after writing
- If the Forge ID is not found in registry.md, stop and report — do not guess file paths
- `external_ids` block is optional — entities without Jira links simply omit it
