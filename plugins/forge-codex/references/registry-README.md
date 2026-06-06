# Forge ID Registry

Global sequential ID registry for cross-project entity tracking. Managed automatically by Forge skills — do not edit manually unless correcting a specific entry.

---

## What's Tracked

| ID Type | Prefix | Assigned by | Scope |
|---------|--------|-------------|-------|
| Ideas | `IDEA-NNN` | `$idea` at pitch start | Global |
| Projects | `PROJ-NNN` | `$create-project` or `$onboard` | Global |
| Test cases | `TC-NNN` | `$testplan` when confirmed | Per-project (in `docs/tests/registry.md`) |

---

## How IDs Work

- Sequential, prefixed, human-readable — `IDEA-001`, `PROJ-001`
- Assigned at creation, never reused — declined ideas and deprecated projects keep their IDs
- Referenced in source documents: `idea.md`, `AGENTS.md`, testplan files
- Bidirectional cross-references: `idea.md` ↔ `AGENTS.md` ↔ this registry

---

## Looking Up an Entity

Run `lookup IDEA-003` (or any valid ID) to get a summary, status, cross-references, and file path.

---

## Conflict Resolution

If a counter increment fails or two sessions conflict, the rule is: never reuse an ID. Increment until a free ID is found. If you discover a duplicate manually, keep the lower-numbered entry and renumber the duplicate to the next available ID, updating all document references.

---

## Files

- `registry.md` (this file's companion) — counters, idea registry, project registry, cross-reference links
- `docs/tests/registry.md` in each project — TC-NNN counter and test case index
