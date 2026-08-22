# Reserved Names

Names Claude Code already claims. A Forge skill given one of these names is **shadowed** — the
vendor's command runs and the skill never loads, with no error to explain the absence.

Cited by `/write-a-skill` (authoring-time check) and `/skill-health` (portfolio audit). One copy,
two readers — per PRINCIPLE 6, neither restates it.

---

## Verification Stamp

| | |
|---|---|
| **Last verified** | 2026-08-22 |
| **Claude Code version** | **Not determined** — see below |
| **Verified by** | Session-environment inspection (bundled skills) + recall (slash commands) |
| **Staleness threshold** | `Forge staleness warning (days)` in `preferences.md` (default 30) |

The version could not be captured: `claude` is not on `PATH` on this machine (the desktop app is
`/Applications/Claude.app`), so `claude --version` returns nothing. **The next refresh must fill
this in** — an undated list is a guess wearing a table.

---

## Why This List Is Hand-Maintained

There is no API, file, or command that emits Claude Code's reserved names. The vendor namespace
grows between releases, and it grows silently. This list is therefore **stale by construction** —
the stamp above exists so a reader knows how much to trust it, not to imply it is current.

Two consequences, both deliberate:

- A name absent from this list is **not proven free**. It is unchecked.
- A name present here may since have been withdrawn. The block is overridable for that reason.

---

## Refresh Procedure

Run this whenever `/skill-health` flags the stamp as stale, before a batch of new skills, or after
a Claude Code upgrade.

1. **Capture the version.** Run `claude --version` in a terminal where the CLI is installed, or
   read it from the app's status panel. Record it in the stamp — never leave it blank twice.
2. **Enumerate slash commands.** In an interactive `claude` terminal session, type `/` and read the
   completion list, or run `/help`. Both render the built-ins the current version ships.
3. **Enumerate bundled skills.** In any session, read the available-skills listing. Entries with a
   `plugin:skill` prefix are namespaced and **do not** collide; only bare names do.
4. **Diff against this file.** Add new names, and move withdrawn ones to Withdrawn with the date.
   Never delete a row outright — a name that stops being reserved may return.
5. **Re-run the collision check.** `/skill-health` compares the refreshed list against
   `manifest.json` and reports any skill that has become shadowed since the last audit.
6. **Update the stamp** — date, version, and how it was verified.

---

## Reserved — Bundled Skills

Observed unnamespaced in a live session on the verification date. A Forge skill of the same name
is shadowed.

| Name | Note |
|---|---|
| `artifact-capabilities` | |
| `artifact-design` | |
| `artifact-diagramming` | |
| `claude-api` | |
| `code-review` | The reason `/review` became `diff-review` rather than `code-review` (v3.25.0) |
| `dataviz` | |
| `design` | |
| `fewer-permission-prompts` | |
| `init` | Also a built-in slash command |
| `keybindings-help` | |
| `loop` | |
| `run` | |
| `schedule` | |
| `security-review` | Forge uses `security-assessment` — see Deliberately Avoided |
| `simplify` | |
| `update-config` | |

Plugin-namespaced skills (`anthropic-skills:approve`, `anthropic-skills:build`, …) carry a prefix
and **never** collide with a bare Forge name. Do not add them here.

---

## Reserved — Built-in Slash Commands

**Confirmed** rows appeared in the session environment on the verification date. **Recalled** rows
come from model knowledge and are the ones step 2 of the refresh exists to check — treat a
`Recalled` row as a strong prompt to verify, not as proof.

| Name | Source |
|---|---|
| `artifacts` | Confirmed |
| `clear` | Confirmed |
| `code-review` | Confirmed |
| `config` | Confirmed |
| `continue` | Confirmed — the v3.25.0 collision |
| `doctor` | Confirmed |
| `fast` | Confirmed |
| `help` | Confirmed |
| `hooks` | Confirmed |
| `permissions` | Confirmed |
| `review` | Confirmed — the v3.25.0 collision |
| `skill-doctor` | Confirmed |
| `ultrareview` | Confirmed — deprecated alias of `/code-review ultra` |
| `workflows` | Confirmed |
| `add-dir` | Recalled |
| `agents` | Recalled |
| `bug` | Recalled |
| `compact` | Recalled |
| `context` | Recalled |
| `cost` | Recalled |
| `export` | Recalled |
| `ide` | Recalled |
| `install-github-app` | Recalled |
| `install-slack-app` | Recalled |
| `login` | Recalled |
| `logout` | Recalled |
| `mcp` | Recalled |
| `memory` | Recalled |
| `model` | Recalled |
| `output-style` | Recalled |
| `plugin` | Recalled |
| `pr-comments` | Recalled |
| `privacy-settings` | Recalled |
| `release-notes` | Recalled |
| `resume` | Recalled |
| `rewind` | Recalled |
| `sandbox` | Recalled |
| `status` | Recalled |
| `statusline` | Recalled |
| `terminal-setup` | Recalled |
| `todos` | Recalled |
| `upgrade` | Recalled |
| `usage` | Recalled |
| `vim` | Recalled |

---

## At Risk

Not reserved today. Generic enough that the vendor plausibly claims them next, and each is an
existing Forge skill — a collision here costs a major version and breaks every reference.

| Forge skill | Why it is exposed |
|---|---|
| `build` | Generic verb, and the obvious name for a vendor build command |
| `deploy` | Same shape as `build` |
| `publish` | Already a verb the artifact tooling uses in its prose |
| `research` | Generic, and adjacent to features the vendor ships |
| `commands` | Describes the vendor's own surface, not Forge's |
| `learn` | Short generic verb with no Forge-specific signal |
| `teach` | Short generic verb with no Forge-specific signal |

One name per row, always — `/skill-health` scans the first column, and a cell holding two
names drops the second silently.

Renaming pre-emptively is **not** the recommendation — churn is its own cost, and the At Risk list
is a watch list, not a work list. Check it at each refresh.

---

## Deliberately Avoided

Collisions Forge already steers around. Recorded so a later tidy-up does not walk back into one.

| Forge name | Avoided name | Why |
|---|---|---|
| `diff-review` | `code-review`, `review` | Both reserved. Names the pinned diff it reviews (v3.25.0) |
| `pickup` | `continue` | Reserved. Pairs with `/handoff` (v3.25.0) |
| `security-assessment` | `security-review` | Bundled skill name. The `*-review` family stops short of this one on purpose |
| `forge-init` | `init` | Reserved as both a built-in and a bundled skill |
| `context-health` | `context` | Near-miss only — distinct names, no collision. Keep the suffix |

---

## Withdrawn

Names once reserved that the vendor has since released. Kept because a withdrawal can reverse.

_None recorded._

---

## Rules

- Treat absence from this file as **unchecked**, never as cleared.
- Record how each name was sourced — `Confirmed` and `Recalled` carry different weight and the
  distinction is the point.
- Move a withdrawn name to Withdrawn with its date; never delete a row.
- Never add a plugin-namespaced skill (`plugin:skill`) — the prefix makes collision impossible.
- Fill the version in the stamp at every refresh. A stamp with a date and no version records when
  someone looked, not what they looked at.
