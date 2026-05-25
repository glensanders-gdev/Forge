---
name: company-git
description: Connect the local company knowledge directory to a company-approved GitHub remote. One-time setup — initialises a git repo in ~/.claude/companies/[name]/, adds the remote, and either pushes initial stubs (empty remote) or pulls existing team content (populated remote). Use when user runs /company-git [remote-url] after /company-add.
---

# Company Git

Connect the company knowledge directory at `~/.claude/companies/[active_company]/` to a
company-approved GitHub remote. This is a one-time setup step — it wires the local
directory to an existing remote repo that an admin has already created.

Ongoing push/pull operations are handled by `/company-sync` (separate skill).

---

## Pre-checks

### 1 — Company configured?

Read `~/.claude/preferences.md`. If `active_company` is not set:

```
❌ No company configured. Run /company-add [name] first.
```

Exit.

### 2 — Company directory exists?

Check `~/.claude/companies/[active_company]/` exists. If not:

```
❌ Company directory not found at ~/.claude/companies/[active_company]/.
   Run /company-add [name] to create it.
```

Exit.

### 3 — Already a git repo?

Check if `~/.claude/companies/[active_company]/.git` exists. If it does:

```
⚠️ This company directory is already a git repository.
   Remote: [current remote URL, if set]

   Re-running /company-git will replace the remote configuration.
   Type CONFIRM to proceed, or press Enter to cancel.
```

If not confirmed, exit without changes.

---

## Get Remote URL

If a URL was provided as an argument, use it. Otherwise ask:

> "What is the remote URL for the company knowledge repository?"
> Examples:
> - `git@github.com:yourcompany/forge-knowledge.git` (SSH — recommended)
> - `https://github.com/yourcompany/forge-knowledge.git` (HTTPS)

Validate format: must start with `git@` or `https://`. Warn if it does not match either pattern.

---

## Test Connection

Before initialising anything, test that the remote is reachable:

```bash
git ls-remote [url] HEAD
```

- **Success (exit 0):** proceed
- **Failure (non-zero exit):**

```
❌ Could not reach the remote repository: [url]

   Common causes:
   - SSH key not added to GitHub (for git@ URLs): check ssh-add and ~/.ssh/config
   - Personal access token missing or expired (for https:// URLs)
   - Repository does not exist or you do not have access

   Resolve git credentials outside Forge, then re-run /company-git.
```

Exit without making any changes.

---

## Initialise Git Repo

```bash
git -C ~/.claude/companies/[active_company] init
git -C ~/.claude/companies/[active_company] remote add origin [url]
```

If already a git repo (confirmed overwrite above):
```bash
git -C ~/.claude/companies/[active_company] remote set-url origin [url]
```

---

## Create Root `.gitignore`

Write `~/.claude/companies/[active_company]/.gitignore`:

```gitignore
# Confluence credentials and operational state — never commit
knowledge/publish/confluence.md
knowledge/publish/publish-log.md
```

This complements the `.gitignore` already written by `/company-add` inside
`knowledge/publish/`. The root-level entry ensures protection even if the
subdirectory file is accidentally removed.

---

## Detect Remote State

Check whether the remote `main` branch has any commits:

```bash
git ls-remote --heads origin main
```

### Remote is empty (no output)

Perform the initial commit and push:

```bash
git -C ~/.claude/companies/[active_company] add .
git -C ~/.claude/companies/[active_company] commit -m "chore: initial company knowledge scaffold"
git -C ~/.claude/companies/[active_company] branch -M main
git -C ~/.claude/companies/[active_company] push -u origin main
```

### Remote has content

Warn the user before pulling:

```
⚠️ The remote repository already has content.
   Pulling will replace stub files created by /company-add with the team's
   existing knowledge base. Local stubs that don't conflict will be kept.

   Proceed? (yes/no)
```

If confirmed:

```bash
git -C ~/.claude/companies/[active_company] fetch origin
git -C ~/.claude/companies/[active_company] checkout -b main --track origin/main
git -C ~/.claude/companies/[active_company] pull --rebase origin main
```

If the pull results in conflicts, stop and report:

```
⚠️ Merge conflicts detected in the following files:
   - [file list]

   Resolve these conflicts using standard git tools, then run:
   git -C ~/.claude/companies/[active_company] rebase --continue

   Do not auto-resolve knowledge content — review each conflict manually.
```

Do not proceed to the confirmation step until conflicts are resolved.

---

## Confirm

**After empty remote (push path):**

```
✅ Company knowledge repo initialised and pushed.

   Remote: [url]
   Branch: main
   Location: ~/.claude/companies/[active_company]/

Pull-before-push convention:
   Always pull before pushing knowledge changes to avoid conflicts.
   Run /company-sync to share future changes with your team.
   (/company-sync not yet available — use the following manually until it is:
    git -C ~/.claude/companies/[active_company] pull && git -C ~/.claude/companies/[active_company] push)

Next steps:
  1. Share [url] with team members — they run /company-add then /company-git [url]
  2. Fill in config.md, context.md, and acronyms.md with company details
  3. Run /add-system to add your first system
```

**After populated remote (pull path):**

```
✅ Company knowledge base pulled from remote.

   Remote: [url]
   Branch: main
   Location: ~/.claude/companies/[active_company]/

   The team's existing knowledge base is now available locally.
   Run /knowledge-health to review what's in the knowledge base.

Pull-before-push convention:
   Always pull before pushing knowledge changes to avoid conflicts.
   Run /company-sync to share future changes with your team.
   (/company-sync not yet available — use the following manually until it is:
    git -C ~/.claude/companies/[active_company] pull && git -C ~/.claude/companies/[active_company] push)
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `active_company` not set | Exit with message to run `/company-add` first |
| Company directory missing | Exit with message to run `/company-add` first |
| Remote unreachable | Exit with credential troubleshooting guidance — no local changes made |
| Merge conflict on pull | Stop and list conflicting files — never auto-resolve |
| Already a git repo | Warn and require CONFIRM before replacing remote |
| Push fails | Report error verbatim — likely a permissions issue on the remote |

---

## Rules

- Never proceed past the connection test if `git ls-remote` fails — no partial state
- Never auto-resolve merge conflicts in knowledge content
- The `.gitignore` must be written before the initial commit — credentials must never enter the history
- Do not create the remote repository — that is an admin step outside Forge
- This skill is setup only — push/pull for daily use belongs to `/company-sync`
