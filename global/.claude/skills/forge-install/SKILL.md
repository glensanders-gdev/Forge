---
name: forge-install
version: 2.0.0
category: framework
description: Install or migrate Forge to the junction-based sync model. Auto-detects whether this is a fresh install, a migration from a legacy copy-based install, or already linked. Use when Forge is not yet installed, when upgrading from a copy-based install, or when setting up Forge on a new device.
---

# Forge Install

Bootstrap or migrate Forge on this device. Auto-detects which scenario applies and branches accordingly — no manual scenario selection needed.

**Repo:** `https://github.com/glensanders-gdev/Forge`
**Canonical local path:** `~/forge` (`C:\Users\{user}\forge` on Windows)

## Scenarios

| Detected State | Branch |
|---------------|--------|
| No repo, no `~/.claude/skills/` | A — Fresh install |
| Repo present, skills is junction/symlink | B — Already linked (no-op) |
| No repo, skills is real directory | C — Legacy migration |
| Repo present, skills is real directory | D — Re-link |
| No `ln` or `cmd` available (iOS) | iOS guidance |

## Pre-Check [AFK]

### 1 — Detect iOS

```bash
command -v ln >/dev/null 2>&1 || echo "no-ln"
```

If `ln` is unavailable and `cmd` is not accessible → branch to **iOS Guidance**.

### 2 — Detect scenario

```bash
ls ~/forge/.git 2>/dev/null && echo "repo-exists" || echo "no-repo"
```

```bash
# Detect junction (Windows NTFS) or symlink (Mac/Linux).
# [ -L ] returns false for NTFS junctions — must also check ReparsePoint via PowerShell.
if [ -L ~/.claude/skills ]; then
  echo "linked"
elif powershell -NoProfile -Command \
  "if ((Get-Item ([System.Environment]::GetFolderPath('UserProfile') + '\.claude\skills') \
    -Force -ErrorAction SilentlyContinue).Attributes -match 'ReparsePoint') { 'yes' }" \
  2>/dev/null | grep -q "yes"; then
  echo "linked"
elif [ -d ~/.claude/skills ]; then
  echo "real-dir"
else
  echo "missing"
fi
```

Branch on the result.

---

## Scenario A — Fresh Install [AFK → HITL]

1. Clone the repo:
   ```bash
   git clone https://github.com/glensanders-gdev/Forge.git ~/forge
   ```
2. Confirm [HITL]:
   ```
   Ready to install Forge v[X.Y.Z] from ~/forge.
   Creates junctions/symlinks in ~/.claude/ pointing to the repo.
   User data (knowledge/, instincts/, tokens/, etc.) is not affected.

   Install now? (yes/no)
   ```
3. On `yes` → `bash ~/forge/install.sh`
4. Report:
   ```
   ✓ Forge installed. Run /forge-init to generate ~/.claude/CLAUDE.md.
   ⚠️ Start a new Claude Code session to load the skills.
   ```

---

## Scenario B — Already Linked (No-Op)

```
✓ Forge is already installed and linked (v[X.Y.Z]).
  ~/.claude/skills/ → ~/forge/global/.claude/skills/
  To update: run /forge-update
```

Stop.

---

## Scenario C — Legacy Migration [HITL]

Present the plan:

```
⚠️  Legacy copy-based install detected.

~/.claude/skills/ is a real directory (edits don't reach the repo).

Migration plan:
  1. Locate or clone repo to ~/forge
  2. Remove real ~/.claude/skills/, commands/, rules/ directories
  3. Create junctions/symlinks pointing to ~/forge/global/.claude/
  4. User data (knowledge/, instincts/, tokens/, etc.) is NOT touched.

[If repo found at non-standard path]:
  Found: [path] — will move to ~/forge

Type MIGRATE to proceed, or anything else to cancel.
```

### Migration Steps [AFK]

1. **Find existing repo** — check in order:
   ```
   ~/OneDrive/Forge
   ~/Documents/Forge
   ~/Desktop/Forge
   ~/forge
   ```
   If not found, ask: "Where is your current Forge directory? (full path)"

2. **Move repo to `~/forge`** (if not already there):
   ```bash
   mv [found-path] ~/forge
   ```
   If cross-device move fails, copy then delete source:
   ```bash
   cp -r [found-path] ~/forge && rm -rf [found-path]
   ```

3. **Verify remote**:
   ```bash
   git -C ~/forge remote get-url origin
   ```
   Must be `https://github.com/glensanders-gdev/Forge`. If not → stop and warn.

4. **Run installer**:
   ```bash
   bash ~/forge/install.sh
   ```
   `install.sh` removes real dirs and creates junctions/symlinks idempotently.

5. Report:
   ```
   ✓ Migration complete.
   ✓ ~/.claude/skills/ → ~/forge/global/.claude/skills/
   ✓ User data preserved.
   ⚠️ Start a new Claude Code session to reload skills.
   ```

---

## Scenario D — Repo Exists, Not Linked [HITL]

```
Forge repo found at ~/forge but ~/.claude/skills/ is not yet linked.
Run install.sh to create junctions/symlinks? (yes/no)
```

On `yes` → `bash ~/forge/install.sh`

---

## iOS Guidance

iOS Claude Code cannot create junctions or symlinks. Skills are read from `~/.claude/` as normal; changes are local only until pushed.

```
iOS detected — junction-based sync is not available on this platform.

To contribute skill changes from iOS:
  1. Edit skills in this session (applies to ~/.claude/ locally)
  2. Ask Claude to push changes to a branch:
     "Push these skill changes to branch claude/ios-[feature-name]"
  3. On Mac or Windows, review and merge the branch to main
  4. Run /forge-update on Mac/Windows to pull the merge
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `git clone` fails | Show error verbatim. Check network. |
| `install.sh` fails | Show full stderr. Check permissions on `~/.claude/` and `~/forge`. |
| Remote URL wrong | Stop. "Resolve the remote manually before retrying." |
| Cross-device move fails | Fall back to copy + delete. Warn if source deletion fails — user must delete manually. |
| Skills junction points to wrong target | Warn with current target. Offer to re-create: `bash ~/forge/install.sh`. |

## Rules

- Never run `install.sh` without HITL confirmation
- Never touch user-owned dirs: `knowledge/`, `instincts/`, `tokens/`, `backlog/`, `ideas/`, `decisions/`, `projects/`, `preferences.md`, `CLAUDE.md`, `AGENTS.md`
- Never force-push or modify the Forge remote
- Always verify remote URL before any git operation on the repo
