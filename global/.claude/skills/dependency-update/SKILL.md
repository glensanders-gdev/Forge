---
name: dependency-update
description: Update project dependencies safely. --safe (default) handles patch and minor updates; --all includes major version bumps with per-package confirmation showing breaking changes. Runs tests after updating and stages changes for developer review — never auto-commits. Use when user runs /dependency-update or /security-assessment flags vulnerable dependencies.
---

# Dependency Update

Update project dependencies with safety checks. Patch and minor updates are applied as a
batch after tests pass. Major updates require individual confirmation with a breaking changes
summary. Changes are always staged — never auto-committed.

---

## Usage

```
/dependency-update           ← patch and minor updates only (safe default)
/dependency-update --safe    ← same as default
/dependency-update --all     ← includes major version bumps (per-package confirmation)
/dependency-update --dry-run ← show what would be updated without applying changes
```

---

## Phase 1 — Detect Package Manager

Identify the package manager from project files (check in order):

| File | Manager |
|------|---------|
| `package-lock.json` | npm |
| `yarn.lock` | yarn |
| `pnpm-lock.yaml` | pnpm |
| `requirements.txt` / `pyproject.toml` | pip / poetry |
| `go.mod` | go modules |
| `Gemfile.lock` | bundler |
| `Cargo.lock` | cargo |

If multiple are found (monorepo), ask which to update or offer to update all.

---

## Phase 2 — Get Outdated Packages

Run the appropriate command to list outdated packages:

| Manager | Command |
|---------|---------|
| npm | `npm outdated --json` |
| yarn | `yarn outdated --json` |
| pnpm | `pnpm outdated --format json` |
| pip | `pip list --outdated --format json` |
| poetry | `poetry show --outdated` |
| go | `go list -u -m all` |
| bundler | `bundle outdated --parseable` |
| cargo | `cargo outdated` |

If no outdated packages found:
```
✅ All dependencies are up to date.
```
Exit.

---

## Phase 3 — Filter and Present

### `--safe` mode (default)

Filter to packages where the update is patch or minor (semver: `x.Y.z` or `x.y.Z`).
Exclude any package with a major version change.

Present the list:

```
📦 Safe updates available (patch and minor):

  Package              Current  →  Latest   Type
  ─────────────────────────────────────────────
  express              4.18.1   →  4.19.2   patch
  lodash               4.17.20  →  4.17.21  patch
  typescript           5.3.2    →  5.4.5    minor
  jest                 29.6.0   →  29.7.0   minor

  4 packages — estimated risk: Low

Apply all? (yes / no / select packages)
```

### `--all` mode

Show all outdated packages. Major updates are flagged separately.

```
📦 Updates available:

Safe (patch/minor) — 4 packages [same as above]

Major version bumps — requires confirmation per package:
  next         13.5.6   →  14.2.1   MAJOR
  react        17.0.2   →  18.3.1   MAJOR
  webpack      4.46.1   →  5.93.0   MAJOR
```

For each major update, show breaking changes summary and confirm individually:

```
next 13.5.6 → 14.2.1 (MAJOR)

Breaking changes summary:
- App Router is now the default (Pages Router still supported)
- next/font replaces @next/font
- Minimum Node.js version is now 18.17.0

Update next? (yes / no / skip)
```

### `--dry-run` mode

Show what would be updated without applying. No changes made.

---

## Phase 4 — Apply Updates

Apply the confirmed updates using the appropriate command:

| Manager | Command |
|---------|---------|
| npm | `npm update [packages]` or `npm install [package@version]` for major |
| yarn | `yarn upgrade [packages]` |
| pnpm | `pnpm update [packages]` |
| pip | `pip install --upgrade [packages]` |
| poetry | `poetry update [packages]` |
| go | `go get [package@version]` |
| bundler | `bundle update [packages]` |
| cargo | `cargo update [packages]` |

---

## Phase 5 — Run Tests

After applying updates, run the project test suite:

Read `.claude/deploy.md` or `CLAUDE.md` for the test command. If not found, try:
- `npm test` / `yarn test` / `pnpm test`
- `pytest`
- `go test ./...`
- `bundle exec rspec`
- `cargo test`

If tests pass:
```
✅ Tests passed after updates.
```

If tests fail:
```
⚠️ Tests failed after updating the following packages:
   [list of packages just updated]

   Test output:
   [first 20 lines of failure output]

   Options:
   1. Revert all updates: git checkout -- [lock file] && [reinstall command]
   2. Revert specific packages and retry
   3. Investigate failures manually

   Revert all and restore previous state? (yes/no)
```

If user chooses to revert: restore lock file from git and reinstall.

---

## Phase 6 — Stage Changes

Stage the updated files (lock file and manifest only — not source changes):

```bash
git add [package.json / requirements.txt / go.mod / etc.]
git add [package-lock.json / yarn.lock / go.sum / etc.]
```

Do not stage any changes to source files — updates should only affect manifests and lock files.

```
✅ Changes staged (not committed).

   Staged files:
   - package.json
   - package-lock.json

   Review the diff with: git diff --cached
   Commit when satisfied: git commit -m "chore: update dependencies [YYYY-MM-DD]"

   Packages updated: N
   Tests: ✅ Passed
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Package manager not detected | Ask user to specify |
| No outdated packages | Confirm up to date and exit |
| Update command fails | Show error verbatim, do not proceed to tests |
| Tests fail after update | Offer to revert — do not stage |
| Major update has no breaking changes info available | Note "no breaking changes summary available" and ask to confirm anyway |
| Lock file not tracked by git | Warn: cannot revert if tests fail |

---

## Rules

- Never auto-commit — always stage for developer review
- Never apply major updates in `--safe` mode — they require `--all` and explicit confirmation
- If tests fail, do not stage changes — revert first
- Only stage manifest and lock file changes — never stage source code modifications
- `--dry-run` makes no changes and produces no git staging
