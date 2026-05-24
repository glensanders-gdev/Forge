---
name: publish
description: Publish wiki articles and ideas to Confluence. Pushes changed articles since the last publish run, or all articles with --all. One-way: wiki and ideas are the master, Confluence is the published view. Use when user runs /publish or /publish --all.
---

# Publish

> **Company-aware:** When `active_company` is set in `~/.claude/preferences.md` (configured by `/company-add`), publish config is read from `~/.claude/companies/[active_company]/knowledge/publish/confluence.md` and wiki content is sourced from the company knowledge directory instead of the global paths below.

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
| `/publish` | Articles changed since `last_published` in config, across all wikis + active ideas |
| `/publish --all` | All wiki articles and all active ideas regardless of change date |
| `/publish [system-name]` | Changed articles in `systems/[name]/Wiki/` only |
| `/publish projects/[name]` | Changed articles in `projects/[name]/Wiki/` only |
| `/publish ideas` | Active ideas only |

---

## What Gets Published

### Wiki Articles
Changed articles are identified by reading `Wiki/_changelog.md` entries dated after
`last_published`. Scope: global `Wiki/`, all `systems/*/Wiki/`, all `projects/*/Wiki/`.

Articles published:
- All `.md` files in `Wiki/` except `_index.md`, `_compiled.log`
- `_changelog.md` is published as its own Confluence page
- `_index.md` content is used to build the Confluence page hierarchy, not published as a page

### Ideas
Ideas are published directly from `~/.claude/ideas/active/` — no knowledge base tier.
Changed ideas are identified by comparing each `idea.md` `Last updated` date against `last_published`.

Published per idea:
- `idea.md` → one Confluence page per idea
- Page title: `[IDEA-NNN] [Idea Name]` — or `[IDEA-NNN / PROJ-123] [Idea Name]` when a
  current Jira ID exists in `external_ids.jira.current`
- Reference block at top of page:

  ```
  Forge ID: IDEA-NNN
  Jira: PROJ-123 (ticket)        ← shown only when external_ids.jira.current exists
  Status: Active | Holding
  Impact: High | Medium | Low
  Effort: High | Medium | Low
  ```

- Diagrams: if a Mermaid plugin is installed in Confluence, render `diagram.mmd` inline;
  otherwise include the Mermaid source as a fenced code block labelled `mermaid`
- Full ID history (superseded Jira IDs) shown in a collapsed section at the bottom of the page

Archived ideas (`~/.claude/ideas/archived/`) are not published — they remain local only.

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
  ├── Projects
  │   └── [Project Name]
  │       ├── Overview
  │       ├── Decisions
  │       ├── Known Issues
  │       └── Changelog
  └── Ideas
      ├── [IDEA-001] [Idea Name]    ← Active
      ├── [IDEA-002] [Idea Name]    ← Holding
      └── ...
```

The Ideas section is a flat list — no nesting. Each idea is its own page titled with its
tracking ID and name so it is scannable and referenceable by ID in other pages or tickets.

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
     -d '{"version":{"number":[current+1]},"title":"[title]","body":{"representation":"storage","value":"[csf-content]"}}' \
     "[base_url]/wiki/api/v2/pages/[page-id]"
   ```
3. **If page does not exist** — create it under the correct parent:
   ```bash
   curl -X POST -H "Authorization: Bearer [token]" \
     -H "Content-Type: application/json" \
     -d '{"spaceId":"[space-id]","parentId":"[parent-id]","title":"[title]","body":{"representation":"storage","value":"[csf-content]"}}' \
     "[base_url]/wiki/api/v2/pages"
   ```
   `[csf-content]` is the article body converted from Markdown to Confluence Storage Format
   (CSF — an XHTML-based format). Key conversions: headings (`# →  <h1>`), bold (`**text**` →
   `<strong>text</strong>`), links (`[text](url)` → `<a href="url">text</a>`), code blocks
   (` ``` ` → `<ac:structured-macro ac:name="code">`). Convert before posting.
4. **Log result** — append to `~/.claude/knowledge/publish/publish-log.md`:
   ```
   YYYY-MM-DD | [page-title] | [confluence-page-id] | success | run-N
   YYYY-MM-DD | [page-title] | — | failed: [reason] | run-N | consecutive-failures: N
   ```

After all articles:

5. **Check for orphans** — Confluence pages under `root_page_id` with no matching Wiki article.
   List them in the publish summary. Never delete automatically.
6. **Update `last_published`** in `confluence.md` to today's date (only if zero failures)
7. **Present publish summary**:
   - Retry queue processed (N pages retried, N succeeded, N escalated)
   - Articles published (created / updated)
   - Orphaned Confluence pages flagged (if any)
   - Failures this run (with reasons)
   - Escalated failures requiring human review (if any)

---

## Retry Mechanism

Failed pages are tracked in `~/.claude/knowledge/publish/publish-log.md` — a retry queue
separate from `last_published`.

**At the start of every `/publish` run:**
1. Read `publish-log.md` for any entries with status `failed`
2. Retry each failed page through the normal publish pipeline
3. On success: update the entry to `success` in `publish-log.md`
4. On second consecutive failure: move entry to the `## Escalated` section of `publish-log.md`,
   stop retrying automatically, surface prominently in the publish summary

**`last_published` is only updated when the run completes with zero failures** (retries + new pages).
This ensures the next run re-attempts any outstanding failures via the changelog.

**publish-log.md format:**
```markdown
# Publish Log

## Active Retry Queue
| Date | Title | Page ID | Status | Run | Consecutive Failures |
|------|-------|---------|--------|-----|---------------------|
| YYYY-MM-DD | [title] | — | failed: [reason] | 1 | 1 |

## Escalated (requires human review)
| Date | Title | Reason | First failed |
|------|-------|--------|-------------|
| YYYY-MM-DD | [title] | [reason] | YYYY-MM-DD |
```

`publish-log.md` is gitignored — it is transient publish state, not source material.

## Failure Handling

- A single page failure does not stop the batch — log it to `publish-log.md` and continue
- If more than 20% of pages fail in a single run, stop and report: likely a connection or auth issue
- Two consecutive failures on the same page → escalate to `## Escalated` section, stop auto-retry

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
