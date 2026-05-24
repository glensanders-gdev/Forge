---
name: setup-confluence
description: Interactively configure Confluence publishing for the knowledge base. Walks through connection details, auth method, and optional plugin settings. Validates the connection before writing confluence.md. Use when user runs /setup-confluence or sets up the knowledge base at a new company.
---

# Setup Confluence

> **Company-aware:** When `active_company` is set in `~/.claude/preferences.md` (configured by `/company-add`), `confluence.md` is written to `~/.claude/companies/[active_company]/knowledge/publish/` instead of `~/.claude/knowledge/publish/`.

Guided interactive setup for Confluence publishing. Asks one question at a time, validates
the connection before writing anything, and produces a ready-to-use `confluence.md`.

---

## Pre-check

Before starting, check if `~/.claude/knowledge/publish/confluence.md` already exists.
If it does: warn the user and ask to confirm before overwriting.

```
A Confluence config already exists. Continuing will overwrite it.
Type CONFIRM to proceed, or press Enter to cancel.
```

---

## Setup Questions (one at a time)

### Step 1 — Base URL
Ask:
> "What is your Confluence instance URL?"
> Examples: `https://yourcompany.atlassian.net` (Cloud) or `https://confluence.yourcompany.com` (Data Center)

Validate format: must start with `https://`. Strip trailing slash if present.

### Step 2 — Space Key
Ask:
> "What is the Confluence space key where wiki pages should be published?"
> To find it: open the space in Confluence → Space Settings → the key appears in the URL and settings page (e.g. `KB`, `TECH`, `PRODUCT`).

Validate: space key should be uppercase letters only. Warn if it contains lowercase or special characters.

### Step 3 — Root Page ID
Ask:
> "What is the page ID of the parent page under which all wiki pages will be nested?"
> To find it: open the page in Confluence → click ··· menu → Page Information → the ID appears in the URL as `?pageId=XXXXXXX`.

Validate: must be numeric.

### Step 4 — Auth Method
Ask:
> "Which authentication method does your company use?
> 1. PAT — Personal Access Token (recommended for Confluence Data Center and Cloud)
> 2. api_key_email — Atlassian API key + email (Confluence Cloud only)
>
> Ask your Confluence administrator if unsure."

### Step 5 — Credentials
**If PAT:**
Ask:
> "Enter your Personal Access Token."
> To generate: Confluence → Profile → Personal Access Tokens → Create token.
> The token will be stored in confluence.md which is gitignored.

**If api_key_email:**
Ask for API key:
> "Enter your Atlassian API key."
> To generate: https://id.atlassian.com → Security → API tokens → Create API token.

Then ask for email:
> "Enter the email address associated with your Atlassian account."

### Step 6 — Mermaid Plugin
Ask:
> "Does your Confluence instance have a Mermaid diagram rendering plugin installed? (yes/no)"
> Common plugins: 'Mermaid Diagrams for Confluence', 'Mermaid Plugin for Confluence'.
> If unsure, answer no — diagrams will be included as code blocks instead.

---

## Connection Test

Before writing any file, test the connection:

```bash
curl -s -o /dev/null -w "%{http_code}" \
  -H "Authorization: Bearer [token]" \
  "[base_url]/wiki/api/v2/spaces?keys=[space_key]"
```

For `api_key_email`:
```bash
curl -s -o /dev/null -w "%{http_code}" \
  -u "[email]:[api_key]" \
  "[base_url]/wiki/api/v2/spaces?keys=[space_key]"
```

- **200** → connection successful, proceed
- **401** → credentials rejected — ask user to check token/key and re-enter (return to Step 5)
- **403** → authenticated but no access to this space — ask user to check space key and permissions
- **404** → space not found — ask user to verify space key
- **Other** → report status code and likely cause, ask user to check base URL

---

## Write Config

On successful connection test, write `~/.claude/knowledge/publish/confluence.md`:

```markdown
# Confluence Publish Config

## Connection

base_url: [value]
space_key: [value]
root_page_id: [value]

## Authentication

auth_method: [PAT | api_key_email]
auth_token: [token or api_key]
auth_email: [email or blank]

## Optional Plugins

mermaid_plugin: [true | false]

## Publish State

last_published: never
```

---

## Confirm

After writing, confirm:

```
✓ Confluence configured successfully.

  Instance:   [base_url]
  Space:      [space_key]
  Root page:  [root_page_id]
  Auth:       [auth_method]
  Mermaid:    [enabled | disabled]

confluence.md is gitignored — it will not be committed to the repository.

Run /publish --all to do your first full publish.
```

---

## Rules

- Never display the auth token or API key back to the user after entry
- Never commit or log credentials
- Always test the connection before writing the file
- If the user cancels at any step, do not write a partial config
