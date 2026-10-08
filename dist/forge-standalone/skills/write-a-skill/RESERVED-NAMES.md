# Reserved Names

Names Claude Code already claims. A skill given one of these names is **shadowed** — the
vendor's command runs and the skill never loads, with no error to explain the absence.

Cited by `/write-a-skill` at authoring time.

---

## Verification Stamp

| | |
|---|---|
| **Last verified** | 2026-10-09 |
| **Claude Code version** | 2.1.293 |
| **Verified by** | The vendor command reference, `code.claude.com/docs/en/commands` (all 119 rows and 17 aliases), and this session's available-skills listing |
| **Staleness threshold** | 30 days |

The version was read from the binary this session ran on, because `claude` was not on `PATH`. The
interactive `/` menu was not read. The reference covers the same set, including the commands the
menu hides until their full name is typed, such as `/heapdump`. A command only some accounts can
see may still be missing from both.

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

Run this whenever the stamp is older than the staleness threshold, before a batch of new skills,
or after a Claude Code upgrade.

1. **Capture the version.** Run `claude --version` in a terminal where the CLI is installed, or
   read it from the app's status panel. Record it in the stamp — never leave it blank twice.
2. **Enumerate slash commands.** In an interactive `claude` terminal session, type `/` and read the
   completion list, or run `/help`. Both render the built-ins the current version ships.
3. **Enumerate bundled skills.** In any session, read the available-skills listing. Entries with a
   `plugin:skill` prefix are namespaced and **do not** collide; only bare names do.
4. **Diff against this file.** Add new names, and move withdrawn ones to Withdrawn with the date.
   Never delete a row outright — a name that stops being reserved may return.
5. **Re-run the collision check.** Compare the refreshed list against every skill installed and
   report any that has become shadowed since the last audit.
6. **Update the stamp** — date, version, and how it was verified.

---

## Reserved — Bundled Skills

Bundled skills ship with Claude Code. A skill of the same name is shadowed. **Seen in** says
where each was found on the verification date: the command reference marks bundled skills, and
the session's available-skills listing shows the ones loaded for this account. 26 names.

| Name | Seen in | Note |
|---|---|---|
| `artifact-capabilities` | reference + session |  |
| `artifact-design` | session |  |
| `artifact-diagramming` | reference + session |  |
| `batch` | reference |  |
| `claude-api` | reference + session |  |
| `claude-in-chrome` | reference |  |
| `code-review` | reference + session | The reason `/review` became `review-diff` rather than `code-review` (v3.25.0) |
| `dataviz` | reference + session |  |
| `debug` | reference |  |
| `design` | reference |  |
| `design-sync` | reference |  |
| `doctor` | reference |  |
| `fewer-permission-prompts` | reference + session |  |
| `init` | reference + session | Also a built-in slash command |
| `keybindings-help` | session |  |
| `loop` | reference + session |  |
| `plugin-authoring` | reference + session |  |
| `run` | reference + session |  |
| `run-skill-generator` | reference |  |
| `schedule` | reference + session |  |
| `security-review` | reference + session | Name a security skill something else — `security-assessment` reads the same and collides with nothing |
| `simplify` | reference + session |  |
| `slides` | reference |  |
| `update-config` | reference + session |  |
| `verify` | reference |  |
| `workflow-authoring` | reference + session | Present only when dynamic workflows are enabled |

Plugin-namespaced skills (`anthropic-skills:approve`, `anthropic-skills:build`, …) carry a prefix
and **never** collide with a bare skill name. Do not add them here.

---

## Reserved — Built-in Slash Commands

Every other name in the command reference, including aliases and bundled workflows. A skill named
like an alias is shadowed exactly as one named like the command. 112 names, all sourced from
the reference on the verification date.

**Source** is `Reference` for a name in the vendor command reference, or `Recalled` for one taken
from model knowledge and not yet checked. A `Recalled` row is a prompt to verify, not proof.

| Name | Source | Note |
|---|---|---|
| `add-dir` | Reference |  |
| `advisor` | Reference |  |
| `agents` | Reference |  |
| `artifacts` | Reference |  |
| `auto-mode-setup` | Reference |  |
| `autocompact` | Reference |  |
| `autofix-pr` | Reference |  |
| `background` | Reference |  |
| `branch` | Reference |  |
| `btw` | Reference |  |
| `bug` | Reference |  |
| `cd` | Reference |  |
| `chrome` | Reference |  |
| `clear` | Reference |  |
| `color` | Reference |  |
| `compact` | Reference |  |
| `config` | Reference |  |
| `context` | Reference |  |
| `copy` | Reference |  |
| `cost` | Reference |  |
| `deep-research` | Reference | Bundled workflow |
| `design-login` | Reference |  |
| `desktop` | Reference |  |
| `diff` | Reference |  |
| `effort` | Reference |  |
| `exit` | Reference |  |
| `export` | Reference |  |
| `fast` | Reference |  |
| `feedback` | Reference |  |
| `focus` | Reference |  |
| `fork` | Reference |  |
| `goal` | Reference |  |
| `heapdump` | Reference | Hidden from the `/` menu until the full name is typed |
| `help` | Reference |  |
| `hooks` | Reference |  |
| `ide` | Reference |  |
| `import` | Reference |  |
| `insights` | Reference |  |
| `install-github-app` | Reference |  |
| `install-slack-app` | Reference |  |
| `keybindings` | Reference |  |
| `list-agents` | Reference |  |
| `login` | Reference |  |
| `logout` | Reference |  |
| `mcp` | Reference |  |
| `memory` | Reference |  |
| `mobile` | Reference |  |
| `model` | Reference |  |
| `output-style` | Reference |  |
| `passes` | Reference |  |
| `permissions` | Reference |  |
| `plan` | Reference |  |
| `plugin` | Reference |  |
| `powerup` | Reference |  |
| `pr-comments` | Reference |  |
| `privacy-settings` | Reference |  |
| `radio` | Reference |  |
| `rate-limit-options` | Reference |  |
| `recap` | Reference |  |
| `release-notes` | Reference |  |
| `reload-plugins` | Reference |  |
| `reload-skills` | Reference |  |
| `remote-control` | Reference |  |
| `remote-env` | Reference |  |
| `rename` | Reference |  |
| `resume` | Reference |  |
| `review` | Reference | Alias of `/code-review` — the v3.25.0 collision |
| `rewind` | Reference |  |
| `sandbox` | Reference |  |
| `scroll-speed` | Reference |  |
| `setup-bedrock` | Reference |  |
| `setup-vertex` | Reference |  |
| `skill-doctor` | Reference |  |
| `skills` | Reference |  |
| `stats` | Reference |  |
| `status` | Reference |  |
| `statusline` | Reference |  |
| `stickers` | Reference |  |
| `stop` | Reference |  |
| `subtask` | Reference |  |
| `tasks` | Reference |  |
| `team-onboarding` | Reference |  |
| `teleport` | Reference |  |
| `terminal-setup` | Reference |  |
| `theme` | Reference |  |
| `tui` | Reference |  |
| `ultraplan` | Reference |  |
| `ultrareview` | Reference |  |
| `upgrade` | Reference |  |
| `usage` | Reference |  |
| `usage-credits` | Reference |  |
| `vim` | Reference |  |
| `voice` | Reference |  |
| `web-setup` | Reference |  |
| `workflows` | Reference |  |
| `allowed-tools` | Reference | Alias of `/permissions` |
| `android` | Reference | Alias of `/mobile` |
| `app` | Reference | Alias of `/desktop` |
| `bg` | Reference | Alias of `/background` |
| `checkpoint` | Reference | Alias of `/rewind` |
| `checkup` | Reference | Alias of `/doctor` |
| `continue` | Reference | Alias of `/resume` — the v3.25.0 collision |
| `ios` | Reference | Alias of `/mobile` |
| `new` | Reference | Alias of `/clear` |
| `proactive` | Reference | Alias of `/loop` |
| `quit` | Reference | Alias of `/exit` |
| `rc` | Reference | Alias of `/remote-control` |
| `reset` | Reference | Alias of `/clear` |
| `routines` | Reference | Alias of `/schedule` |
| `settings` | Reference | Alias of `/config` |
| `share` | Reference | Alias of `/bug` |
| `undo` | Reference | Alias of `/rewind` |

---

## At Risk

Not reserved today. Generic enough that the vendor plausibly claims them next, and each is an
existing skill name — a collision here costs a major version and breaks every reference.

| Name | Why it is exposed |
|---|---|
| `build` | Generic verb, and the obvious name for a vendor build command |
| `deploy` | Same shape as `build` |
| `publish` | Already a verb the artifact tooling uses in its prose |
| `research` | Generic, and the vendor now ships `/deep-research` as a bundled workflow |
| `commands` | Describes the vendor's own surface rather than your own |
| `learn` | Short generic verb carrying no distinguishing signal |
| `teach` | Short generic verb carrying no distinguishing signal |
| `onboard` | The vendor now ships `/team-onboarding`. A bare `onboard` is the obvious shorter form |

One name per row, always — a scan reads the first column, and a cell holding two names drops
the second silently.

Renaming pre-emptively is **not** the recommendation — churn is its own cost, and the At Risk list
is a watch list, not a work list. Check it at each refresh.

---

## Deliberately Avoided

Collisions already steered around. Recorded so a later tidy-up does not walk back into one.

| Name used | Avoided name | Why |
|---|---|---|
| `review-diff` | `code-review`, `review` | Both reserved. Names the pinned diff it reviews |
| `pickup` | `continue` | Reserved. Pairs with `/handoff` |
| `security-assessment` | `security-review` | Bundled skill name. The `*-review` family stops short of this one on purpose |
| `context-health` | `context` | Near-miss only — distinct names, no collision. Keep the suffix |

---

## Withdrawn

Names once reserved that the vendor has since released. Kept because a withdrawal can reverse.

| Name | Withdrawn | Note |
|---|---|---|
| `todos` | 2026-10-09 | A `Recalled` row, never confirmed. Absent from the 2.1.293 command reference |

---

## Rules

- Treat absence from this file as **unchecked**, never as cleared.
- Record how each name was sourced — `Confirmed` and `Recalled` carry different weight and the
  distinction is the point.
- Move a withdrawn name to Withdrawn with its date; never delete a row.
- Never add a plugin-namespaced skill (`plugin:skill`) — the prefix makes collision impossible.
- Fill the version in the stamp at every refresh. A stamp with a date and no version records when
  someone looked, not what they looked at.
