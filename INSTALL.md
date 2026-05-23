# Forge — Installation Guide

## Recommended: One-Command Install

If you have `git` installed, this is the fastest path:

```bash
git clone https://github.com/glensanders-gdev/Forge.git ~/forge
bash ~/forge/install.sh
```

The installer copies all skills, commands, and knowledge files to `~/.claude/`, backs up any existing skills, and prints next steps.

**To update Forge later:**
```bash
cd ~/forge && git pull && bash ~/forge/update.sh
```

---

## Manual Installation

No terminal required. Everything can be done with File Explorer (Windows) or Finder (Mac).

---

## Before You Start

### Show hidden files and folders

Forge uses folders that start with `.` (like `.claude`), which are hidden by default.

**Windows:**
1. Open File Explorer
2. Click **View** in the top menu
3. Click **Show** → tick **Hidden items**

**Mac:**
1. Open any Finder window
2. Press `Cmd + Shift + .` to toggle hidden files on/off

---

## Step 1: Install Global Skills (One-Time Setup)

This installs Forge's skills and commands so they're available across all your projects.

1. Unzip `forge.zip` somewhere on your computer (e.g. your Downloads folder)
2. Open the unzipped folder and navigate to `forge/global/`
3. You'll see a `.claude` folder inside

**If `.claude` does not exist in your home directory yet:**

Copy the entire `.claude` folder to your home directory:
- **Windows:** `C:\Users\YourName\`
- **Mac:** `/Users/YourName/` — press `Cmd + Shift + H` in Finder to jump there

**If `.claude` already exists** (Claude Code creates it on first run):

Open both `.claude` folders side by side and copy these two folders from `forge/global/.claude/` into your existing `~/.claude/`:
- `skills\`
- `commands\`

After this step your home directory should contain:
```
.claude/
  skills/
    manifest.json
    [skill folders — see manifest.json for full list]
  commands/
    [command files — one per skill]
  knowledge/
    company/
    systems/
  sprints/
    calendar.md
  pi/
  ideas/
    active/
    archived/
  tokens/
    ledger.md       ← global cross-project token usage ledger
  priorities.md
  backlog.md
  preferences.md
  CHANGELOG.md
  forge-sequence.mmd
```

---

## Step 2: Scaffold a New Project

Do this once per project, inside that project's root folder.

1. Open `forge/project-template/` from the unzipped folder
2. Copy everything inside it into your project's root folder:

```
your-project/
  CLAUDE.md           ← copy this
  .gitignore          ← copy this (or merge with existing)
  .claude/            ← copy this folder
    commands/
    skills/
    deploy.md              ← fill in before running /deploy
    CODING-STANDARDS.md    ← loaded on demand before code changes
    ERROR-HANDLING.md      ← loaded on demand when debugging
    SECURITY.md            ← loaded on demand before data/API changes
    TESTING.md             ← loaded on demand before writing tests
  docs/               ← copy this folder
    CONTEXT.md
    DEVLOG.md
    HANDOFF.md        ← managed by AI — do not edit manually
    kanban.md
    kanban-archive.md
    known-issues.md   ← active and deferred project issues and limitations
    adr/
      README.md
    prd/
      active/
      archived/
    research/
    sprints/
    releases/
      deploy-log.md
    tests/
      registry.md   ← project-wide TC-NNN test case registry (agent-managed)
    tokens/
      _template.md  ← per-feature token record template (copy to create new records; managed by agent)
```

---

## Step 3: Configure Your Project

Open `CLAUDE.md` in any text editor (Notepad, TextEdit, VS Code) and fill in the placeholders at the top:

```
**[PROJECT NAME]**        → your project's name
**Type:**                 → web app / mobile app / API / etc
**Stack:**                → your tech stack
**Hosting:**              → where it's deployed
**Live URL:**             → the URL, or "not yet deployed"
**Repository:**           → your GitHub/GitLab repo URL
**Current version:**      → starting version, e.g. v0_01
**Last session:**         → today's date
```

Also update the **Key Files** table to reflect your actual working file names and paths.

**Note on `docs/HANDOFF.md`:** This file is managed entirely by the AI agent — it's overwritten at the end of every session and read at the start. You don't need to edit it manually. Just leave it in place.

---

## Step 4: Start Using Forge

Open Claude Code in your project folder. It will automatically read `CLAUDE.md` at the start of every session.

To begin a new feature, type:
```
/user:grill-me
```

Available commands:

| Command | What it does |
|---------|-------------|
| `/user:grill-me` | Stress-test a plan with relentless one-at-a-time questions |
| `/user:grill-with-docs` | Grill against your domain model and codebase |
| `/user:research` | Cache research findings in topic-specific files |
| `/user:prototype` | Spike ideas in throwaway code |
| `/user:write-prd` | Generate a structured PRD from the session so far |
| `/user:diagnose` | Systematically debug a failing ticket |
| `/user:approve` | Close and archive the current feature cycle |

---

## Building Your Knowledge Base

The knowledge base lives inside your global `~/.claude/knowledge/` folder and grows over time. It is separate from any project.

### Structure

```
.claude/knowledge/
  README.md                        ← explains the structure
  company/
    acronyms.md                    ← fill this in first
  systems/
    example-system/                ← rename or copy for each real system
      overview.md                  ← what it is, what AI can/can't do
      schema.md                    ← data structures and fields
      known-issues.md              ← constraints and hard stops
```

### Adding a New System

1. Copy the `example-system/` folder inside `systems/`
2. Rename it to your system name (lowercase, hyphens — e.g. `salesforce`, `legacy-db`)
3. Open each of the three files and fill in what you know
4. In your project's `CLAUDE.md`, add the system to the **Knowledge References** table

### Linking to a Project

In your project's `CLAUDE.md`, update the Knowledge References table:

```markdown
| Salesforce | `~/.claude/knowledge/systems/salesforce/overview.md` |
|            | `~/.claude/knowledge/systems/salesforce/known-issues.md` |
```

The AI will then load those files automatically at session start.

### Referencing from a Ticket

For large schema files you don't want loaded every session, reference them directly in the kanban ticket:

```markdown
- [ ] [AFK] #4 Build Salesforce sync `ref: ~/.claude/knowledge/systems/salesforce/schema.md`
```

---

## Configure Deployment (Per Project)

Each project has a `.claude/deploy.md` file in the project template. Before running `/user:deploy` or `/user:deploy-pi`, open it and fill in the deployment details for your project.

**Minimum required fields:**

```
production:
  platform: Vercel | Railway | GitHub Pages | custom
  command: [your deploy command]
  url: https://your-domain.com
```

**Strongly recommended:**

```
health-check: https://your-domain.com/health
rollback command: [your rollback command]
```

Without a rollback command, the agent will warn you before deploying. If deployment fails without a rollback command configured, you will need to roll back manually.

**Common deploy commands by platform:**

| Platform | Deploy command | Rollback command |
|----------|---------------|-----------------|
| Vercel | `vercel --prod` | `vercel rollback` |
| Railway | `railway up` | `railway rollback` |
| GitHub Pages | `git push origin main` | `git revert HEAD && git push` |
| Heroku | `git push heroku main` | `heroku releases:rollback` |

Also set `deploy-order: N` (integer) if you use `/user:deploy-pi` — this controls the sequence in which projects are deployed. Lower numbers deploy first (e.g. database migrations before API, API before frontend).

---

## Configure Global Preferences (First Time Only)

Open `~/.claude/preferences.md` in any text editor and fill in:

- **Remote platform** — GitHub, GitLab, or Bitbucket
- **Remote username** — your account username on that platform
- **Default repo visibility** — Public or Private
- **Informal idea detection** — Enabled or Disabled

These are read by skills like `/create-project` and `/idea` so they don't need to ask every time.

---

## Setting Up the Sprint Calendar (First Time Only)

The sprint calendar lives at `~/.claude/sprints/calendar.md` and was created as part of the global install. Before using `/user:sprint-start` for the first time, open it in any text editor and add your first sprint entry.

### Option A — Personal project (generate your own dates)

Edit `~/.claude/sprints/calendar.md` and fill in the sprints table:

```markdown
| Sprint-01 | 2026-05-20 | 2026-06-02 | Active |
```

**Release convention:** 3rd Monday of each month. Go/No Go is the Friday before at 5pm. Buffer window is Friday–Sunday before the release. Sprints start on Tuesdays.

Then add your active projects for that sprint:

```markdown
## Sprint-01 (2026-05-20 → 2026-06-02)
- my-project
- another-repo
```

Alternatively, just run `/user:sprint-start` and when prompted "No active sprint found", choose to auto-generate — the agent will propose the dates and add the entry for you.

### Option B — Work project (syncing from an external calendar)

If your organisation manages sprint dates in Jira, Notion, or another tool, manually copy the current sprint dates into `calendar.md` at the start of each sprint. When `/user:sprint-start` prompts you about a missing sprint, choose "sync from elsewhere" and provide the name, start, and end dates.

### Sprint naming convention

Forge uses `Sprint-NN` format (e.g. `Sprint-01`, `Sprint-12`). If your organisation uses a different naming convention (e.g. `2026-S03`), you can use that instead — just be consistent across the calendar and project records.

---

## Project Skill Overrides

To override a global skill for a specific project, create a file at:

```
your-project/.claude/skills/[skill-name]/SKILL.md
```

Project-level skills take precedence over global skills of the same name.

---

## Troubleshooting

**Skills not triggering:**
- Check the skill folder is at `~/.claude/skills/skill-name/SKILL.md` — not one level deeper
- Make sure hidden files are visible so you can confirm the folder structure

**Commands not found:**
- Confirm the file is at `~/.claude/commands/grill-me.md` (not inside a subfolder)
- Global commands appear as `/user:command-name` in Claude Code

**`.claude` folder not visible:**
- Toggle hidden files on (see "Before You Start" above)

**Merging with an existing `.gitignore`:**
- Forge only adds one line: `/prototype`
- Add that line manually to your existing `.gitignore` if you already have one
