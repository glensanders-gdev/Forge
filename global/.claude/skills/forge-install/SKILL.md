---
name: forge-install
version: 1.0.0
category: framework
description: First-time Forge installation. Clones the Forge repo and runs install.sh. Use when Forge is not yet installed on this machine — i.e. ~/.claude/skills/ is missing or empty.
---

# Forge Install

Bootstrap Forge on a new machine. Clones the repo and runs the installer.

**Repo:** `https://github.com/glensanders-gdev/Forge`
**Local clone:** `~/forge`

## Pre-check [AFK]

Check whether Forge is already installed:

```bash
ls ~/.claude/skills/manifest.json 2>/dev/null && echo "installed" || echo "not installed"
```

If already installed:
```
✓ Forge is already installed. Use /forge-update to upgrade to the latest version.
```
Stop.

## Process

### 1 — Check for existing clone [AFK]

```bash
ls ~/forge/.git 2>/dev/null && echo "exists" || echo "missing"
```

- **Missing:** clone the repo:
  ```bash
  git clone https://github.com/glensanders-gdev/Forge.git ~/forge
  ```
- **Exists with wrong remote:** warn and stop:
  ```
  ⚠️ ~/forge exists but is not the Forge repo.
     Expected remote: https://github.com/glensanders-gdev/Forge
     Check ~/forge before continuing.
  ```
- **Exists with correct remote:** pull latest:
  ```bash
  git -C ~/forge pull
  ```

### 2 — Confirm [HITL]

```
Ready to install Forge from ~/forge.
This will write to ~/.claude/skills/, ~/.claude/commands/, and related directories.

Install now? (yes/no)
```

On `no`: exit without changes.

### 3 — Install [AFK]

```bash
bash ~/forge/install.sh
```

On failure: show full stderr verbatim and stop. Do not retry silently.

### 4 — Report [AFK]

Show the output from `install.sh`. Then:

```
✓ Forge installed. Run /forge-init to generate ~/.claude/CLAUDE.md.
⚠️ Start a new Claude Code session to load the skills.
```

## Failure Modes

- `git clone` fails — network issue or repo URL changed. Show error verbatim.
- `install.sh` fails — show full stderr. User may need to check permissions on `~/.claude/`.
- `~/forge` exists with wrong remote — stop rather than overwrite; user must resolve manually.

## Rules

- Never run `install.sh` without confirmation from Step 2
- Never overwrite an existing installation silently — if `manifest.json` exists, stop and redirect to `/forge-update`
- Never modify the Forge remote or force-push
