---
name: company-sync
description: Sync the local company knowledge directory with the team GitHub remote. Pull latest changes then push local changes. Supports --pull-only and --push-only flags. Use when user runs /company-sync, after /ingest to share new wiki articles, or at the start of a session to get latest team knowledge.
---

# Company Sync

Synchronise the local company knowledge directory at `~/.claude/companies/[active_company]/`
with the team GitHub remote. Always pull before push to avoid conflicts.

---

## Usage

```
/company-sync              ← pull then push (default)
/company-sync --pull-only  ← get latest without sharing local changes
/company-sync --push-only  ← share local changes without pulling first
```

`/ingest` offers to run `/company-sync --push-only` automatically after compiling new
Wiki articles. Accept to share knowledge with the team immediately.

---

## Pre-checks

### 1 — Company configured?

Read `~/.claude/preferences.md`. If `active_company` is not set:
```
❌ No company configured. Run /company-add [name] first.
```
Exit.

### 2 — Git repo initialised?

Check `~/.claude/companies/[active_company]/.git` exists. If not:
```
❌ Company directory is not a git repository.
   Run /company-git [remote-url] to connect it to a remote first.
```
Exit.

### 3 — Remote configured?

Run `git -C ~/.claude/companies/[active_company] remote get-url origin`.
If no remote:
```
❌ No remote configured. Run /company-git [remote-url] to add one.
```
Exit.

---

## Pull Phase (default and --pull-only)

```bash
git -C ~/.claude/companies/[active_company] fetch origin
git -C ~/.claude/companies/[active_company] pull --rebase origin main
```

If conflicts:
```
⚠️ Merge conflicts in the following files:
   - [file list]

   Resolve conflicts using standard git tools, then run:
   git -C ~/.claude/companies/[active_company] rebase --continue

   Then re-run /company-sync --push-only to complete the sync.
```

Stop here if `--pull-only`. Report what changed:
```
✅ Pull complete.
   [N files changed / Already up to date]
```

---

## Push Phase (default and --push-only)

Check for local changes:
```bash
git -C ~/.claude/companies/[active_company] status --porcelain
```

If no changes:
```
ℹ️ Nothing to push — working directory clean.
```

If changes exist, stage and commit:
```bash
git -C ~/.claude/companies/[active_company] add .
git -C ~/.claude/companies/[active_company] commit -m "chore: sync knowledge base [YYYY-MM-DD]"
git -C ~/.claude/companies/[active_company] push origin main
```

Report:
```
✅ Push complete.
   [N files changed — list changed files]
```

If push fails (non-zero exit):
```
❌ Push failed. Output:
   [stderr verbatim]

   Common causes:
   - Remote has changes you haven't pulled: run /company-sync --pull-only first
   - No push access to the remote: check repository permissions
```

---

## Full Sync Confirmation

After pull-then-push completes:

```
✅ Sync complete — ~/.claude/companies/[active_company]/

   Pulled: [N files updated / Already up to date]
   Pushed: [N files changed / Nothing to push]
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `active_company` not set | Exit with /company-add message |
| No `.git` directory | Exit with /company-git message |
| No remote configured | Exit with /company-git message |
| Merge conflict on pull | List files, provide rebase continue command, stop |
| Push rejected (behind remote) | Suggest --pull-only first |
| Network error | Report verbatim, suggest retry |

---

## Rules

- Never force push — always use standard push
- Never auto-resolve merge conflicts in knowledge content
- `--push-only` does not check for remote updates first — conflicts may occur; surfaced at push time
- Commit message always includes the date for traceability
