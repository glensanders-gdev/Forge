---
name: "ingest"
description: "Compile unprocessed Raw/ items into the Wiki. Handles three intake modes — files already in Raw/, uploaded files, and pasted text. Prompts for scope via a numbered project list when no flag is given; use --all to process all Raw/ folders. Use when user runs $ingest, drops files into Raw/, uploads a file in session, or pastes content to be added to the knowledge base."
metadata:
  category: knowledge
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Ingest

> **Company-aware:** When `active_company` is set in `~/.codex/forge/preferences.md` (configured by `$company-add`), all Raw/ and Wiki/ paths resolve under `~/.codex/forge/companies/[active_company]/knowledge/` instead of `~/.codex/forge/knowledge/`.

Compile unprocessed source material into the Wiki. Raw is always the origin — all intake
modes save to `Raw/` first, then flow through the same pipeline.

---

## Intake Modes

### Mode 1 — Raw/ folder (default)
Material already exists in `Raw/`. Run `$ingest` to process anything not yet in `_compiled.log`.
Before processing: run the scope prompt (see Scope section) to determine which `Raw/` folder to scan.

### Mode 2 — File upload
User uploads a file during the session. Before processing:
1. Run the scope prompt (see Scope section) to determine the `Raw/` target
2. Generate a filename using the naming convention: `YYYY-MM-DD_[source-slug].[ext]`
3. Save the file to `Raw/`
4. Proceed with the standard pipeline

### Mode 3 — Chat paste
User pastes text content into the session. Before processing:
1. Run the scope prompt (see Scope section) to determine the `Raw/` target
2. Ask for a source name to use in the slug (e.g. "karpathy blog post")
3. Save content as `YYYY-MM-DD_[source-slug].md` in the correct `Raw/`
4. Proceed with the standard pipeline

---

## Scope

| Invocation | Scope |
|---|---|
| `$ingest` | Run scope prompt (see below) |
| `$ingest --all` | All `Raw/` folders across global, all systems, and all projects |
| `$ingest [system-name]` | Named system only |
| `$ingest projects/[name]` | Named project only |
| `$ingest --global` | Global `knowledge/Raw/` only |

### Scope Prompt (no flag or name provided)

When no scope is specified, run the following before doing anything else:

1. Read `~/.codex/forge/registry.md` — collect all active projects (PROJ-NNN rows with status Active).
2. **No projects found:** default silently to global and show:
   ```
   ℹ️ No projects registered — ingesting to global Raw/.
   ```
   Proceed without asking.
3. **Projects found:** present a numbered list. Pre-select (mark with `*`) any project whose
   path matches the current working directory.
   ```
   Where should this be ingested?

     0. Global   → ~/.codex/forge/knowledge/Raw/
     1. PROJ-001 My Project → ~/.codex/forge/knowledge/projects/my-project/Raw/
     2. PROJ-002 Another Project → ~/.codex/forge/knowledge/projects/another-project/Raw/

   Enter a number:
   ```
   Wait for the user's response before proceeding. Resolve the chosen path and use it as
   the `Raw/` target for the rest of the session.

---

## Pipeline

For each uncompiled item:

1. **Read and summarise** the item
2. **Classify** — identify which concept(s) it belongs to
3. **Feedback routing** — if the item is identifiably feedback content, route it directly
   to the appropriate article rather than creating a new concept article:
   - **Customer-sourced** (user emails, support tickets, survey responses, interview notes,
     complaint threads) → compile into `Wiki/customer-feedback.md`
   - **Stakeholder-sourced** (position papers, leadership memos, requirements documents,
     meeting notes from stakeholders) → compile into `Wiki/stakeholder-feedback.md`

   When compiling into a feedback article: extract the key themes, update the relevant
   table(s), and update the Sentiment Summary or Key Concerns Raised section as appropriate.
   Do not create a separate concept article for feedback items.

   If the item contains both feedback and technical content (e.g. a paper that includes
   requirements and architecture), split: route the feedback portions to the feedback article
   and the technical portions to a concept article.

4. **Technology sub-category routing** — if the source path is `technology/Raw/`, after
   classifying, list the available sub-categories (read from subdirectory names under
   `technology/`) and ask:
   ```
   Which technology domain does "[filename]" belong to?

   Available sub-categories:
   1. technology1 (or renamed equivalent)
   2. technology2
   ...

   Enter the number, or type 'top' to route to technology/Wiki/ without a sub-category.
   ```
   Wait for a response before proceeding. Route the article to the matching
   sub-category's `Wiki/` folder. If `top` is chosen, route to `technology/Wiki/` and
   note `⚠️ No sub-category assigned` in the compile log for later review.
5. **Check for cross-system scope** — if the concept requires two or more system names to
   explain, it belongs in global `Wiki/`. Check `cross_system_gate` in
   `~/.codex/forge/preferences.md`:
   - `open` (or missing) → pause and confirm with the human before creating the article;
     write `cross_system_gate: confirmed` to `preferences.md` on approval
   - `confirmed` → proceed without confirmation
6. **Create or update** the relevant concept article(s) in the appropriate `Wiki/`
7. **Add backlinks** from the concept article to the Raw source
8. **Update `Raw/_compiled.log`**:
   ```
   YYYY-MM-DD | [filename] | compiled | [Wiki article(s) updated]
   ```
9. **Update `Wiki/_changelog.md`** — log `created` or `updated` with the article path
10. **On failure** — log `failed: [reason]` in `_compiled.log` and continue to next item

After all items:

11. **Update `Wiki/_index.md`** — refresh Recently Updated section and any new categories
12. **Present a summary**:
    - Items compiled
    - Articles created / updated
    - Cross-system articles created (if any)
    - Failures (with reasons)
    - Reminder to run `$knowledge-health` if failure count > 0

---

## Failure Handling

- Never stop mid-batch on a single failure — log it and continue
- Failed items appear in `_compiled.log` as `failed: [reason]`
- On the next `$ingest` run, failed items are retried automatically
- If the same item fails twice, flag it in the summary for human review

---

## Company Sync

After a successful compile run, if `active_company` is set and a company git remote is
configured, offer to push the new Wiki articles to the team:

```
✅ Ingest complete — N articles created/updated.

   Share with your team? Run $company-sync --push-only
```

Do not run `$company-sync` automatically — always offer and let the user decide.

---

## Rules

- Raw is always the origin — never compile content that hasn't been saved to `Raw/` first
- Never modify or delete existing `Raw/` files
- `_compiled.log` is append-only
- `_changelog.md` is updated on every compile run that creates or updates an article
- Prefer updating an existing article over creating a new one unless the concept is genuinely distinct

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No scope flag and no projects registered | Default silently to global `Raw/` and proceed. |
| Content not yet in `Raw/` | Save it to `Raw/` first — never compile unsaved content. |
| Item is feedback content | Route to `customer-feedback.md` / `stakeholder-feedback.md` — don't create a concept article. |
| Concept spans 2+ systems | It belongs in global `Wiki/` — confirm via `cross_system_gate` before creating. |
| A single item fails to compile | Log `failed: [reason]` in `_compiled.log` and continue — never stop mid-batch. |
| Same item fails twice | Flag it in the summary for human review. |
| `active_company` set with a git remote | Offer `$company-sync --push-only` after the run — never push automatically. |
