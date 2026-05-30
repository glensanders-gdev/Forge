---
name: create-project
category: ideation
description: Progress an accepted idea into a new project repository. Derives repo name, scaffolds Forge template, generates README, creates local and remote git repo, and prompts for grill-me, priority ranking, and sprint/PI planning. Use when user runs /create-project or an idea is accepted via /idea.
---

# Create Project

Bridge an accepted idea into a real project repository. Grills nothing yet — that comes after scaffolding. Creates the repo, scaffolds the template, commits, pushes, then hands off.

## Pre-Flight Checks

1. **Assign Project ID** — read `~/.claude/registry.md`, get next PROJ number, increment counter. Note the ID (e.g. `PROJ-003`) for use throughout.
2. Read `~/.claude/preferences.md` — confirm remote platform and username are set. If not, ask before proceeding.
3. Read `~/.claude/ideas/active/[idea-name]/idea.md` — extract:
   - Idea name and **IDEA-NNN** (for cross-reference)
   - Stakeholder label
   - Problem statement
   - Current status (must be `Accepted` — if not, stop and flag)

---

## Process

### Step 1 — Derive Repo Name

Convert idea name to a slug:
- Lowercase
- Spaces and special characters → hyphens
- Max 50 characters

Present for confirmation:
```
Proposed repo name: [slug]
Remote: [platform]/[username]/[slug]
Visibility: ?

Type CONFIRM to proceed, or provide a different name.
```

Ask visibility: **"Should this repo be Public or Private?"**

Wait for explicit confirmation before creating anything.

---

### Step 2 — Create Local Repo

```bash
mkdir [repo-name]
cd [repo-name]
git init
git branch -M main
```

---

### Step 3 — Scaffold Forge Template

Copy the Forge project template into the new repo:
- `CLAUDE.md`
- `.gitignore`
- `.claude/skills/` (empty, ready for overrides)
- `.claude/commands/` (empty, ready for overrides)
- `docs/CONTEXT.md`
- `docs/DEVLOG.md`
- `docs/kanban.md`
- `docs/adr/README.md`
- `docs/prd/active/`
- `docs/prd/archived/`
- `docs/research/`
- `docs/sprints/`
- `docs/releases/`

Update `CLAUDE.md`:
- Fill in project name from stakeholder label
- Add idea reference to Knowledge References table:
  ```markdown
  | Idea Origin | `~/.claude/ideas/active/[idea-name]/idea.md` |
  |             | `~/.claude/ideas/active/[idea-name]/diagram.mmd` |
  ```
- Set current version to `v0_01`
- Set last session to today's date

---

### Step 4 — Generate README.md

Draft a `README.md` from the idea document:

```markdown
# [Stakeholder Label]

**Status:** Early Discovery
**Created:** YYYY-MM-DD

## Problem

[Problem statement from idea.md — plain language]

## Idea

[Journey summary from idea.md — one paragraph]

## Measurements

| Metric | Baseline | Target |
|--------|----------|--------|
[From idea.md baseline and destination tables]

## Status

This project is in early discovery. A full design grill and PRD are pending.

See `docs/` for project documentation as it develops.
```

---

### Step 5 — Initial Commit

```bash
git add .
git commit -m "Initial commit — Forge scaffold for [stakeholder label]

Created from idea: [idea-name]
Status: Early Discovery"
```

---

### Step 6 — Create Remote and Push

**GitHub:**
```bash
gh repo create [username]/[repo-name] --[public|private] --source=. --remote=origin --push
```

**GitLab:**
```bash
glab repo create [repo-name] --[public|private]
git remote add origin https://gitlab.com/[username]/[repo-name].git
git push -u origin main
```

**Bitbucket:**
```bash
# Create via API then push
git remote add origin https://bitbucket.org/[username]/[repo-name].git
git push -u origin main
```

If the remote CLI tool is not available, provide the human with the exact manual steps.

---

### Step 7 — Update Cross-References

1. Update `CLAUDE.md` in the new repo — add to the project header:
   ```markdown
   **Project ID:** PROJ-NNN
   **Origin:** IDEA-NNN ([idea name])
   ```

2. Update `~/.claude/ideas/active/[idea-name]/idea.md` — add linked project:
   ```markdown
   **Project:** PROJ-NNN ([repo name])
   ```

3. Update `~/.claude/registry.md`:
   - Add to Project Registry: `| PROJ-NNN | [project name] | [repo URL] | IDEA-NNN | Active |`
   - Add to Cross-Reference Links: `| IDEA-NNN | → | PROJ-NNN |`

### Step 8 — Update Idea Record

Update `~/.claude/ideas/active/[idea-name]/idea.md`:

```markdown
## Project

**Repo:** [platform]/[username]/[repo-name]
**Created:** YYYY-MM-DD
**Status:** Active — Early Discovery
```

---

### Step 8 — Post-Creation Prompts

Present in order, do not auto-execute any of them:

**1. Grill prompt:**
```
✓ Project created: [platform]/[username]/[repo-name]

Before writing the PRD, run /user:grill-me to validate the idea
scope against your systems and processes.
```

**2. Priority prompt:**
Read `~/.claude/priorities.md` and display the current ranked list. Ask:
```
Where does [stakeholder label] rank in your global priorities?
Current list:
  1. [Feature] — [project]
  2. [Feature] — [project]
  ...

Reply with the rank number, or "bottom" to add at the end.
```

On confirmation, update `~/.claude/priorities.md`.

**3. Sprint/PI prompt:**
```
To add this project to sprint planning:
- If starting fresh: run /user:sprint-start
- If injecting into an active sprint: run /user:sprint-replan
- If it affects the current PI plan: run /user:pi-replan
```

---

## Rules

- Never create any files or repos without explicit CONFIRM from the human
- Always check `~/.claude/preferences.md` before asking about platform or visibility
- If remote CLI tools are unavailable, provide manual steps — never fail silently
- The idea document is referenced, never copied — it stays in `~/.claude/ideas/active/`
- PRD creation is deferred — do not create or pre-populate a PRD
- Sprint and PI assignment is deferred — do not touch `calendar.md` or `plan.md`

## CLI Availability Pre-Flight

Before Step 6 (Create Remote and Push), check `~/.claude/preferences.md` for `cli_available` setting. If not set, test by running `gh --version` or `glab --version`.

If CLI is not available, provide exact manual steps:

**GitHub (manual):**
1. Go to https://github.com/new
2. Repository name: `[repo-name]`
3. Visibility: Public / Private
4. Do NOT initialise with README (Forge will push one)
5. Click "Create repository"
6. Run locally:
   ```bash
   git remote add origin https://github.com/[username]/[repo-name].git
   git push -u origin main
   ```

**GitLab (manual):**
1. Go to https://gitlab.com/projects/new
2. Project name: `[repo-name]`
3. Visibility: Public / Private / Internal
4. Do NOT initialise with README
5. Click "Create project"
6. Run locally:
   ```bash
   git remote add origin https://gitlab.com/[username]/[repo-name].git
   git push -u origin main
   ```

**Bitbucket (manual):**
1. Go to https://bitbucket.org/repo/create
2. Repository name: `[repo-name]`
3. Access level: Private / Public
4. Do NOT include a README
5. Click "Create repository"
6. Run locally:
   ```bash
   git remote add origin https://bitbucket.org/[username]/[repo-name].git
   git push -u origin main
   ```

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `preferences.md` missing or incomplete | Stop. "preferences.md is not configured. Open ~/.claude/preferences.md and fill in remote platform and username before running /create-project." |
| Idea status is not `Accepted` | Stop. "This idea has not been accepted. Run `/idea` and accept it before creating a project." |
| Repo name slug conflicts with existing repo | Flag it. Suggest alternatives. Ask human to confirm before proceeding. |
| Git not installed | Stop. "Git is not available. Install git before running /create-project." |
| CLI tool unavailable | Fall through to manual steps. Never fail silently. |
| Remote creation fails | Stop. Provide the manual steps. Do not proceed with a local-only repo without flagging it. |
