---
name: publish
description: Publish wiki articles to Confluence. Pushes changed articles since the last publish run, or all articles with --all. One-way: wiki is the master, Confluence is the published view. Use when user runs /publish or /publish --all.
---

# Publish

Publish wiki articles to the configured Confluence space. The wiki is always the master —
Confluence is the published view. Edits made directly in Confluence will be overwritten
on the next publish.

---

## Pre-flight Checks

Before publishing:

1. **Check config exists** — look for `~/.claude/knowledge/publish/confluence.md`
   - If missing: stop and display setup instructions (see below)
2. **Validate config** — confirm `base_url`, `space_key`, `root_page_id`, `auth_method`,
   and `auth_token` are all present and non-empty
3. **Test connection** — make a lightweight API call to verify credentials:
   ```bash
   curl -s -o /dev/null -w "%{http_code}" \
     -H "Authorization: Bearer [token]" \
     "[base_url]/wiki/api/v2/spaces?keys=[space_key]"
   ```
   If response is not 200, stop and report the error with likely causes.

---

## Scope

| Invocation | Scope |
|---|---|
| `/publish` | Articles changed since `last_published` in config, across all wikis |
| `/publish --all` | All wiki articles regardless of change date |
| `/publish [system-name]` | Changed articles in `systems/[name]/Wiki/` only |
| `/publish projects/[name]` | Changed articles in `projects/[name]/Wiki/` only |

---

## What Gets Published

Changed articles are identified by reading `Wiki/_changelog.md` entries dated after
`last_published`. Scope: global `Wiki/`, all `systems/*/Wiki/`, all `projects/*/Wiki/`.

Articles published:
- All `.md` files in `Wiki/` except `_index.md`, `_compiled.log`
- `_changelog.md` is published as its own Confluence page
- `_index.md` content is used to build the Confluence page hierarchy, not published as a page

---

## Page Hierarchy in Confluence

Wiki folder structure maps to Confluence nested pages under `root_page_id`:

```
[Root Page]
  ├── Wiki (global articles)
  │   ├── [Article Title]
  │   └── Changelog
  ├── Systems
  │   └── [System Name]
  │       ├── Overview
  │       ├── Schema
  │       ├── Known Issues
  │       └── Changelog
  └── Projects
      └── [Project Name]
          ├── Overview
          ├── Decisions
          ├── Known Issues
          └── Changelog
```

---

## Publish Pipeline

For each article to publish:

1. **Check if page exists** in Confluence by title and parent:
   ```bash
   curl -H "Authorization: Bearer [token]" \
     "[base_url]/wiki/api/v2/pages?spaceKey=[space_key]&title=[encoded-title]"
   ```
2. **If page exists** — update it:
   ```bash
   curl -X PUT -H "Authorization: Bearer [token]" \
     -H "Content-Type: application/json" \
     -d '{"version":{"number":[current+1]},"title":"[title]","body":{"representation":"wiki","value":"[content]"}}' \
     "[base_url]/wiki/api/v2/pages/[page-id]"
   ```
3. **If page does not exist** — create it under the correct parent:
   ```bash
   curl -X POST -H "Authorization: Bearer [token]" \
     -H "Content-Type: application/json" \
     -d '{"spaceId":"[space-id]","parentId":"[parent-id]","title":"[title]","body":{"representation":"wiki","value":"[content]"}}' \
     "[base_url]/wiki/api/v2/pages"
   ```
4. **Log result** — track page ID for future updates

After all articles:

5. **Check for orphans** — Confluence pages under `root_page_id` with no matching Wiki article.
   List them in the publish summary. Never delete automatically.
6. **Update `last_published`** in `confluence.md` to today's date
7. **Present publish summary**:
   - Articles published (created / updated)
   - Orphaned Confluence pages flagged (if any)
   - Any failures with reasons

---

## Failure Handling

- A single page failure does not stop the batch — log it and continue
- If more than 20% of pages fail, stop and report: likely a connection or auth issue
- Failed pages are not marked in `_changelog.md` — they will be retried on the next `/publish` run
  because `last_published` is only updated on full success

---

## Setup Instructions (shown when config is missing)

```
No Confluence publish target configured.

To set up:
1. Copy ~/.claude/knowledge/publish/confluence.example.md
   to ~/.claude/knowledge/publish/confluence.md
2. Fill in base_url, space_key, and root_page_id for your company's Confluence
3. Ask your Confluence administrator which auth method to use (PAT or api_key_email)
4. Add your credentials to auth_token (and auth_email if using api_key_email)
5. Run /publish again

confluence.md is gitignored — it will not be committed to the repository.
```

---

## Rules

- Wiki is the master. Never pull from Confluence into the wiki.
- Never delete Confluence pages automatically — flag orphans, let the human decide.
- `last_published` is only updated after a fully successful run.
- Credentials in `confluence.md` must never be committed or logged.
