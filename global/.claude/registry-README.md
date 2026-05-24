# Forge ID Registry

Global sequential ID registry for cross-project entity tracking. Managed automatically by Forge skills — do not edit manually unless correcting a specific entry.

---

## What's Tracked

| ID Type | Prefix | Assigned by | Scope |
|---------|--------|-------------|-------|
| Ideas | `IDEA-NNN` | `/idea` at pitch start | Global |
| Projects | `PROJ-NNN` | `/create-project` or `/onboard` | Global |
| Test cases | `TC-NNN` | `/testplan` when confirmed | Per-project (in `docs/tests/registry.md`) |

---

## How IDs Work

- Sequential, prefixed, human-readable — `IDEA-001`, `PROJ-001`
- Assigned at creation, never reused — declined ideas and deprecated projects keep their IDs
- Referenced in source documents: `idea.md`, `CLAUDE.md`, testplan files
- Bidirectional cross-references: `idea.md` ↔ `CLAUDE.md` ↔ this registry
- External IDs (Jira tickets, epics, capabilities) mapped via `/link-jira` — stored in the
  source file (`external_ids.jira`) and reflected in the registry `External ID` column
- External ID history is never overwritten — full superseded list with dates lives in the source file

---

## Looking Up an Entity

Run `/user:lookup IDEA-003` (or any valid ID) to get a summary, status, cross-references, and file path.

---

## Conflict Resolution

If a counter increment fails or two sessions conflict, the rule is: never reuse an ID. Increment until a free ID is found. If you discover a duplicate manually, keep the lower-numbered entry and renumber the duplicate to the next available ID, updating all document references.

---

## Registry Table Format

Idea Registry and Project Registry tables include an `External ID` column:

```markdown
| IDEA-003 | My Idea       | Active   | PROJ-123 (Jira ticket) | ~/.claude/ideas/active/my-idea/              |
| PROJ-001 | My Project    | Active   | EPIC-456 (Jira epic)   | ~/.claude/knowledge/projects/my-project/     |
| IDEA-005 | Another Idea  | Holding  | —                      | ~/.claude/ideas/active/another-idea/         |
```

When a Jira ID is superseded, the registry shows only the current ID.
Full history (all superseded IDs with dates and reasons) lives in the source `idea.md` or `overview.md`.

---

## Files

- `registry.md` (this file's companion) — counters, idea registry, project registry, cross-reference links
- `docs/tests/registry.md` in each project — TC-NNN counter and test case index
