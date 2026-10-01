---
name: update-forge
category: framework
standalone: false
description: Pull the latest Forge framework from GitHub. ~/.claude/skills/, commands/, rules/ and standards/ are junctions/symlinks, so git pull updates them; a folder a release adds is linked once. Use when user runs /update-forge, wants to sync Forge to the latest version, or asks to update Forge skills.
---

# Forge Update

Pull the latest Forge framework from `https://github.com/glensanders-gdev/Forge`.

Since Forge v3.6.0, `~/.claude/skills/`, `~/.claude/commands/`, and `~/.claude/rules/` are junctions/symlinks pointing directly into `~/forge/global/.claude/`; `~/.claude/standards/` joined them in v4.15.2. A `git pull` updates all framework files instantly — no copy step, no `update.sh` needed. The one thing a pull cannot do is create the link for a folder a release adds, which step 6a does.

**Repo:** `https://github.com/glensanders-gdev/Forge`
**Local clone:** `~/forge`

## Process

### 1 — Ensure local clone [AFK]

```bash
git -C ~/forge remote get-url origin 2>/dev/null || echo "missing"
```

- **Missing** → `git clone https://github.com/glensanders-gdev/Forge.git ~/forge`
- **Wrong remote**:
  ```
  ⚠️ ~/forge exists but is not the expected Forge repo.
     Expected: https://github.com/glensanders-gdev/Forge
     Check ~/forge and re-run /update-forge.
  ```
  Stop.
- **Correct** → proceed.

### 2 — Check junctions [AFK]

```bash
[ -L ~/.claude/skills ] && echo "linked" || echo "not-linked"
```

If `not-linked`:
```
⚠️ ~/.claude/skills/ is not a junction/symlink — this install predates v3.6.0.
   Run /install-forge to migrate to the junction-based model, then re-run /update-forge.
```
Stop.

### 3 — Check staleness [AFK]

```bash
git -C ~/forge log -1 --format="%ci"
```

Read `staleness-warning-days` from `~/.claude/preferences.md` (default 30). If older than threshold:
```
ℹ️ Local clone last updated [N] days ago.
```

### 4 — Fetch and compare versions [AFK]

```bash
git -C ~/forge fetch origin main --quiet
```

Compare installed vs incoming `forge_version` from `manifest.json`. If equal:
```
✓ Already on v[X.Y.Z] — nothing to update.
```
Stop.

### 5 — Confirm [HITL]

Show installed vs latest version and the relevant CHANGELOG section:

```
Current:  v[X.Y.Z]
Latest:   v[X.Y.Z]

What's new:
[changelog section for new version]

Type YES to update, or anything else to cancel.
```

### 6 — Pull [AFK]

```bash
git -C ~/forge pull origin main
```

On failure: show full git error verbatim and stop.

### 6a — Link folders a release adds [AFK]

A pull updates every linked folder but cannot create the link for a new one. v4.15.2 added
`~/.claude/standards/`, which the requirement skills read by path — without the link they cite a
path that does not exist.

```bash
for d in skills commands rules standards; do [ -e ~/.claude/$d ] || echo "missing: $d"; done
```

Link each missing folder the way `install.sh` does — a symlink on Mac/Linux, a junction on Windows:

```bash
ln -s ~/forge/global/.claude/<dir> ~/.claude/<dir>
```

```bash
powershell -NoProfile -Command 'New-Item -ItemType Junction -Path "$env:USERPROFILE\.claude\<dir>" -Target "$env:USERPROFILE\forge\global\.claude\<dir>"'
```

### 7 — Update version stamp [AFK]

Rewrite `~/.claude/forge-version` preserving the original `installed:` date:

```
version: [NEW_VERSION]
installed: [original installed date]
updated: [TODAY]
commit: [new HEAD short SHA]
```

### 8 — Report [AFK]

```
✓ Forge updated to v[NEW_VERSION]
  ~/.claude/skills/, commands/, rules/, standards/ updated via junction — effective immediately.
  [✓ Linked ~/.claude/<dir>/ — one line per folder step 6a linked]
```

If the CHANGELOG entry for the new version mentions `CLAUDE.md` or `AGENTS.md` changes:
```
ℹ️ This release updated CLAUDE.md/AGENTS.md — run /init-forge to regenerate them.
```

Otherwise:
```
⚠️ Start a new Claude Code session to load any new skills.
```

## Rules

- Never pull without confirmation from Step 5
- Never modify the Forge remote or force-push
- If junctions are not in place, redirect to `/install-forge` — do not fall back to copy mode
- Never copy a framework folder into `~/.claude/` in place of a missing link — a copy stops tracking the repo
- On `git pull` failure: show full stderr verbatim; do not retry silently

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `~/forge` clone missing | Clone it from the expected remote before pulling. |
| `~/forge` points at the wrong remote | Stop — surface the mismatch; never modify the remote. |
| `~/.claude/skills/` is not a junction | Redirect to `/install-forge` — never fall back to copy mode. |
| Installed version already equals latest | Report "already on vX.Y.Z" and stop. |
| `git pull` fails | Show full stderr verbatim and stop — never retry silently. |
| A framework folder is unlinked after the pull | Link it in step 6a. If the link fails, show the error verbatim and tell the user to run `bash ~/forge/install.sh`. |
| CHANGELOG mentions `CLAUDE.md`/`AGENTS.md` changes | Prompt to run `/init-forge`; otherwise prompt to restart the session. |
