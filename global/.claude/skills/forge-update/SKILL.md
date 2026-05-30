---
name: forge-update
category: framework
description: Pull the latest Forge framework from GitHub and install updated skills, commands, and framework files. Use when user runs /forge-update, wants to sync Forge to the latest version, or asks to update Forge skills.
---

# Forge Update

Pull the latest Forge framework from `https://github.com/glensanders-gdev/Forge` and install
updated skills, commands, and framework files. User data (instincts, knowledge, preferences,
backlog) is always preserved.

**Repo:** `https://github.com/glensanders-gdev/Forge`
**Local clone:** `~/forge`

## Process

### 1 — Ensure local clone [AFK]

Check `~/forge/.git` and `git -C ~/forge remote get-url origin`.

- **Missing:** `git clone https://github.com/glensanders-gdev/Forge ~/forge`
- **Wrong or missing remote:**
  ```
  ⚠️ ~/forge exists but is not the expected Forge repo.
     Expected: https://github.com/glensanders-gdev/Forge
     Check ~/forge and re-run /forge-update.
  ```
  Stop.
- **Correct:** skip to step 2

### 2 — Fetch latest [AFK]

Check how stale the local clone is before pulling:

```bash
git -C ~/forge log -1 --format="%ci"
```

If the last local commit is more than 30 days old, note it:
```
ℹ️ Local clone last updated [N] days ago — pulling now.
```

Then pull:

```bash
git -C ~/forge pull
```

On failure: show full git error verbatim and stop:
```
❌ git pull failed. Check your network or run:
   git -C ~/forge status
```

### 3 — Version check [AFK]

```bash
grep '"forge_version"' ~/.claude/skills/manifest.json | grep -o '[0-9.]*'
grep '"forge_version"' ~/forge/global/.claude/skills/manifest.json | grep -o '[0-9.]*'
```

If `~/forge/global/.claude/skills/manifest.json` is missing:
```
❌ Cannot read incoming version — ~/forge/global/.claude/skills/manifest.json not found.
   The repo structure may have changed.
```
Stop.

If versions match:
```
✓ Already on v[X.Y.Z] — nothing to install.
```
Stop.

If versions differ, verify the incoming version is tagged:

```bash
git -C ~/forge describe --tags --exact-match 2>/dev/null || echo "untagged"
```

- Tag matches `v[incoming_version]` — continue silently.
- Result is `untagged` — note it:
  ```
  ⚠️ Incoming version v[X.Y.Z] has no git tag — this may be a pre-release or work in progress.
  ```
  Continue to Step 4 regardless — do not block the update.

### 4 — Confirm [HITL]

Extract the new version's section from `~/forge/global/.claude/CHANGELOG.md` and display:

```
Current:  v[X.Y.Z]
Latest:   v[X.Y.Z]

What's new:
[changelog section for new version]

Skills and commands will be overwritten. Your data is preserved.
Update now? (yes/no)
```

On `no`: exit without changes.

### 5 — Install [AFK]

```bash
bash ~/forge/update.sh
```

On failure: show full stderr verbatim; do not retry silently.

### 6 — Reconcile README [AFK]

After installation, verify `README.md` in `~/forge` is consistent with the newly installed
`~/forge/global/.claude/skills/manifest.json`:

1. Count all skills in `manifest.json` (total keys under `"skills"`)
2. Extract the skill count stated in `README.md` (search for the "**N skills**" line in "What's Included")
3. If counts differ, update the count in `README.md`
4. Check the file structure section of `README.md` for any inline counts (e.g. "92 global skills", "92 slash commands") — update these to match
5. If any changes were made, report them:
   ```
   README.md reconciled:
   - Skill count updated: 94 → 96
   - Inline counts updated in file structure section
   ```
   If README was already current: note "README.md skill count is current." and continue.

### 7 — Report [AFK]

Show the version installed and backup path from `update.sh` output. Then append:

```
⚠️ Start a new Claude Code session to load the updated skills.
```

## Rules

- Never run `update.sh` without confirmation from Step 4
- Never skip the version check — always show current vs new before installing
- Never modify the Forge remote or force-push
- On `update.sh` failure: show full stderr verbatim; do not retry silently
