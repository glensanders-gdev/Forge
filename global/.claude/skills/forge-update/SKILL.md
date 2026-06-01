---
name: forge-update
category: framework
description: Pull the latest Forge framework from GitHub. Since Forge v3.6.0, ~/.claude/skills/, commands/, and rules/ are junctions/symlinks — git pull is all that's needed. Use when user runs /forge-update, wants to sync Forge to the latest version, or asks to update Forge skills.
---

# Forge Update

Pull the latest Forge framework from `https://github.com/glensanders-gdev/Forge`.

Since Forge v3.6.0, `~/.claude/skills/`, `~/.claude/commands/`, and `~/.claude/rules/` are junctions/symlinks pointing directly into `~/forge/global/.claude/`. A `git pull` updates all framework files instantly — no copy step, no `update.sh` needed.

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
     Check ~/forge and re-run /forge-update.
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
   Run /forge-install to migrate to the junction-based model, then re-run /forge-update.
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
  ~/.claude/skills/, commands/, rules/ updated via junction — effective immediately.
```

If the CHANGELOG entry for the new version mentions `CLAUDE.md` or `AGENTS.md` changes:
```
ℹ️ This release updated CLAUDE.md/AGENTS.md — run /forge-init to regenerate them.
```

Otherwise:
```
⚠️ Start a new Claude Code session to load any new skills.
```

## Rules

- Never pull without confirmation from Step 5
- Never modify the Forge remote or force-push
- If junctions are not in place, redirect to `/forge-install` — do not fall back to copy mode
- On `git pull` failure: show full stderr verbatim; do not retry silently
