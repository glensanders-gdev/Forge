---
name: company-add
description: Set up a company-specific file structure outside the Forge repo at ~/.claude/companies/[name]/. Grills the user on company operational config — sprint cadence, team locations, public holidays, freeze periods, compliance tier, external approval gates, deployment environments, and AI usage policy. Company data is never committed to the Forge GitHub. Use when user runs /company-add [name] or sets up Forge for a new company install.
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
2. Skip all 7 grilling topics — use every default value from the config template as-is.
3. Present a brief summary before writing:
   ```
   Quick setup — all defaults applied.

   Company: [name]
   Sprint length: 2 weeks
   Release cadence: end-of-sprint
   Compliance tier: standard
   External approval: none
   AI policy: none

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

## Confirm Before Writing

Present a full summary of all captured configuration before writing anything:

```
Ready to set up Forge for [Company Name].

─── Directory Structure ──────────────────────────────
~/.claude/companies/[name]/
  config.md            ← fully populated from this session
  registry.md
  knowledge/
    company/           acronyms.md, context.md, style-guide.md
    systems/           populated by /add-system
    projects/          populated by /add-project
    publish/           confluence config
  ideas/active/ archive/
  metrics/             cross-project metrics
  reviews/             FY reviews (private)
  retrospectives/      sprint retros (private)
  pir/                 Post Implementation Reviews (private)

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

Create `registry.md`, `knowledge/company/acronyms.md`, `knowledge/company/context.md`,
`knowledge/company/style-guide.md`, `knowledge/publish/confluence.example.md`,
and `knowledge/publish/.gitignore` as before (existing content unchanged).

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

   Note: the global registry at ~/.claude/registry.md is superseded by
   ~/.claude/companies/[name]/registry.md — all skills write to the company registry.

Skills that read your new config:
  /standup         → flags public holidays and upcoming freeze periods
  /sprint-start    → flags public holidays falling within the sprint
  /go-nogo         → checks freeze periods, compliance tier, external approval gate
  /deploy          → uses configured environment chain and manual gates
  /security-assessment → mandatory frequency based on compliance tier
  /pii-check       → surfaces data restriction policy
  /build           → adds HITL sign-off gate if ai_human_signoff_required: true
  /dashboard-tokens → shows spend vs monthly cap if configured
  /fy-review       → uses fy_start and review_display_name

Next steps:
  1. Fill in config.md — domain, jira_base_url, token_cost_per_1k
  2. Fill in knowledge/company/context.md and acronyms.md
  3. Run /add-system [name] to add your first system
  4. Run /setup-confluence if publishing to Confluence
  5. Run /company-git if you have a company-approved GitHub for this data
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

---

## Rules

- Never proceed to write without explicit confirmation of the full summary
- Never overwrite an existing `active_company` setting without warning
- All grilling topics may be skipped — note defaults and add `# TODO` comments
- The `~/.claude/companies/` path is outside the Forge repo — no `.gitignore` needed in the repo
- Do not create a `.git` repository inside the company directory — that is `/company-git`'s job
- Never pre-populate stub files with invented company data
- config.md is written once with real values — it is not a template for the user to fill in manually (beyond the labelled placeholders)
