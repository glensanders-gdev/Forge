# Session Streams — the handoff register

The shared specification for multi-stream session state. Owned by `/handoff`; read by
`/pickup`, `/save-state`, `/debrief`, `/approve`,<!--forge-only--> `/end-sprint`<!--/forge-only--> and `/context-health`.
Cite this file by path — never restate its rules inside a skill (PRINCIPLE 6).

Introduced in Forge v3.24.0. Replaces the single-document `docs/HANDOFF.md`.

---

## Why streams exist

A project runs more than one thread of work at a time — a feature build, a requirements pack, a
prototype, a stakeholder document. Before v3.24.0 all of them wrote to one fixed path with
overwrite semantics, so the second handoff destroyed the first. The loss was silent: the file
still existed and still looked valid.

A **stream** is one continuous thread of work with its own next action, its own blockers, and its
own resume point. Streams are independent by construction — one stream's handoff can never
overwrite another's.

---

## File layout

| Path | Holds | Written by |
|---|---|---|
| `docs/HANDOFF.md` | The **register** — one row per open stream. Pointers only, never content. | every session writer, one row at a time |
| `docs/handoffs/<slug>.md` | The live handoff for one stream. **Authoritative.** | `/handoff`, `/save-state`, `/debrief`<!--forge-only-->, `/end-sprint`<!--/forge-only--> |
| `docs/handoffs/archive/YYYY-MM-DD-<slug>.md` | Closed or superseded streams. Never read on resume. | `/handoff --archive`, stream close, `/approve` |
| `docs/handoffs/unassigned-YYYY-MM-DD-HHMM.md` | Emergency save with no resolvable stream. | `/save-state` only |

The stream file is the source of truth. The register **restates by reference and introduces
nothing new** — the same discipline as a view table in `rules/requirements/tables.md`. A value
carried in both is edited in the stream file first, then the row is brought into line.

---

## The register — `docs/HANDOFF.md`

```markdown
# Handoffs: [Project Name]

**Last updated:** YYYY-MM-DD HH:MM
**Register version:** 2

| Stream | Title | Status | Updated | Next action | Touches |
|---|---|---|---|---|---|
| `ord-pack` | ORD standard pack v1.4 | Active | 2026-08-11 15:56 | Reconcile the two pack trees | `requirements-documents/` |
| `capacity-report` | Capacity report intake | Paused | 2026-08-04 09:20 | Draft §3 thresholds | `docs/prd/active/` |
| `junction-sync` | Forge junction sync | Blocked | 2026-07-28 17:40 | Waiting on API access | `Forge/` |
```

- **`Status`** is `Active`, `Paused`, or `Blocked`. Closed streams are archived and their row removed.
- **`Updated`** and **`Next action`** are copied from the stream file — never authored here.
- **`Next action`** is one line, ≤ 100 characters. The full version lives in the stream file.
- **`Touches`** lists the paths the stream writes. It is the collision check, not decoration.
- The whole register stays under 400 tokens. If it does not fit, streams are being left open that
  should be closed.

---

## The stream file — `docs/handoffs/<slug>.md`

```markdown
# Handoff: [Stream Title]

**Stream:** `<slug>`
**Status:** Active | Paused | Blocked
**Last updated:** YYYY-MM-DD HH:MM
**Session type:** [current session type]
**Prepared by:** /handoff[: next focus if provided]
**Touches:** [paths this stream writes]

---

## Current Ticket

**#N — [Ticket name]** `[AFK/HITL]`
Status: [In Progress / Blocked / Ready to start]
**Current phase:** [phase name] — Session N of this phase

---

## What Just Happened

[2-3 sentences maximum — what was done, decided, changed. Reference artifacts by path.]

Key artifacts updated this session:
- [path/to/file] — [one-word description of what changed]

---

## Next Action

[The single most important thing to do first in the next session, specific enough
that no other context is needed.]

---

## Context the Next Session Will Need

[Only what is NOT already in a Forge artifact. If it is in the PRD, kanban or ADR — reference it.]

---

## Open Decisions

_None_ if nothing is pending.

---

## Blockers

_None_ if nothing is blocked.

---

## Suggested Skills for Next Session

1. `/user:[skill]` — [why this is the right next step]
```

---

## Stream identity

- Slug is kebab-case, ≤ 32 characters, unique in the register, and **stable for the life of the
  stream** — the resume path depends on it not moving.
- Name it for the work, not the date: `ord-pack`, `capacity-report`, `login-flow`.
- Where a git branch maps one-to-one to the work, the branch name (minus any `claude/` prefix) is
  the default **suggestion** — never applied silently.
- A retired slug is never reused, matching the ID rules in `rules/requirements/tables.md`.
- Reserved: `archive`, and any `unassigned-*` name.

---

## Stream resolution — required before any write

| Situation | Behaviour |
|---|---|
| Slug given, matches a register row | Use it. |
| Slug given, no match | Treat as a new stream and **confirm before creating** — an unconfirmed typo silently forks a stream in two. |
| No slug, exactly one `Active` stream | Use it, and name it in the output so the human can catch a wrong assumption. |
| No slug, more than one `Active` stream | **Stop and ask.** List them numbered. |
| No slug, none Active | Ask which paused or blocked stream to resume, or offer a new one. |
| No register, legacy `HANDOFF.md` present | Migrate first (below), then resolve. |
| No register, no handoff at all | New stream — ask for a slug and title. |
| `/save-state` with nothing resolvable | Never ask. Write `unassigned-YYYY-MM-DD-HHMM.md`. |

**Never infer the stream from what the conversation happened to be about.** The write is
destructive and silent, so a wrong inference costs another stream its entry point — the same
failure the pre-2.0 single file caused, reintroduced by guesswork.

---

## Concurrent writers

Two sessions can be open on one project at the same time — two terminals, or a session and a
background agent.

- **Stream files.** Before overwriting, re-read the target's `Last updated`. If it is newer than
  the value this session saw when it resolved the stream (or newer than session start, if the file
  was never read), another writer got there first. Write
  `docs/handoffs/<slug>.conflict-YYYY-MM-DD-HHMM.md` instead, leave the original untouched, and
  report both paths. **Never merge automatically** — the human decides which is current.
- **The register.** Update the single row, never rewrite the whole file. Row-level edits from
  different streams do not collide.
- **Shared artefacts.** If two `Active` streams list the same entry under `Touches`, mark that cell
  `⚠️` and say so in the output. It is a warning to the human, never a block.

---

## Lifecycle

```
Active ──▶ Paused   (deliberately parked)
       ──▶ Blocked  (waiting on something external)
       ──▶ Closed   (archived; row removed)
```

Closing a stream moves its file to `docs/handoffs/archive/YYYY-MM-DD-<slug>.md`, drops the register
row, and reports the archive path. `/approve` closes the stream belonging to the feature it approves.

A stream `Active` with no update for more than 7 days is **stale**. `/debrief` and `/pickup`
surface it and offer Pause or Close. Neither ever closes a stream on its own.

---

## Migration from the single-file handoff

**Legacy detection:** `docs/HANDOFF.md` exists, its heading is `# Handoff:` (singular), and it has
no `| Stream |` table.

`/handoff` migrates on first run, idempotently — if a register already exists, it does nothing:

1. Propose a slug derived from the existing title; confirm it with the human.
2. Copy the body to `docs/handoffs/<slug>.md`, adding the stream header block.
3. Write the register at `docs/HANDOFF.md` with that one row.
4. Report both paths.

`/pickup` **never migrates** — it reads a legacy file exactly as it always did and notes that the
next `/handoff` will migrate it. A read path never writes.

Date-prefixed files already in `docs/handoffs/` (`YYYY-MM-DD-*-handoff.md`) are archives from the
pre-2.0 `--archive` flag. Nothing reads them; move them into `archive/` when convenient. The
register lists only what it holds a row for.

---

## Never

- Never write content into the register — it holds one pointer row per stream and nothing else.
- Never overwrite a stream file whose `Last updated` is newer than the value this session read.
- Never infer the stream from conversation topic while more than one stream is Active.
- Never reuse a retired slug.
- Never let `/save-state` stop to ask which stream — an emergency save that blocks has failed.
- Never close or delete a stream without the human saying so.
- Never carry secrets or PII into a stream file or the register — both are tracked and committed.
