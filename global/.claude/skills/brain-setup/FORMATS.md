# Brain Setup — Formats

Templates written by `/brain-setup`. Replace `[Project Name]` / `[Company]` with real
values and stamp real dates. Base tier stubs match `/add-project` exactly — a folder
scaffolded by either skill passes the other's audit.

---

## `_scope.md` (project knowledge folder root)

The sole source of truth for a project's scope. **A folder without this file is
company-restricted** — never shared, moved, or compiled into the global tier. Nothing is
ever written to record restriction; the restricted state is the file's absence.

```markdown
# Scope: [Project Name]

scope: personal | company
company: [company-name, blank for personal]
merge_on_deploy: [yes for company, no for personal]
declared: YYYY-MM-DD
declared_by: [username]
```

- `scope: company` requires `company:` naming an existing `~/.claude/companies/[name]/`
  and `merge_on_deploy: yes`.
- `scope: personal` requires `company:` blank and `merge_on_deploy: no`.

## `Wiki/pending-changes.md` (company tier only)

```markdown
# Pending Changes — [Company]

Upcoming changes to company knowledge from in-flight company-scoped projects. Add a row
whenever a change crystallises; set Status to Confirmed once it is certain. Rows are
resolved only when the project deploys and its Wiki merges into this one (the /deploy
post-deployment cleanup) — never resolve a row before deployment.

| Date raised | Project | Change | Status | Resolved |
|-------------|---------|--------|--------|----------|
| | | | | |
```

- **Status:** `Potential` (might happen) or `Confirmed` (will happen on deploy).
- **Resolved:** blank while open; on merge, the date plus the Wiki article(s) updated.

---

## Base tier stubs (create only when missing)

### `Raw/_compiled.log`

```
# Compiled Log — [Tier or Project Name]
# Format: YYYY-MM-DD | filename | compiled | articles updated
#          YYYY-MM-DD | filename | failed   | reason
```

### `Wiki/_index.md`

```markdown
# [Tier or Project Name] — Wiki Index

## Recently Updated
| Date | Article | Summary |
|------|---------|---------|
| | | |
```

### `Wiki/_changelog.md`

```markdown
# Wiki Changelog — [Tier or Project Name]

| Date | Type | Article | Notes |
|------|------|---------|-------|
| | | | |
```
