---
name: ingest
category: knowledge
description: Compile unprocessed Raw/ items into the Wiki, then archive each compiled source under Raw/_archive/YYYY-MM/ so the top of Raw/ stays an inbox. Handles three intake modes — files already in Raw/, uploaded files, and pasted text. Prompts for scope when none is given; use --all to process every Raw/ folder. Use when user runs /ingest, drops files into Raw/, uploads a file in session, or pastes content to be added to the knowledge base.
---

# Ingest

**Execution mode:** `[HITL]` — every prompt in the pipeline waits for a human answer.
Everything between them is `[AFK]`.

Compile unprocessed source material into the Wiki. Raw is always the origin — all intake
modes save to `Raw/` first, then flow through the same pipeline.

---

## Folder Layout

A knowledge space is three tiers. `/ingest` reads the first and writes the second.

```
[knowledge-root]/
  Raw/
    2026-09-16_pending-source.pdf   ← inbox: uncompiled and failed items only
    _compiled.log                   ← the authoritative record of what has been compiled
    _archive/
      2026-08/                      ← compiled sources, filed by compile month
      2026-09/
  Wiki/
  Outputs/
```

Where no knowledge root exists yet, create `knowledge/Raw/` and `knowledge/Wiki/` at the
repository root and carry on — an empty `_compiled.log` is a valid starting state.

**The top level of `Raw/` is the pending queue.** Once an item compiles it moves into
`_archive/YYYY-MM/`, so what remains at the top is exactly what still needs work. `_archive/`
is created on first use — never scaffolded empty.

**`_archive/` is derived, never authoritative.** Every archived file's location is recoverable
from the date column of its `_compiled.log` line. If the two ever disagree, the log wins and
the archive is rebuilt to match.

---

## Intake Modes

### Mode 1 — Raw/ folder (default)
Material already exists in `Raw/`. Run `/ingest` to process anything at the **top level** of
`Raw/` not yet logged as `compiled`. A `failed:` line does not count — a failed item is still
pending, which is what makes the automatic retry work. Never descend into `_archive/` when scanning.
Before processing: run the scope prompt (see Scope section) to determine which `Raw/` folder to scan.

### Mode 2 — File upload
User uploads a file during the session. Before processing:
1. Run the scope prompt (see Scope section) to determine the `Raw/` target
2. Generate a filename using the naming convention: `YYYY-MM-DD_[source-slug].[ext]`
3. Save the file to the top level of `Raw/`
4. Proceed with the standard pipeline

### Mode 3 — Chat paste
User pastes text content into the session. Before processing:
1. Run the scope prompt (see Scope section) to determine the `Raw/` target
2. Ask for a source name to use in the slug (e.g. "karpathy blog post")
3. Save content as `YYYY-MM-DD_[source-slug].md` at the top level of the correct `Raw/`
4. Proceed with the standard pipeline

---

## Scope

| Invocation | Scope |
|---|---|
| `/ingest` | Run scope prompt (see below) |
| `/ingest --all` | Every `Raw/` folder in the knowledge base |
| `/ingest [system-name]` | Named system only |
| `/ingest projects/[name]` | Named project only |
| `/ingest --global` | Top-level `knowledge/Raw/` only |
| `/ingest --recompile [filename]` | One already-archived source, read in place (see Re-compiling an Archived Source) |

### Scope Prompt (no flag or name provided)

When no scope is specified, run the following before doing anything else:

1. Collect the candidate spaces.
2. **No candidates found:** default silently to the top-level knowledge root and show:
   ```
   ℹ️ No projects registered — ingesting to global Raw/.
   ```
   Proceed without asking.
3. **Candidates found:** present a numbered list. Pre-select (mark with `*`) any space whose
   path matches the current working directory.
   ```
   Where should this be ingested?

     0. Global   → knowledge/Raw/
     1. PROJ-001 My Project → knowledge/projects/my-project/Raw/
     2. PROJ-002 Another Project → knowledge/projects/another-project/Raw/

   Enter a number:
   ```
   Wait for the user's response before proceeding. Resolve the chosen path and use it as
   the `Raw/` target for the rest of the session.

---

## Pipeline

For each item at the top level of `Raw/` not yet logged as `compiled`:

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
   explain, it belongs in the top-level `Wiki/`.
6. **Create or update** the relevant concept article(s) in the appropriate `Wiki/`
7. **Add backlinks** from the concept article to the Raw source, at the source's
   **archive path** — never its top-level path, which stops resolving at step 9.

   **Resolve the month by lookup, not by today's date.** If the source already carries a
   `compiled` line, it is already archived: use the month of its **earliest** such line.
   Only a source with no `compiled` line uses the current compile month.

   **Write the link relative to the article, not to a fixed depth.** `../Raw/_archive/…`
   is correct only for an article sitting directly in the space's `Wiki/`. A sub-category
   wiki sits deeper — `technology/HFC/Wiki/` needs `../../Raw/_archive/…`, and
   `technology/HFC/hardware/Wiki/` needs `../../../`. Count the levels to the space that
   owns the `Raw/` folder; never assume one.
8. **Update `Raw/_compiled.log`**:
   ```
   YYYY-MM-DD | [filename] | compiled | [Wiki article(s) updated]
   ```
9. **Archive the source** — if the file is still at the top level of `Raw/`, move it to
   `Raw/_archive/YYYY-MM/`, creating the month folder if absent. `YYYY-MM` is the year and
   month of the date written at step 8, so the destination is always recoverable from the log.
   **A source already under `_archive/` is left exactly where it is** — it was filed on its
   first compile and it does not move again.

   **Log first, then move — never the reverse.** A crash between the two leaves a file that is
   logged but unarchived: harmless, detectable, and fixed by a single move. Moving first
   leaves a file that is archived but unlogged, which no later scan will ever see again.

   **One source can carry several `compiled` lines** — a large document compiled into three
   articles writes three. It is still one file and it moves once, under its **earliest**
   compile month. Later lines record further use of a source already archived, and they are
   written by `--recompile`, never by a second pass over the inbox.
10. **On failure** — log `failed: [reason]` in `_compiled.log`, **leave the file at the top
    level of `Raw/`**, and continue to the next item. A failed item is never archived; it stays
    in the inbox so the next run retries it.

After all items:

11. **Update `Wiki/_index.md`** — refresh Recently Updated section and any new categories
12. **Present a summary**:
    - Items compiled and archived
    - Articles created / updated
    - Cross-system articles created (if any)
    - Failures (with reasons), still in the inbox
    - Items remaining in the inbox

---

## Failure Handling

- Never stop mid-batch on a single failure — log it and continue
- Failed items appear in `_compiled.log` as `failed: [reason]` and stay at the top level of `Raw/`
- On the next `/ingest` run, failed items are retried automatically
- If the same item fails twice, flag it in the summary for human review

---

## Re-compiling an Archived Source

A large source is often exploited more than once — a 250-page manual compiled into an overview
first, then into a module extraction weeks later. Archiving must not make that second pass
impossible, and the inbox scan will never find the file again, so it is an explicit invocation:

```
/ingest --recompile 2026-07-10_sfaa-wba-operations-manual-20260601.pdf
```

1. Locate the source under `_archive/` via its earliest `compiled` line. If it has no
   `compiled` line, it is not archived — refuse, and say to run plain `/ingest` instead.
2. **Read it in place.** The file does not move, is not copied, and is not re-dated.
3. Run pipeline steps 1–8 against it. Step 7 resolves the backlink to the source's existing
   archive month, which is its earliest — never today's.
4. Step 9 is skipped entirely: the source is already filed.

The new `compiled` line carries **today's** date and names the articles this pass produced.
The log therefore records when each article was written, while the archive records when the
source arrived — two different facts, neither overwriting the other.

---

## Archive Reconciliation

Run before compiling when the log and the inbox disagree, or on request.

For every `compiled` line in `_compiled.log`, the named file is expected at
`Raw/_archive/[YYYY-MM from that line's earliest date]/[filename]`.

**Skip lines whose filename field is a parenthetical note** — `(direct session research)`,
`(no Raw file)` and the like record a compile that never had a source file. They are
deliberate entries, not missing files, and reporting them as errors trains the reader to
ignore the report.

Three findings, three responses:

| Finding | Meaning | Response |
|---|---|---|
| File at the top level of `Raw/`, logged as `compiled` | Interrupted run — logged, never moved | Move it to its derived archive path |
| File under `_archive/` with no `compiled` line | Archived without a log entry, or the log was truncated | Report it — never delete, never re-file on a guess |
| Logged as `compiled`, no file anywhere | The source was deleted after compiling | Report it as a broken provenance link; the Wiki article's backlink is dead |

Report all three; repair only the first. The other two are history that the log cannot
reconstruct, and a guess written into the archive is worse than a gap that is visible.

---

## Rules

- Raw is always the origin — never compile content that hasn't been saved to `Raw/` first
- Never modify, rewrite or delete a `Raw/` source file — archiving moves it, and that is the
  only movement permitted
- `_compiled.log` is append-only and is the sole authority on what has been compiled
- `_archive/` is a derived view of the log — rebuild it from the log, never the log from it
- `_changelog.md` is updated on every compile run that creates or updates an article
- Prefer updating an existing article over creating a new one unless the concept is genuinely distinct

## Never

- Never scan `_archive/` for uncompiled work — the inbox is the top level of `Raw/` only
- Never archive a failed item; it stays in the inbox so the retry can find it
- Never move a file before its `_compiled.log` line is written
- Never delete anything from `_archive/` to reclaim space — it is the provenance chain for
  every claim in the Wiki
- Never re-file an archived item on a guess when its log line is missing — report it instead
- Never archive a source twice, and never treat a second `compiled` line as a second file
- Never re-date or move an archived source on re-compile — it was filed once, on first compile
- Never date a backlink from today's date when the source is already archived; look the month up
- Never report a parenthetical log note as a missing source — no file was ever expected
- Never write a backlink to a top-level `Raw/` path for an item that is about to be archived

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No scope flag and no candidate spaces | Default silently to the top-level `Raw/` and proceed. |
| Content not yet in `Raw/` | Save it to `Raw/` first — never compile unsaved content. |
| Item is feedback content | Route to `customer-feedback.md` / `stakeholder-feedback.md` — don't create a concept article. |
| Concept spans 2+ systems | It belongs in the top-level `Wiki/`. |
| A single item fails to compile | Log `failed: [reason]`, leave it in the inbox, and continue — never stop mid-batch. |
| Same item fails twice | Flag it in the summary for human review. |
| `_archive/YYYY-MM/` does not exist | Create it on first use — never scaffold empty month folders ahead of time. |
| File logged as `compiled` but still at the top level | Interrupted run — move it to its derived archive path and carry on. |
| File under `_archive/` with no `compiled` line | Report it; never delete it and never re-file it on a guess. |
| Logged as `compiled` but the file is gone | Report a broken provenance link — the Wiki backlink is dead and only the human can decide what replaces it. |
| One source with several `compiled` lines | One file, one move, filed under the earliest compile month. |
| Source needs compiling into a further article | Use `--recompile [filename]` — the inbox scan cannot reach an archived file. |
| `--recompile` names a file with no `compiled` line | Refuse — it is not archived. Run plain `/ingest` instead. |
| Article sits in a sub-category `Wiki/` | Count the levels to the owning `Raw/` — the backlink is never a fixed `../`. |
| Item logged `failed:` only | Still pending — the scan picks it up, because only a `compiled` line marks an item done. |
| Log line names a parenthetical note, not a file | Skip it — the compile had no source file by design. |
