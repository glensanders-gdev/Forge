---
name: lookup
description: Find any entity by ID — IDEA-NNN, PROJ-NNN, or TC-NNN. Returns a summary of the entity, its current status, cross-references, and file path. Use when user runs /lookup [ID] or wants to find something by its ID.
---

# Lookup

Find any Forge entity by its unique ID. Resolves IDEA, PROJ, and TC IDs to their source documents and returns a summary.

## Usage

```
/lookup IDEA-003
/lookup PROJ-001
/lookup TC-042
```

## ID Assignment Rules

When assigning a new ID (called from `/idea`, `/create-project`, `/onboard`, `/testplan`):

1. Read the current counter from the registry
2. Increment by 1
3. Check that the new ID does not already exist in the registry table
4. If it does exist (conflict), increment again and repeat until a free ID is found
5. Write the new counter and registry entry atomically
6. Never reuse an ID — a declined idea or deprecated project retains its ID permanently

---

## Lookup Process

1. Read `~/.claude/registry.md` — find the idea entry for the given ID
2. Read the idea file at the listed path
3. Return summary:

```markdown
## IDEA-003 — [Idea Name]

**Status:** Active | Holding | Declined | Delivered
**Created:** YYYY-MM-DD
**Impact:** High | Medium | Low
**Effort:** High | Medium | Low
**Estimate:** [band] / [N]pts

**Linked project:** PROJ-001 ([project name]) | None

**Summary:** [Problem statement — one sentence]

**File:** ~/.claude/ideas/[active|archived]/[idea-name]/idea.md
```

### PROJ-NNN

1. Read `~/.claude/registry.md` — find the project entry for the given ID
2. Read `CLAUDE.md` in the project repo for context
3. Return summary:

```markdown
## PROJ-001 — [Project Name]

**Status:** Active | Archived | Deprecated
**Repo:** [repo URL]
**Origin idea:** IDEA-003 ([idea name]) | None

**Stack:** [from CLAUDE.md]
**Current sprint:** Sprint-NN
**Active PRD:** [feature name] | None

**File:** [repo path]/CLAUDE.md
```

### TC-NNN

1. Read `docs/tests/registry.md` — find the test case entry for the given ID
2. Return summary:

```markdown
## TC-042 — [Behaviour description]

**Feature:** [feature name]
**Testplan:** docs/[testplan-filename].md
**Type:** Automated | Manual
**Status:** Defined | Implemented | Passing | Failing | Skipped | Waived

**File:** docs/tests/registry.md (row TC-042)
**Testplan section:** [testplan-filename].md → [section name]
```

## ID Format Validation

- `IDEA-NNN` — 3+ digit number, e.g. `IDEA-001`, `IDEA-042`, `IDEA-1000`
- `PROJ-NNN` — same format
- `TC-NNN` — same format

If the format doesn't match, respond: "That doesn't look like a valid Forge ID. Valid formats: IDEA-001, PROJ-001, TC-001."

## Not Found Handling

If the ID is not in the registry:
```
IDEA-099 not found in ~/.claude/registry.md.

The registry currently has [N] ideas (IDEA-001 through IDEA-[last]).
Run /user:lookup IDEA-001 through IDEA-[last] to find what you're looking for.
```

## Rules

- Never guess — if the ID isn't in the registry, say so clearly
- Always show the file path — the human may want to open it directly
- For TC lookups, also show the testplan filename where the test case was defined
- If the linked file doesn't exist at the registered path, attempt recovery:
  1. Search `~/.claude/ideas/` (for IDEA) or project `docs/` (for PROJ/TC) for a file containing the ID in its header
  2. If found, report: "File has moved to [new path]. Would you like me to update the registry?"
  3. On confirmation, update the registry path
  4. If not found anywhere, report: "⚠️ Registered file not found at [path] and could not be located. The file may have been deleted. Registry entry preserved for audit purposes."
