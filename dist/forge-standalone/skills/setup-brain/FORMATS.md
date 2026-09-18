# Brain Setup — Formats

Templates written by `/setup-brain`. Replace `[Project Name]` and `[Space Name]` with real values
and stamp real dates.

---

## `_scope.md` (project space root)

The sole source of truth for a project's scope. **A space without this file is restricted** —
never shared, moved, or compiled into the shared space. Nothing is ever written to record
restriction; the restricted state is the file's absence.

```markdown
# Scope: [Project Name]

scope: private | shared
merge_on_ship: [yes for shared, no for private]
declared: YYYY-MM-DD
declared_by: [username]
```

- `scope: shared` requires `merge_on_ship: yes`.
- `scope: private` requires `merge_on_ship: no`.

## `Wiki/pending-changes.md` (shared space only)

```markdown
# Pending Changes — [Space Name]

Upcoming changes to this space's knowledge from in-flight shared projects. Add a row whenever a
change crystallises; set Status to Confirmed once it is certain. Rows are resolved only when the
project ships and its Wiki merges into this one — never resolve a row before the project ships.

| Date raised | Project | Change | Status | Resolved |
|-------------|---------|--------|--------|----------|
| | | | | |
```

- **Status:** `Potential` (might happen) or `Confirmed` (will happen when the project ships).
- **Resolved:** blank while open; on merge, the date plus the Wiki article(s) updated.

---

## Base space stubs (create only when missing)

### `Raw/_compiled.log`

```
# Compiled Log — [Space Name]
# Format: YYYY-MM-DD | filename | compiled | articles updated
#          YYYY-MM-DD | filename | failed   | reason
```

### `Wiki/_index.md`

```markdown
# [Space Name] — Wiki Index

## Recently Updated
| Date | Article | Summary |
|------|---------|---------|
| | | |
```

### `Wiki/_changelog.md`

```markdown
# Wiki Changelog — [Space Name]

| Date | Type | Article | Notes |
|------|------|---------|-------|
| | | | |
```
