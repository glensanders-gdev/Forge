# Confluence Publish Config — Example

Copy this file to `confluence.md` in the same folder and fill in your company details.
`confluence.md` is gitignored — never commit it. It contains credentials.

---

## Connection

```yaml
base_url: https://yourcompany.atlassian.net
space_key: KB
root_page_id: 123456
```

`base_url` — your Confluence instance URL (Cloud: `atlassian.net`, Data Center: your internal domain)
`space_key` — the Confluence space key where wiki pages will be published
`root_page_id` — the ID of the parent page under which all wiki pages will be nested.
  To find it: open the page in Confluence, go to ··· menu → Page Information → Page ID in the URL.

---

## Authentication

```yaml
auth_method: PAT
auth_token: your-token-here
auth_email:
```

## Optional Plugins

```yaml
mermaid_plugin: false
```

Set `mermaid_plugin: true` if your Confluence instance has a Mermaid rendering plugin installed
(e.g. "Mermaid Diagrams for Confluence" or similar). When `true`, `/publish` embeds diagrams
as rendered Mermaid. When `false` (default), diagrams are included as fenced code blocks.

---

## Authentication

`auth_method` options:
- `PAT` — Personal Access Token (recommended for Confluence Data Center and Cloud)
  Set `auth_token` to your PAT. Leave `auth_email` blank.
- `api_key_email` — Atlassian API key + email (Confluence Cloud)
  Set `auth_token` to your API key and `auth_email` to your Atlassian account email.

Ask your company's Confluence administrator which method is required.
To generate a PAT: Confluence → Profile → Personal Access Tokens → Create token.
To generate an API key: https://id.atlassian.com → Security → API tokens.

---

## Publish State

```yaml
last_published: never
```

`last_published` is updated automatically by `/publish` after each successful run.
Do not edit manually — it is used to determine which articles have changed since the last publish.
