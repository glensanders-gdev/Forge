---
name: company-add
description: Set up a company-specific file structure outside the Forge repo at ~/.claude/companies/[name]/. Scaffolds knowledge tiers (systems, projects, ideas), company context files, and publish config. Company data is never committed to the Forge GitHub. Use when user runs /company-add [name] or sets up Forge for a new company install.
---

# Company Add

Bootstrap a company install of Forge. Creates a company-specific directory outside the
repo at `~/.claude/companies/[name]/` and registers it as the active company so all
other skills resolve paths correctly.

Company data stored here is **never committed to the Forge repository**. It lives only
on the local machine unless a company-approved GitHub is configured via `/company-git`.

---

## Pre-checks

### 1 — Already configured?

Read `~/.claude/preferences.md`. If `active_company` is already set:

```
⚠️ A company is already configured: [active_company]
   Forge is designed for one company per install.

   To reconfigure, run these two commands manually:
     1. Edit ~/.claude/preferences.md — remove the line: active_company: [active_company]
     2. Delete the directory: rm -rf ~/.claude/companies/[active_company]/

   Then re-run /company-add [name].
```

Do not proceed. Exit.

### 2 — Existing knowledge data?

Before prompting for a name, check whether any of the following exist:
- `~/.claude/knowledge/systems/` (any subdirectories)
- `~/.claude/knowledge/projects/` (any subdirectories)
- `~/.claude/ideas/active/` or `~/.claude/ideas/archive/` (any files)

If any exist, surface a warning before continuing:

```
⚠️ Existing Forge data found at the global paths:

   [list each non-empty path found, e.g.:]
   - ~/.claude/knowledge/systems/salesforce-crm/
   - ~/.claude/knowledge/projects/customer-portal/
   - ~/.claude/ideas/active/idea-001.md

   After /company-add, all skills will resolve paths to the new company
   directory. This existing data will NOT be moved automatically.

   To migrate after setup, copy or move the above into:
   - ~/.claude/companies/[name]/knowledge/systems/
   - ~/.claude/companies/[name]/knowledge/projects/
   - ~/.claude/companies/[name]/ideas/

   Continue with setup? (yes/no)
```

If the user answers no, exit without changes.

### 2 — Name provided?

If no name argument was given, ask:
> "What is the company name? (used as the directory name — lowercase, hyphens only)"

### 3 — Normalise name

Convert to lowercase. Replace spaces and underscores with hyphens. Strip characters
that are not alphanumeric or hyphens.

Examples: `Acme Corp` → `acme-corp`, `my_company` → `my-company`

Confirm with the user if normalisation changed the input:
> "I'll use `acme-corp` as the directory name. Continue?"

---

## Confirm Before Writing

Show the full structure that will be created and ask the user to confirm:

```
Ready to set up Forge for [Company Name].

Directory: ~/.claude/companies/[name]/

Structure:
  config.md
  registry.md
  knowledge/
    company/
      acronyms.md
      context.md
      style-guide.md
    systems/        ← /add-system will scaffold here
    projects/       ← /add-project will scaffold here
    publish/
      confluence.example.md
      .gitignore
  ideas/
    active/
    archive/
  metrics/          ← /fy-review and /dashboard-tokens write cross-project metrics here
  reviews/          ← /fy-review writes manager-summary.md and team-retrospective.md here
  retrospectives/   ← /sprint-end writes private retro summaries here
  pir/              ← /pir writes Post Implementation Reviews here

preferences.md will be updated: active_company: [name]

This data is stored outside the Forge repo and will not be committed to GitHub.

Proceed? (yes/no)
```

---

## Create Structure

On confirmation, create the following:

### Directories

```
~/.claude/companies/[name]/
~/.claude/companies/[name]/knowledge/
~/.claude/companies/[name]/knowledge/company/
~/.claude/companies/[name]/knowledge/systems/
~/.claude/companies/[name]/knowledge/projects/
~/.claude/companies/[name]/knowledge/publish/
~/.claude/companies/[name]/ideas/
~/.claude/companies/[name]/ideas/active/
~/.claude/companies/[name]/ideas/archive/
~/.claude/companies/[name]/metrics/
~/.claude/companies/[name]/reviews/
~/.claude/companies/[name]/retrospectives/
~/.claude/companies/[name]/pir/
```

### `config.md`

```markdown
# Company Config

company_name: [Company Name]
domain: (e.g. yourcompany.com — fill in after setup)
jira_base_url: (e.g. https://yourcompany.atlassian.net — fill in if using Jira)
active: true
created: YYYY-MM-DD

## Financial Year
fy_start: July 1
review_display_name: FY Review

## AI Cost Tracking (optional)
# token_cost_per_1k: 0.003
# Set to your per-1k-token cost to enable cost-per-feature and cost-per-story-point metrics.
# Example: Claude Sonnet at $0.003 per 1k tokens (output). Check current pricing.
```

### `registry.md`

```markdown
# Registry — [Company Name]

## Ideas

| ID | Title | Status | Owner | Sprint | External ID |
|----|-------|--------|-------|--------|-------------|

## Projects

| ID | Title | Status | Owner | Sprint | External ID |
|----|-------|--------|-------|--------|-------------|

## Systems

| Name | Owner | Status | Last Updated |
|------|-------|--------|-------------|
```

### `knowledge/company/acronyms.md`

```markdown
# Acronyms — [Company Name]

| Acronym | Full Form | Notes |
|---------|-----------|-------|
```

### `knowledge/company/context.md`

```markdown
# Company Context — [Company Name]

## About
(Describe the company, its domain, and key context for AI-assisted work)

## Teams
(Key teams and their responsibilities)

## Key Systems
(Systems in use — populated by /add-system)

## Key Processes
(Recurring processes the AI should be aware of)
```

### `knowledge/company/style-guide.md`

```markdown
# Style Guide — [Company Name]

## Writing Style
(House tone and voice for documentation and communications)

## Terminology
(Preferred terms and terms to avoid)

## Formatting
(Document formatting standards)
```

### `knowledge/publish/confluence.example.md`

Copy from `~/.claude/knowledge/publish/confluence.example.md` if it exists;
otherwise create a minimal placeholder pointing to `/setup-confluence`.

```markdown
# Confluence Publish Config

Run /setup-confluence to generate confluence.md for this company.
```

### `knowledge/publish/.gitignore`

```
confluence.md
publish-log.md
```

---

## Update `preferences.md`

Add or update the following line in `~/.claude/preferences.md`:

```
active_company: [name]
```

If `preferences.md` does not exist, create it with this single entry.

---

## Confirm

```
✅ Company "[Company Name]" configured.

   Data location: ~/.claude/companies/[name]/
   This directory is outside the Forge repo — it will never be committed to GitHub.

   Note: the global registry at ~/.claude/registry.md is now superseded by
   ~/.claude/companies/[name]/registry.md — all skills write to the company registry.

Next steps:
  1. Fill in ~/.claude/companies/[name]/config.md (domain, Jira URL)
  2. Fill in knowledge/company/context.md and acronyms.md with company details
  3. Run /add-system [name] to add your first system
  4. Run /setup-confluence if publishing to Confluence
  5. Run /company-git if you have a company-approved GitHub for this data
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `active_company` already set | Warn and exit — do not overwrite |
| Directory already exists at path | Warn: "Directory already exists. Running /company-add again may overwrite stub files. Confirm?" |
| `preferences.md` missing | Create it |
| Name normalisation produces empty string | Ask user to provide a valid name |

---

## Rules

- Never proceed without explicit user confirmation of the full structure
- Never overwrite an existing `active_company` setting without warning
- The `~/.claude/companies/` path is outside the Forge repo — no `.gitignore` entries needed in the repo
- Do not create a `.git` repository inside the company directory — that is `/company-git`'s responsibility
- Stub files are placeholders — never pre-populate them with invented company data
