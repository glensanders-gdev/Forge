---
name: ingest
description: Compile unprocessed Raw/ items into the Wiki. Handles three intake modes — files already in Raw/, uploaded files, and pasted text. Defaults to the current system context; use --all to process all systems. Use when user runs /ingest, drops files into Raw/, uploads a file in session, or pastes content to be added to the knowledge base.
---

# Ingest

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
| `/ingest` | Current system context — the system most recently referenced in this session |
| `/ingest --all` | All `Raw/` folders across global and all systems |
| `/ingest [system-name]` | Named system only |
| `/ingest --global` | Global `knowledge/Raw/` only |

If no system context is established and no flag is provided, ask the user which scope to use.

---

## Pipeline

For each uncompiled item:

1. **Read and summarise** the item
2. **Classify** — identify which concept(s) it belongs to
3. **Check for cross-system scope** — if the concept requires two or more system names to
   explain, it belongs in global `Wiki/`. Check `cross_system_gate` in
   `knowledge/CLAUDE.md` frontmatter:
   - `open` → pause and confirm with the human before creating the article; set gate to `confirmed` on approval
   - `confirmed` → proceed without confirmation
4. **Create or update** the relevant concept article(s) in the appropriate `Wiki/`
5. **Add backlinks** from the concept article to the Raw source
6. **Update `Raw/_compiled.log`**:
   ```
   YYYY-MM-DD | [filename] | compiled | [Wiki article(s) updated]
   ```
7. **Update `Wiki/_changelog.md`** — log `created` or `updated` with the article path
8. **On failure** — log `failed: [reason]` in `_compiled.log` and continue to next item

After all items:

9. **Update `Wiki/_index.md`** — refresh Recently Updated section and any new categories
10. **Present a summary**:
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

## Rules

- Raw is always the origin — never compile content that hasn't been saved to `Raw/` first
- Never modify or delete existing `Raw/` files
- `_compiled.log` is append-only
- `_changelog.md` is updated on every compile run that creates or updates an article
- Prefer updating an existing article over creating a new one unless the concept is genuinely distinct
