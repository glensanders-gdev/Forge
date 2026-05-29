---
name: company-sync
category: company
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

### 4 — Read git config

Read `~/.claude/companies/[active_company]/config.md`. Extract:
- `git_remote` — default `origin` if not set
- `git_branch` — default `main` if not set

Use `[git_remote]` and `[git_branch]` throughout all git operations below.

---

## Pull Phase (default and --pull-only)

```bash
git -C ~/.claude/companies/[active_company] fetch [git_remote]
git -C ~/.claude/companies/[active_company] pull --rebase [git_remote] [git_branch]
```

If conflicts:
```
⚠️ Merge conflicts detected.

   Conflicting files:
   - [file] — [brief description: knowledge article / config / etc.]

   These are likely knowledge articles edited by two teammates simultaneously.

   To resolve:
   1. Open each conflicted file and choose which version to keep
      (or merge both — for knowledge articles, combining content is usually right)
   2. Mark resolved:
      git -C ~/.claude/companies/[active_company] add [file]
   3. Complete the rebase:
      git -C ~/.claude/companies/[active_company] rebase --continue
   4. Re-run /company-sync --push-only

   Tip: for prose knowledge files, accepting both sides (manually combining)
   is usually better than picking one author's version over the other.
```

Stop here if `--pull-only`. Report what changed:
```
✅ Pull complete.
   [N files changed / Already up to date]
```

---

## Push Phase (default and --push-only)

### Step 1 — Check for changes
```bash
git -C ~/.claude/companies/[active_company] status --porcelain
```

If no changes:
```
ℹ️ Nothing to push — working directory clean.
```
Stop here.

### Step 2 — Stage preview (HITL gate)

If changes exist, show what will be committed before staging anything:

```
Ready to commit and push to [git_remote]/[git_branch].

Files to be committed:
  [M]  knowledge/Wiki/architecture/_index.md
  [M]  knowledge/company/acronyms.md
  [?]  knowledge/Raw/2026-05-25_design-doc.pdf

  M = modified   A = new file   D = deleted   ? = untracked

Type SYNC to commit and push, or CANCEL to abort.
```

Wait for `SYNC` before proceeding. Do not stage or commit until confirmed.

### Step 3 — Commit and push

On `SYNC`:
```bash
git -C ~/.claude/companies/[active_company] add .
git -C ~/.claude/companies/[active_company] commit -m "chore: sync knowledge base [YYYY-MM-DD]"
git -C ~/.claude/companies/[active_company] push [git_remote] [git_branch]
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
   - Branch protection is enabled: push manually and open a PR on [git_branch]
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
| Merge conflict on pull | List files with type hints, provide per-file resolution steps, stop |
| Push rejected (behind remote) | Suggest --pull-only first |
| Push rejected (branch protection) | Advise manual PR workflow |
| Network error | Report verbatim, suggest retry |
| `config.md` missing git fields | Default to `origin` / `main`, proceed |

---

## Rules

- Never force push — always use standard push
- Never auto-resolve merge conflicts in knowledge content
- Always show the staged files preview and wait for `SYNC` before committing — never auto-commit
- `--push-only` does not check for remote updates first — conflicts may occur; surfaced at push time
- Commit message always includes the date for traceability
- `git_remote` and `git_branch` are read from `config.md`; default to `origin` / `main` if not set
