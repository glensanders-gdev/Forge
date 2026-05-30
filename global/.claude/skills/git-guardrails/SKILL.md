---
name: git-guardrails
category: code-quality
description: Set up a PreToolUse hook that hard-blocks dangerous git commands (push, reset --hard, clean -f, branch -D, checkout ., restore .) before Claude can execute them. Complements git-safety.md (AI soft rules) with OS-level enforcement. Use when user wants to prevent Claude from running destructive git operations even if the AI ignores its own rules.
origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)
---

# Git Guardrails

Sets up a `PreToolUse` hook that intercepts and hard-blocks dangerous git commands before
Claude executes them. This is the **hard enforcement layer** for git safety — it complements
the soft AI-level rules in `rules/common/git-safety.md` by enforcing them at the Claude Code
hook level, where they cannot be forgotten or overridden mid-session.

---

## What Gets Blocked

- `git push` (all variants including `--force`, `--force-with-lease`)
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

When a blocked command is attempted, Claude receives an authority denial rather than
execution proceeding. The human can still run any of these commands directly in their
own terminal.

---

## Usage

```
/git-guardrails              ← guided setup (prompts for project or global scope)
/git-guardrails --project    ← install for this project only
/git-guardrails --global     ← install system-wide (all projects)
/git-guardrails --verify     ← test that the hook is active and blocking correctly
/git-guardrails --remove     ← remove the hook (project or global, prompted)
```

---

## Process

### Phase 1 [AFK] — Pre-flight

1. Check for existing `PreToolUse` hook configuration in both:
   - `.claude/settings.json` (project scope)
   - `~/.claude/settings.json` (global scope)
   Note if already configured so we can merge rather than overwrite.

2. Detect shell environment:
   - **Windows:** check for bash at `/usr/bin/bash` or via `where bash`. The hook script
     requires bash (Git Bash or WSL). Note this dependency explicitly if on Windows.
   - **macOS/Linux:** proceed without caveat.

3. Announce findings before continuing:
   ```
   Git Guardrails — Pre-flight

   Project hooks (.claude/settings.json):  [none / PreToolUse already present]
   Global hooks  (~/.claude/settings.json): [none / PreToolUse already present]
   Shell:         [bash path detected / Git Bash required — see note below]

   Note (Windows only): The hook script requires bash. Ensure Git for Windows is
   installed. If bash is not available, the hook will silently fail to execute.
   ```

---

### Phase 2 [HITL] — Scope Selection

Unless `--project` or `--global` was passed, ask:

```
Install git guardrails for:
  [1] This project only  → .claude/settings.json
  [2] All projects       → ~/.claude/settings.json

Choice (1 or 2):
```

Wait for explicit user response. Do not proceed without it.

---

### Phase 3 [AFK] — Deploy Hook Script

Based on scope:

| Scope | Script destination |
|-------|--------------------|
| Project | `.claude/hooks/block-dangerous-git.sh` |
| Global | `~/.claude/hooks/block-dangerous-git.sh` |

Steps:
1. Create the `hooks/` directory if it does not exist.
2. Write the hook script from `scripts/block-dangerous-git.sh` (in this skill directory)
   to the target path. If a script already exists at the target, show a diff and ask:
   **overwrite / keep / cancel** — do not overwrite silently.
3. **macOS/Linux only:** run `chmod +x <script-path>` to make it executable.
4. **Windows:** skip `chmod`. Note that Git Bash executes `.sh` files directly; no
   permission change is needed.

---

### Phase 4 [AFK] — Configure Settings

Add the hook to the appropriate `settings.json`. **Always merge — never overwrite the
full file or replace an existing `hooks` block.**

Procedure:
1. Read the existing settings file (or start with `{}`).
2. If `hooks.PreToolUse` exists, append to the array. Check for a duplicate
   `block-dangerous-git` entry first — skip if already present.
3. Write the updated file.
4. Show the user a diff of changes made.

**Project** (`.claude/settings.json`):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global** (`~/.claude/settings.json`):
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

---

### Phase 5 [HITL] — Verify

Run a live test through the deployed script:

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
```

Report the result:

**Pass:**
```
✅ Hook verified — dangerous git commands are blocked.

   Test command: git push origin main
   Result:       exit 2 — [BLOCKED] Claude does not have authority to run this command.
```

**Fail (exit 0 — not blocked):**
```
❌ Verification failed — command was not blocked (exit 0).

   Possible causes:
   - Settings file was not saved correctly (check <path>/settings.json)
   - Script path in settings does not match the deployed script location
   - Claude Code session needs to be restarted for hooks to take effect

   Script path configured: <configured-path>
   Script exists at path:  [yes / no]
```

Ask the user to confirm the result looks correct before closing.

---

## Customization

To add or remove blocked patterns, edit the `BLOCKED_PATTERNS` array in the deployed
script directly. Changes take effect immediately — no restart required.

Default blocked patterns (matched as regex substrings against the full command string):

```bash
BLOCKED_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -f"
  "git clean -fd"
  "git branch -D"
  "git checkout \."
  "git restore \."
)
```

---

## Forge Integration Points

| Skill / File | Relationship |
|---|---|
| `rules/common/git-safety.md` | Soft layer: AI-level ask-before-running rules. This skill adds hard enforcement on top — both layers should be active. |
| `/deploy` | Deploy's push step is human-confirmed via HITL gate before execution — not blocked by this hook, by design. |
| `/rollback` | Same as `/deploy` — rollback pushes are human-approved before running. |
| `update-config` | For manual edits to `settings.json` when the hook config needs adjusting post-install. |

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `PreToolUse` already present in settings | Merge the new hook entry into the existing array — never overwrite |
| Script already exists at target path | Show diff, ask: overwrite / keep / cancel — do not overwrite silently |
| `chmod +x` fails | Warn — script may not execute on macOS/Linux. Guide user to run `chmod +x <path>` manually |
| Windows without bash | Note the dependency clearly. Suggest Git for Windows or WSL. Offer to proceed anyway if user confirms bash is available |
| Verification exits 0 (not blocked) | Hook not active — check settings file, check script path, remind user to restart Claude Code session |
| `--remove` requested | Remove only the `block-dangerous-git` hook entry from `PreToolUse` array; leave other hooks intact. Delete the script file. Show diff before writing. |
| No `CLAUDE_PROJECT_DIR` on Windows | Flag — the project-scope hook command relies on this env var being set by Claude Code. Confirm it is available or suggest global scope instead. |

---

## Rules

- Never overwrite an existing `hooks.PreToolUse` array — always merge into it
- Never proceed past scope selection (Phase 2) without an explicit human response
- Never block patterns outside the configured list — no silent scope creep
- Never modify project source files — this skill only touches `.claude/` directories and settings files
- Never skip verification (Phase 5) — always run the test and report the result
- These guardrails complement `git-safety.md`, they do not replace it — both layers should remain active
- Never claim the hook is working without a successful verification exit code 2

---

## Attribution

Adapted from Matt Pocock (AIHero.dev / [github.com/mattpocock/skills](https://github.com/mattpocock/skills/blob/main/skills/misc/git-guardrails-claude-code/SKILL.md))
