---
name: ingest
description: Compile unprocessed Raw/ items into the Wiki. Handles three intake modes — files already in Raw/, uploaded files, and pasted text. Defaults to the current system context; use --all to process all systems. Use when user runs /ingest, drops files into Raw/, uploads a file in session, or pastes content to be added to the knowledge base.
---

# Ingest

> **Company-aware:** When `active_company` is set in `~/.claude/preferences.md` (configured by `/company-add`), all Raw/ and Wiki/ paths resolve under `~/.claude/companies/[active_company]/knowledge/` instead of `~/.claude/knowledge/`.

Compile unprocessed source material into the Wiki. Raw is always the origin — all intake
modes save to `Raw/` first, then flow through the same pipeline.

---

## Intake Modes

### Mode 1 — Raw/ folder (default)
Material already exists in `Raw/`. Run `/ingest` to process anything not yet in `_compiled.log`.

### Mode 2 — File upload
User uploads a file during the session. Before processing:
1. Determine the correct `Raw/` target (current system or global)
2. Generate a filename using the naming convention: `YYYY-MM-DD_[source-slug].[ext]`
3. Save the file to `Raw/`
4. Proceed with the standard pipeline

### Mode 3 — Chat paste
User pastes text content into the session. Before processing:
1. Ask for a source name to use in the slug (e.g. "karpathy blog post")
2. Save content as `YYYY-MM-DD_[source-slug].md` in the correct `Raw/`
3. Proceed with the standard pipeline

---

## Scope

| Invocation | Scope |
|---|---|
| `/ingest` | Ask user — no default (see below) |
| `/ingest --all` | All `Raw/` folders across global, all systems, and all projects |
| `/ingest [system-name]` | Named system only |
| `/ingest projects/[name]` | Named project only |
| `/ingest --global` | Global `knowledge/Raw/` only |

If no flag or name is provided, there is no default scope — ask the user:
> "Which Raw/ folder should I ingest? Options: --global, --all, or a system/project name."
Do not guess based on session context.

---

## Pipeline

For each uncompiled item:

1. **Read and summarise** the item
2. **Classify** — identify which concept(s) it belongs to
3. **Technology sub-category routing** — if the source path is `technology/Raw/`, after
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
4. **Check for cross-system scope** — if the concept requires two or more system names to
   explain, it belongs in global `Wiki/`. Check `cross_system_gate` in
   `~/.claude/preferences.md`:
   - `open` (or missing) → pause and confirm with the human before creating the article;
     write `cross_system_gate: confirmed` to `preferences.md` on approval
   - `confirmed` → proceed without confirmation
5. **Create or update** the relevant concept article(s) in the appropriate `Wiki/`
6. **Add backlinks** from the concept article to the Raw source
7. **Update `Raw/_compiled.log`**:
   ```
   YYYY-MM-DD | [filename] | compiled | [Wiki article(s) updated]
   ```
8. **Update `Wiki/_changelog.md`** — log `created` or `updated` with the article path
9. **On failure** — log `failed: [reason]` in `_compiled.log` and continue to next item

After all items:

10. **Update `Wiki/_index.md`** — refresh Recently Updated section and any new categories
11. **Present a summary**:
    - Items compiled
    - Articles created / updated
    - Cross-system articles created (if any)
    - Failures (with reasons)
    - Reminder to run `/knowledge-health` if failure count > 0

---

## Failure Handling

- Never stop mid-batch on a single failure — log it and continue
- Failed items appear in `_compiled.log` as `failed: [reason]`
- On the next `/ingest` run, failed items are retried automatically
- If the same item fails twice, flag it in the summary for human review

---

## Company Sync

After a successful compile run, if `active_company` is set and a company git remote is
configured, offer to push the new Wiki articles to the team:

```
✅ Ingest complete — N articles created/updated.

   Share with your team? Run /company-sync --push-only
```

Do not run `/company-sync` automatically — always offer and let the user decide.

---

## Rules

- Raw is always the origin — never compile content that hasn't been saved to `Raw/` first
- Never modify or delete existing `Raw/` files
- `_compiled.log` is append-only
- `_changelog.md` is updated on every compile run that creates or updates an article
- Prefer updating an existing article over creating a new one unless the concept is genuinely distinct
