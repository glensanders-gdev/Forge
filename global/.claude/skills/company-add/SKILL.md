---
name: company-add
description: Set up a company-specific file structure outside the Forge repo at ~/.claude/companies/[name]/. Grills the user on company operational config — sprint cadence, team locations, public holidays, freeze periods, compliance tier, external approval gates, deployment environments, AI usage policy, and tools policy. Scaffolds knowledge, projects, instincts, rules, and tools sections mirroring the global structure. Company data is never committed to the Forge GitHub. Use when user runs /company-add [name] or sets up Forge for a new company install.
---

# Company Add

Bootstrap a company install of Forge. Creates a company-specific directory outside the
repo at `~/.claude/companies/[name]/`, grills the user on company-specific operational
patterns, and writes a fully populated config so all other skills behave correctly from
day one.

Company data stored here is **never committed to the Forge repository**. It lives only
on the local machine unless a company-approved GitHub is configured via `/company-git`.

---

## Quick Mode

If the user runs `/company-add [name] --quick`:

1. Run the same pre-checks as normal (existing company guard, existing data warning, name normalisation).
2. Skip all 8 grilling topics — use every default value from the config template as-is.
3. Present a brief summary before writing:
   ```
   Quick setup — all defaults applied.

   Company: [name]
   Sprint length: 2 weeks
   Release cadence: end-of-sprint
   Compliance tier: standard
   External approval: none
   AI policy: none
   Tools policy: none

   Create with defaults? (yes/no)
   ```
4. On confirmation, create the directory structure and write `config.md` with all default values and `# TODO` comments on every field that typically needs filling in.
5. End with:
   ```
   ✅ Company "[name]" created with defaults.
   Edit ~/.claude/companies/[name]/config.md to customise for your environment.
   Run /company-add [name] (without --quick) at any time to redo the full grilling session.
   ```

--quick completes in under 30 seconds. It is suitable for getting started immediately and refining later. All skills will use the defaults until config.md is updated.

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

Check whether any of the following exist:
- `~/.claude/knowledge/systems/` (any subdirectories)
- `~/.claude/knowledge/projects/` (any subdirectories)
- `~/.claude/ideas/active/` or `~/.claude/ideas/archive/` (any files)

If any exist:

```
⚠️ Existing Forge data found at the global paths:

   [list each non-empty path found]

   After /company-add, all skills will resolve paths to the new company
   directory. This existing data will NOT be moved automatically.

   To migrate after setup, copy or move the above into:
   - ~/.claude/companies/[name]/knowledge/systems/
   - ~/.claude/companies/[name]/knowledge/projects/
   - ~/.claude/companies/[name]/ideas/

   Continue with setup? (yes/no)
```

If no, exit without changes.

### 3 — Name

If no name argument was given, ask:
> "What is the company name? (used as the directory name — lowercase, hyphens only)"

Normalise: lowercase, spaces/underscores → hyphens, strip non-alphanumeric/hyphen.
Confirm if normalisation changed the input: "I'll use `acme-corp`. Continue?"

---

## Company Operational Configuration

Work through each topic in order. Present one topic at a time — do not ask everything
at once. Explain briefly why each setting matters before asking. Capture all answers
for writing to `config.md` at the end.

---

### Topic 1 — Sprint & Delivery Cadence

```
Let's configure your delivery cadence — this affects how /standup surfaces
deadlines, how /sprint-end calculates carry-over, and how /go-nogo times
release gates.
```

**Q1.1** How long are your sprints?
- `1` — 1 week
- `2` — 2 weeks (default)
- `3` — 3 weeks
- `4` — 4 weeks
- `kanban` — No sprints; continuous flow

**Q1.2** What is your production release cadence?
- `end-of-sprint` — Release at the end of each sprint
- `monthly` — Monthly release cycle
- `quarterly` — Quarterly release cycle
- `on-demand` — Releases whenever a feature is ready
- `other` — Describe (captures as free text)

**Q1.3** *(If monthly or quarterly)* Which day does a release typically target?
> Example: "last Friday of the month", "15th of each month", "first Tuesday of the quarter"

---

### Topic 2 — Team Locations & Public Holidays

```
Forge uses team location to flag public holidays in sprint planning,
stand-ups, and when go-nogo or deployment dates fall on or near a
public holiday. If your team spans multiple countries or states,
capture each location.
```

**Q2.1** What is the primary team timezone?
> Use IANA format — e.g. `Australia/Sydney`, `America/New_York`, `Europe/London`

**Q2.2** What country/region governs public holidays for the primary team?
> E.g. `Australia/NSW`, `United Kingdom`, `United States/California`

**Q2.3** Are there additional team locations (offshore or multi-site teams)?
> Yes / No

If yes, for each additional location ask:
- Team or site name (e.g. "Bangalore office", "UK team")
- Timezone (IANA)
- Public holiday locale (country/region)

Repeat until the user says no more locations.

**Note:** Forge does not automatically fetch public holiday dates. It uses the
configured locales to flag: "check [locale] public holidays — [date] may be
a holiday." The human confirms. Specific known blackout dates go in Topic 3.

---

### Topic 3 — Change Freeze Periods

```
Freeze periods are recurring annual windows when deployment is either
restricted or inadvisable — year-end shutdowns, EOFY, peak trading
seasons, regulatory quiet periods. Forge will warn (not block) when a
planned deployment falls within or near a freeze window.
```

**Q3.1** Does the company have known recurring freeze periods? (yes/no)

If yes, collect each period:
- Window: start and end (e.g. "Dec 20 – Jan 5")
- Reason: (e.g. "Christmas/New Year shutdown", "EOFY", "Black Friday trading freeze")
- Type:
  - `warn-only` — Forge surfaces a warning; the human decides whether to proceed
  - `no-deploy` — Forge treats this as a hard block in `/go-nogo` and `/deploy`

Repeat until the user says no more periods.

**Q3.2** How far in advance should Forge start warning about an upcoming freeze?
> Default: 14 days. Accept a number of days.

---

### Topic 4 — Compliance & Regulatory Environment

```
Your compliance tier determines how /security-assessment behaves
(mandatory frequency, severity weighting) and how /go-nogo weights
the security gate before each release.
```

**Q4.1** Which tier best describes the company's compliance environment?

- `none` — No specific compliance requirements; general good practices apply
- `standard` — Industry-standard software practices; no regulatory mandate
- `regulated` — Subject to industry regulation (financial services, healthcare, etc.)
- `highly-regulated` — Strict regulatory oversight with formal audit requirements

**Q4.2** *(If regulated or highly-regulated)* Which frameworks apply?
> Select all that apply — e.g. `APRA`, `SOX`, `HIPAA`, `GDPR`, `ASD Essential Eight`,
> `PCI-DSS`, `ISO 27001`, or describe your own.

**Behaviour by tier:**

| Tier | /security-assessment | /go-nogo security gate |
|------|---------------------|----------------------|
| none | Run on request | Advisory check |
| standard | Run before major releases | Recommended — can override |
| regulated | Mandatory before every release | Required — cannot skip |
| highly-regulated | Mandatory before every release + periodic scheduled audits | Required — cannot skip; findings must be resolved or formally accepted |

---

### Topic 5 — External Approval Gate

```
Some companies require a Change Advisory Board (CAB), RFC process,
or manager sign-off before production deployment. If configured,
/go-nogo will include a confirmation step for external approval.
```

**Q5.1** Does production deployment require external approval beyond the team? (yes/no)

If yes:
- **Q5.2** What is it called? (e.g. `CAB`, `RFC`, `Change Request`, `Manager approval`)
- **Q5.3** What scope triggers it?
  - `all` — Required for every production deployment
  - `major` — Required only for significant changes (team's judgement)
  - `emergency` — Normal deployments bypass it; only required for standard changes
- **Q5.4** Is there a system or URL where the approval is recorded?
  > E.g. ServiceNow URL, Jira ticket format — or leave blank.

---

### Topic 6 — Deployment Environment Chain

```
Forge's /deploy skill needs to know the standard environment sequence
so it can confirm each stage before proceeding to the next.
```

**Q6.1** What is the standard environment chain for deployments?

- `standard` — `dev → staging → prod` (default)
- `custom` — Provide the chain in order

If custom, ask:
> "List your environments in deployment order, e.g.: dev, test, UAT, prod"

Accept a comma-separated or freeform list. Store as ordered sequence.

**Q6.2** Are there any environments that require manual sign-off before proceeding?
> E.g. "UAT requires QA lead sign-off before prod" — or "None, all automated"

---

### Topic 7 — AI Usage Policy

```
Some companies have formal policies governing AI-assisted development —
human review requirements, data classification restrictions, or spend limits.
Capturing these ensures Forge skills enforce your policy automatically.
```

**Q7.1** Does the company have a formal AI usage policy? (yes/no)

If yes:

- **Q7.2** Is human sign-off required on AI-generated code before it is merged?
  > Yes / No. If yes, /build adds an explicit HITL review gate before completion.

- **Q7.3** Are there data classification restrictions on what can appear in AI prompts?
  > E.g. "No PII in prompts", "No customer data", "Classified data prohibited"
  > Describe briefly, or "None". This surfaces in /pii-check and /build warnings.

- **Q7.4** Is there a monthly AI spend cap?
  > Enter amount in USD, or "None". Used by /dashboard-tokens to show budget status.

- **Q7.5** Is there a policy document or URL the team should reference?
  > URL or internal doc name, or leave blank.

If no formal policy:
- **Q7.6** Would you like to set a monthly spend cap for cost awareness? (optional)
  > Enter amount in USD, or skip.

---

### Topic 8 — Tools Policy

```
Capturing your company tool requirements creates the tools.md registry that
/build pre-flight, /security-assessment, and /dependency-update query. Full
tool details (check-command, install-hint, usage) are added later via
/tool-add --company [name] — here we capture policy intent only.
```

**Q8.1** Are there tools **prohibited** for all company projects? (yes/no)
> Compliance restrictions, licensing conflicts, or security policy.
> If yes, list each: name + reason (e.g. `curl — policy requires wget only`)

**Q8.2** Are there tools **required** on every project? (yes/no)
> Mandatory security scanners, approved test runners, code signing tools, etc.
> If yes, list each: name + category (e.g. `semgrep — security-scanner`)

**Q8.3** Are there **approved** standard tools the team uses across projects? (yes/no)
> Tools that are preferred but not mandatory.
> If yes, list each: name + category (e.g. `pytest — test-runner`)

All captured entries are written as skeleton rows in `tools.md` with a
`# TODO: run /tool-add --company [name] to add full details` comment per entry.

---

## Confirm Before Writing

Present a full summary of all captured configuration before writing anything:

```
Ready to set up Forge for [Company Name].

─── Directory Structure ──────────────────────────────
~/.claude/companies/[name]/
  config.md            ← fully populated from this session
  registry.md
  tools.md             ← required/approved/prohibited tools registry
  projects/
    registry.md        ← company project index
  knowledge/
    Raw/               unprocessed source material (ingest on-ramp)
    Wiki/              compiled concept articles
    Outputs/           published deliverables
    company/           acronyms.md, context.md, style-guide.md
    systems/           populated by /add-system
    projects/          populated by /add-project (knowledge content)
    legal/             contracts, legal advice — Raw/ first, then Wiki/
    technology/        Raw/ intake here — ingest classifies into sub-categories
      technology1/ ... technology8/   ← Wiki/Outputs only; hardware/ inside each (Wiki/Outputs only)
    publish/           confluence config
  ideas/active/ archived/
  rules/               company rule extensions (layers on global common/)
  metrics/             cross-project metrics
  reviews/             FY reviews (private)
  retrospectives/      sprint retros (private)
  pir/                 Post Implementation Reviews (private)
  .claude/
    CLAUDE.md          ← repo onboarding context for Claude
    commands/          ← 18 bundled company knowledge commands
    skills/            ← 18 bundled company knowledge skills
  setup.sh             ← one-time teammate setup script

─── Configuration Summary ────────────────────────────
Company:           [Company Name]
Sprint length:     [N weeks / Kanban]
Release cadence:   [end-of-sprint / monthly / quarterly / on-demand]

Team locations:
  • [Primary Team] — [timezone] ([locale])
  [• Additional teams if any]

Freeze periods:     [N configured / None]
  [List each window + type if any]

Compliance tier:    [none / standard / regulated / highly-regulated]
  [Frameworks if applicable]

External approval:  [None / CAB / RFC / etc. — scope]

Deploy chain:       [dev → staging → prod or custom]
  [Manual gates if any]

AI policy:          [None / Active]
  [Key constraints if any]
  Monthly cap:      [$N / None]

Tools:
  Prohibited:       [N tools / None]
  Required:         [N tools / None]
  Approved:         [N tools / None]

preferences.md will be updated: active_company: [name]

This data is stored outside the Forge repo — never committed to GitHub.
─────────────────────────────────────────────────────
Proceed? (yes/no)
```

---

## Create Structure

On confirmation, create all directories and stub files.

### Directories

```
~/.claude/companies/[name]/
~/.claude/companies/[name]/projects/
~/.claude/companies/[name]/knowledge/
~/.claude/companies/[name]/knowledge/Raw/
~/.claude/companies/[name]/knowledge/Wiki/
~/.claude/companies/[name]/knowledge/Outputs/
~/.claude/companies/[name]/knowledge/company/
~/.claude/companies/[name]/knowledge/systems/
~/.claude/companies/[name]/knowledge/projects/
~/.claude/companies/[name]/knowledge/legal/
~/.claude/companies/[name]/knowledge/legal/Raw/
~/.claude/companies/[name]/knowledge/legal/Wiki/
~/.claude/companies/[name]/knowledge/legal/Outputs/
~/.claude/companies/[name]/knowledge/technology/
~/.claude/companies/[name]/knowledge/technology/Raw/
~/.claude/companies/[name]/knowledge/technology/Wiki/
~/.claude/companies/[name]/knowledge/technology/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology1/
~/.claude/companies/[name]/knowledge/technology/technology1/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology1/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology1/hardware/
~/.claude/companies/[name]/knowledge/technology/technology1/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology1/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology2/
~/.claude/companies/[name]/knowledge/technology/technology2/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology2/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology2/hardware/
~/.claude/companies/[name]/knowledge/technology/technology2/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology2/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology3/
~/.claude/companies/[name]/knowledge/technology/technology3/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology3/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology3/hardware/
~/.claude/companies/[name]/knowledge/technology/technology3/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology3/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology4/
~/.claude/companies/[name]/knowledge/technology/technology4/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology4/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology4/hardware/
~/.claude/companies/[name]/knowledge/technology/technology4/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology4/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology5/
~/.claude/companies/[name]/knowledge/technology/technology5/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology5/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology5/hardware/
~/.claude/companies/[name]/knowledge/technology/technology5/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology5/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology6/
~/.claude/companies/[name]/knowledge/technology/technology6/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology6/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology6/hardware/
~/.claude/companies/[name]/knowledge/technology/technology6/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology6/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology7/
~/.claude/companies/[name]/knowledge/technology/technology7/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology7/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology7/hardware/
~/.claude/companies/[name]/knowledge/technology/technology7/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology7/hardware/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology8/
~/.claude/companies/[name]/knowledge/technology/technology8/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology8/Outputs/
~/.claude/companies/[name]/knowledge/technology/technology8/hardware/
~/.claude/companies/[name]/knowledge/technology/technology8/hardware/Wiki/
~/.claude/companies/[name]/knowledge/technology/technology8/hardware/Outputs/
~/.claude/companies/[name]/knowledge/publish/
~/.claude/companies/[name]/.claude/
~/.claude/companies/[name]/.claude/commands/
~/.claude/companies/[name]/.claude/skills/
~/.claude/companies/[name]/ideas/
~/.claude/companies/[name]/ideas/active/
~/.claude/companies/[name]/ideas/archived/
~/.claude/companies/[name]/rules/
~/.claude/companies/[name]/metrics/
~/.claude/companies/[name]/reviews/
~/.claude/companies/[name]/retrospectives/
~/.claude/companies/[name]/pir/
```

### `projects/registry.md`

```markdown
# [Company Name] — Project Registry

All active and archived company projects. Updated by /add-project and /create-project.

**Last updated:** YYYY-MM-DD

---

## Active Projects

| ID | Project | Status | Owner | Tech Stack | Knowledge | Repo |
|----|---------|--------|-------|-----------|-----------|------|
| | | | | | | |

---

## Archived Projects

| ID | Project | Archived | Notes |
|----|---------|---------|-------|
| | | | |
```

### `config.md`

Write with all values captured during the grilling session. Blank fields use the
default or a clearly labelled placeholder.

```markdown
# Company Config — [Company Name]

## Identity
company_name: [Company Name]
domain: (fill in — e.g. yourcompany.com)
jira_base_url: (fill in if using Jira — e.g. https://yourcompany.atlassian.net)
active: true
created: YYYY-MM-DD

## Financial Year
fy_start: July 1
review_display_name: FY Review

## Sprint & Delivery Cadence
sprint_length_weeks: 2
release_cadence: end-of-sprint
# release_cadence options: end-of-sprint | monthly | quarterly | on-demand
release_day: (fill in for monthly/quarterly — e.g. "last Friday of the month")

## Team Locations
# Used by /standup and /sprint-start to flag public holidays.
# Forge warns when dates fall near holidays for configured locales — does not auto-fetch calendars.

[[teams]]
name: Primary Team
timezone: [IANA timezone — e.g. Australia/Sydney]
locale: [country/region — e.g. Australia/NSW]

# Additional teams (uncomment and fill in as needed):
# [[teams]]
# name: [Team name]
# timezone: [IANA timezone]
# locale: [country/region]

## Change Freeze Periods
# Recurring annual windows where deployment is restricted or inadvisable.
# type: warn-only (advisory) | no-deploy (hard block in /go-nogo and /deploy)
# Forge warns [freeze_warning_days_ahead] days before a freeze window begins.
freeze_warning_days_ahead: 14

# [[freeze_periods]]
# window: Dec 20 – Jan 5
# reason: Christmas / New Year shutdown
# type: warn-only

## Compliance
compliance_tier: standard
# compliance_tier options: none | standard | regulated | highly-regulated
compliance_frameworks:
# List applicable frameworks if regulated or higher:
# - APRA
# - SOX
# - HIPAA
# - GDPR
# - ASD Essential Eight
# - PCI-DSS
# - ISO 27001

## External Approval Gate
external_approval_required: false
external_approval_name: (e.g. CAB, RFC, Change Request, Manager approval)
external_approval_scope: all
# external_approval_scope options: all | major | emergency
external_approval_url: (optional — ServiceNow URL, Jira format, etc.)

## Deployment Environments
# Ordered chain — /deploy confirms each stage before proceeding to the next.
deployment_chain: dev → staging → prod
# Custom example: dev → test → UAT → prod
deployment_manual_gates:
# List any environments requiring manual sign-off before the next stage:
# - UAT: QA lead sign-off required

## AI Usage Policy
ai_policy_active: false
ai_policy_url: (optional — URL or internal document name)
ai_human_signoff_required: false
# If true, /build adds a HITL review gate before completion
ai_data_restrictions: none
# Describe any restrictions — e.g. "No PII in prompts", "No customer data"
# Surfaces in /pii-check and /build warnings
ai_monthly_spend_cap_usd:
# Leave blank for no cap. Used by /dashboard-tokens to show budget vs actual.

## AI Cost Tracking
# token_cost_per_1k: 0.003
# Set to your per-1k-token rate to enable cost-per-feature metrics.
# Check current model pricing before setting.
```

### Other stub files

Create the following stub files:

- `registry.md` — company registry (same structure as `~/.claude/registry.md`, titled for the company)
- `knowledge/company/acronyms.md`, `knowledge/company/context.md`, `knowledge/company/style-guide.md` — knowledge placeholders
- `knowledge/publish/confluence.example.md` and `knowledge/publish/.gitignore` — publish config
- `knowledge/legal/Raw/_compiled.log` — empty compiled log (same format as other Raw/ logs)
- `knowledge/legal/Wiki/_index.md` — legal wiki index stub (sensitive — note that contents may be legally privileged; run `/pii-check` before sharing or publishing)
- `knowledge/legal/Wiki/_changelog.md` — legal wiki changelog stub
- `knowledge/technology/Raw/_compiled.log` — empty compiled log
- `knowledge/technology/Wiki/_index.md` — technology wiki index stub; note sub-categories are placeholders — rename `technology1`–`technology8` to reflect actual domains at install (e.g. `architecture`, `infrastructure`, `security`, `data`, `cloud`, `integrations`, `devops`, `standards`)
- `knowledge/technology/Wiki/_changelog.md` — technology wiki changelog stub
- For each `technology1/` through `technology8/`: create `Wiki/_index.md` (titled with placeholder name + "rename at install" note) and `Wiki/_changelog.md` — no Raw/ or _compiled.log; ingest routes here from `technology/Raw/`
- For each `technologyN/hardware/`: create `Wiki/_index.md` and `Wiki/_changelog.md` — same pattern, no Raw/
- `tools.md` — pre-populate with skeleton entries for any prohibited/required/approved tools captured in Topic 8; each entry flagged with `# TODO: run /tool-add --company [name] to complete details`; if none captured, create an empty `tools.md` with the standard header (see `/tool-add` appendix template)
- `projects/registry.md` — company project index stub; populated incrementally by `/add-project` and `/create-project`
- `rules/README.md` — explain that `~/.claude/rules/common/` is the universal baseline; rules in this directory are company-specific extensions and overrides; stub out sections for naming conventions, compliance gates, and deployment rules; note that projects activate rules via `.claude/rules/active.md`

---

### Company Skills

Copy the following 18 skills from the user's global `~/.claude/` install into the company repo at the time `/company-add` runs. Each skill gets two files:

- `~/.claude/companies/[name]/.claude/skills/[skill]/SKILL.md` — full skill content (copied verbatim)
- `~/.claude/companies/[name]/.claude/commands/[skill].md` — command trigger file (copied verbatim)

**Skills to bundle (17):**

| Skill | Purpose |
|-------|---------|
| `ingest` | Process Raw/ → Wiki/ |
| `knowledge-health` | Check knowledge coverage |
| `add-system` | Document a new system |
| `add-term` | Add a term to the glossary |
| `summarise-system` | Create system summaries |
| `update-context` | Update company context |
| `lookup` | Search the knowledge base |
| `style-check` | Validate docs against style guide |
| `pii-check` | Check for PII exposure |
| `company-sync` | Push/pull to company git remote |
| `add-project` | Register a project |
| `incident` | Log and manage incidents |
| `pir` | Post-implementation reviews |
| `idea` | Capture and stress-test ideas |
| `tool-add` | Register a tool |
| `tool-check` | Verify tool installation |
| `knowledge-onboard` | Initial company knowledge setup |

If a skill file is missing from `~/.claude/` (not yet installed), note it in the confirm output and skip — do not block setup.

**Version note:** Skills are copied at install time. To update after a Forge upgrade, re-run `/company-add` or manually overwrite the `.claude/skills/[skill]/SKILL.md` files from `~/.claude/skills/`.

---

### `setup.sh`

Write to `~/.claude/companies/[name]/setup.sh`:

```bash
#!/usr/bin/env bash
# [Company Name] — Forge Knowledge Base Setup
# Run once after cloning: bash setup.sh
set -e

COMPANY_NAME="[name]"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

echo "Setting up Forge for [Company Name]..."

# 1. Symlink company repo into Forge companies directory
mkdir -p "$CLAUDE_DIR/companies"
ln -sfn "$REPO_DIR" "$CLAUDE_DIR/companies/$COMPANY_NAME"
echo "  ↳ Linked: ~/.claude/companies/$COMPANY_NAME → $REPO_DIR"

# 2. Set active_company in preferences.md
PREFS="$CLAUDE_DIR/preferences.md"
if grep -q "^active_company:" "$PREFS" 2>/dev/null; then
  sed -i "s|^active_company:.*|active_company: $COMPANY_NAME|" "$PREFS"
  echo "  ↳ Updated active_company in preferences.md"
else
  echo "active_company: $COMPANY_NAME" >> "$PREFS"
  echo "  ↳ Set active_company: $COMPANY_NAME in preferences.md"
fi

# 3. Install company skills and commands to ~/.claude/
SKILLS_SRC="$REPO_DIR/.claude/skills"
CMDS_SRC="$REPO_DIR/.claude/commands"

if [ -d "$SKILLS_SRC" ]; then
  for skill_dir in "$SKILLS_SRC"/*/; do
    skill=$(basename "$skill_dir")
    mkdir -p "$CLAUDE_DIR/skills/$skill"
    cp "$skill_dir/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"
  done
  echo "  ↳ Installed $(ls "$SKILLS_SRC" | wc -l | tr -d ' ') company skills"
fi

if [ -d "$CMDS_SRC" ]; then
  mkdir -p "$CLAUDE_DIR/commands"
  cp "$CMDS_SRC"/*.md "$CLAUDE_DIR/commands/"
  echo "  ↳ Installed $(ls "$CMDS_SRC"/*.md | wc -l | tr -d ' ') company commands"
fi

echo ""
echo "✅ Setup complete. Restart Claude Code and run /knowledge-health to verify."
echo "   Windows users: run this script in Git Bash or WSL."
```

---

### `.claude/CLAUDE.md`

Write to `~/.claude/companies/[name]/.claude/CLAUDE.md`:

```markdown
# [Company Name] — Forge Knowledge Base

This repository is the shared company knowledge base for [Company Name].

## First-time setup

Run the setup script to connect this repo to your local Forge install:

```bash
bash setup.sh
```

This links the repo to `~/.claude/companies/[name]/`, sets `active_company`,
and installs 18 company knowledge skills. Restart Claude Code after running.

Windows: run in Git Bash or WSL.

## Available commands

| Command | What it does |
|---------|-------------|
| `/ingest` | Process Raw/ material into Wiki articles |
| `/knowledge-health` | Check knowledge coverage and find gaps |
| `/add-system` | Document a new system |
| `/add-term` | Add a term to the company glossary |
| `/lookup` | Search the knowledge base |
| `/company-sync` | Push/pull knowledge updates with the team |
| `/style-check` | Validate a document against the company style guide |
| `/pii-check` | Check content for PII before sharing |
| `/incident` | Log and manage an incident |
| `/idea` | Capture and stress-test an idea |

## Repository structure

- `knowledge/` — company knowledge base (Raw/ → Wiki/ → Outputs/)
- `instincts/` — company-specific patterns and learnings
- `rules/` — company coding standard extensions
- `config.md` — company operational configuration
- `tools.md` — approved, required, and prohibited tools
- `projects/registry.md` — company project index
```

---

## Update `preferences.md`

Add or update in `~/.claude/preferences.md`:

```
active_company: [name]
```

Create the file if it doesn't exist.

---

## Confirm

```
✅ Company "[Company Name]" configured.

   Data location:  ~/.claude/companies/[name]/
   Config written: ~/.claude/companies/[name]/config.md
   Knowledge:      ~/.claude/companies/[name]/knowledge/ (Raw/ → Wiki/ → Outputs/)
   Projects:       ~/.claude/companies/[name]/projects/registry.md
   Tools:          ~/.claude/companies/[name]/tools.md
   Rules:          ~/.claude/companies/[name]/rules/
   Skills bundled: ~/.claude/companies/[name]/.claude/ (17 company knowledge skills)
   Setup script:   ~/.claude/companies/[name]/setup.sh

   Note: the global registry at ~/.claude/registry.md is superseded by
   ~/.claude/companies/[name]/registry.md — all skills write to the company registry.

Skills that read your new config:
  /standup         → flags public holidays and upcoming freeze periods
  /sprint-start    → flags public holidays falling within the sprint
  /go-nogo         → checks freeze periods, compliance tier, external approval gate
  /deploy          → uses configured environment chain and manual gates
  /security-assessment → mandatory frequency based on compliance tier
  /pii-check       → surfaces data restriction policy
  /build           → pre-flight checks required tools; HITL sign-off if ai_human_signoff_required
  /tool-check      → verifies required tools are installed on this machine
  /dashboard-tokens → shows spend vs monthly cap if configured
  /fy-review       → uses fy_start and review_display_name
  /ingest          → routes Raw/Wiki to knowledge/ (shared with team)

Next steps:
  1. Fill in config.md — domain, jira_base_url, token_cost_per_1k
  2. Run /knowledge-onboard to populate style-guide, acronyms, and domain terms
  3. Run /add-system [name] to add your first system
  4. Drop source material into knowledge/Raw/ and run /ingest to start building the Wiki
  5. Run /company-git to set up the shared company repository
  6. Share the repo — teammates run: bash setup.sh
  7. Run /tool-add --company [name] to complete tool details for entries registered during setup
  8. Run /tool-check to verify required tools are installed
  9. Run /setup-confluence if publishing to Confluence
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `active_company` already set | Warn and exit — do not overwrite |
| Directory already exists | Warn: "Directory already exists. Overwrite stub files?" Require confirmation. |
| `preferences.md` missing | Create it |
| Name normalisation produces empty string | Ask user to provide a valid name |
| User skips a grilling topic | Record as default or blank with a `# TODO` comment in config.md — do not block setup |
| User provides non-IANA timezone | Accept as-is but note: "Verify this is a valid IANA timezone — /standup will use it for holiday warnings." |
| Skill missing from ~/.claude/ at bundle time | Skip it, note in confirm output: "⚠️ [skill] not found in ~/.claude/skills/ — not bundled. Install Forge first if this is needed." |

---

## Rules

- Never proceed to write without explicit confirmation of the full summary
- Never overwrite an existing `active_company` setting without warning
- All grilling topics may be skipped — note defaults and add `# TODO` comments
- The `~/.claude/companies/` path is outside the Forge repo — no `.gitignore` needed in the repo
- Do not create a `.git` repository inside the company directory — that is `/company-git`'s job
- Never pre-populate stub files with invented company data
- config.md is written once with real values — it is not a template for the user to fill in manually (beyond the labelled placeholders)
