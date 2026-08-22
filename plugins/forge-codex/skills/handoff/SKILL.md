---
name: "handoff"
description: "Compact the current session into a structured handoff so the next session can continue without re-reading the conversation. Writes one handoff per stream of work to docs/handoffs/[stream].md and keeps the register at docs/HANDOFF.md. References artifacts by path rather than reproducing content. Suggests skills for the next session. Use $handoff for any planned pause — same-day resume, passing to another agent, or handing to a colleague. Use $debrief for a thorough end-of-day close that updates kanban, DEVLOG, and backlog."
metadata:
  category: session
  version: 2.0.0
  origin: Adapted from Matt Pocock (handoff / github.com/mattpocock/skills)
  argument_hint: "[stream-slug] What will the next session focus on?"
  disable_model_invocation: true
---

# Handoff

Compact the current conversation into a clean handoff so the next session — whether a fresh agent
instance or a human picking up the work — can continue without replaying the conversation history.

A project runs several **streams** of work at once. Each stream keeps its own handoff at
`docs/handoffs/<slug>.md`; `docs/HANDOFF.md` is the register that lists them. The file layout,
register and stream-file schemas, resolution rules, conflict guard, lifecycle and migration are
specified once in **`~/.agents/skills/handoff/STREAMS.md`** — read it before writing anything.

**Execution mode:** `[HITL]` — **user-invoked only.** `disable-model-invocation: true` is
load-bearing, not decoration: this skill *overwrites* a stream's handoff, which `$pickup` treats
as its entry point. A model that runs handoff on its own initiative destroys that entry point, and
the loss is silent — the file still exists and still looks valid. The human decides when the
session is at a pause worth recording.

Adapted from Matt Pocock's `handoff` skill (AIHero.dev / github.com/mattpocock/skills), extended
for the Forge framework's session and pipeline conventions.

---

## Rules

- **Resolve the stream before writing.** Follow the resolution table in `STREAMS.md`. With more
  than one stream Active and no slug given, stop and ask — never infer the stream from what the
  conversation was about.
- **One stream per invocation.** `$handoff` writes one stream file and updates one register row.
  It never sweeps every stream — that is `$debrief`.
- **Reference, don't duplicate.** Do not reproduce content already captured in PRDs, ADRs, kanban
  tickets, DEVLOG entries, testplans, or other Forge artifacts. Reference them by path instead.
- **The register carries no content.** `docs/HANDOFF.md` holds one pointer row per stream.
- **Tailored.** If the user provides a focus argument (e.g. `$handoff ord-pack "next session:
  reconcile the trees"`), use it to shape what the handoff prioritises.
- **Suggest skills.** At the end, suggest which Forge skills the next session should use first.
- **Never carry secrets across the handoff.** Stream files and the register are tracked workspace
  files — anything written to them is persisted and committed. Reference where a value lives (env
  var, secrets manager, ticket) rather than the value itself.
- **`$handoff` vs `$debrief` vs `$save-state`:** `$handoff` is for any planned pause on one stream.
  `$debrief` is the end-of-day full close — it also updates kanban, DEVLOG, the backlog, and sweeps
  the register. `$save-state` is for emergencies when the context limit is imminent.

---

## Process

1. **Read the register** — `docs/HANDOFF.md`. If it is a legacy single-document handoff, or absent,
   follow the migration procedure in `STREAMS.md` before going further.

2. **Resolve the stream** — per the resolution table in `STREAMS.md`. Record the stream file's
   `Last updated` value at this point; the conflict guard in step 5 compares against it.

3. **Read current state** — scan `docs/kanban.md`, the most recent `docs/DEVLOG.md` entry, and any
   active `docs/prd/active/` document relevant to *this stream*. Other streams' artifacts are not
   this handoff's concern.

4. **Identify the focus** — if the user supplied one, tailor the handoff to it. If not, infer the
   most likely next focus from this stream's current state.

5. **Write `docs/handoffs/<slug>.md`** — overwrite using the stream-file template in `STREAMS.md`,
   after applying the conflict guard. If the file changed underneath this session, write the
   `.conflict-*` sibling instead and stop for the human.

6. **Update the register row** — edit this stream's row in `docs/HANDOFF.md` only: `Status`,
   `Updated`, `Next action` (≤ 100 characters), `Touches`. Never rewrite the whole file. If another
   Active stream lists the same entry under `Touches`, mark the cell `⚠️` and say so in the output.

7. **Optionally archive** — with `--archive`, also write a timestamped copy to
   `docs/handoffs/archive/YYYY-MM-DD-HH-MM-<slug>.md`. With `--close`, archive the stream, drop its
   register row, and report the archive path.

8. **Report** — name the stream written, the register row updated, and any collision or conflict.

9. **Instinct prompt** — end with:

```
💡 Did anything this session produce a pattern worth capturing?
   Run learn to capture it before it's forgotten.
```

This is a suggestion only — never mandatory.

---

## Suggested Skills Logic

Base the skill suggestions on the resolved stream's pipeline position — not the project's.

| Current state | Suggest |
|--------------|---------|
| PRD written, no testplan | `$testplan` then `$estimate` |
| Testplan done, no build | `$start-sprint` then `$build` |
| Build in progress | `$build` (resume) |
| Build complete, no QA | `$qa-plan` then `$check-pii` |
| QA complete | `$approve` |
| Feature approved, no next PRD | `$grill-with-docs` or `$idea` |
| Known issues flagged | `$diagnose` |
| Scope has changed | `$check-scope` then `$estimate` |
| Buffer window active | `$build` with `BUILD-FIXES` only |

Always suggest `$standup` if the next session is starting fresh (first action of a new day or after
a multi-day gap).

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| More than one Active stream, no slug given | Stop. List the Active streams numbered and ask. Never infer from the conversation — a wrong guess overwrites another stream's entry point. |
| Slug given that matches no row | Confirm before creating it. An unconfirmed typo forks one stream into two, and neither is complete. |
| Stream file changed since this session read it | Another session wrote it. Write `docs/handoffs/<slug>.conflict-YYYY-MM-DD-HHMM.md`, leave the original untouched, report both paths. Never merge automatically. |
| Legacy single-document `docs/HANDOFF.md` found | Migrate per `STREAMS.md`, confirming the slug, then proceed. Idempotent — never re-migrate. |
| `docs/kanban.md` missing | Write the handoff from conversation context only. Note "kanban not found." |
| No active PRD for this stream | Note "No active PRD — next session should run $grill-with-docs or $write-prd." |
| Argument provided but vague | Use it as directional context, not a precise instruction. |
| `docs/handoffs/` or `archive/` doesn't exist | Create it silently before writing. |
| Register over 400 tokens | Report it — streams are being left open that should be closed. Never trim the register by dropping a row that has no archive. |
| Session surfaced a secret or PII value | Never write it into a stream file or the register — reference its location (env var, secrets manager, ticket) and redact the value. Both files are tracked and get committed, so this rule is the only control standing between a session secret and the remote. |
| Tempted to run `$handoff` unprompted — session looks like it's ending, context looks tight | Don't. The write overwrites a stream's entry point silently. Say the session looks like a pause point and let the human call it. For imminent context exhaustion the human runs `$save-state`. |
