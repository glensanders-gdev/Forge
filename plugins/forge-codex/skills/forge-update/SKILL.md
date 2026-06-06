---
name: "forge-update"
description: "Update the Forge for Codex plugin from its configured marketplace source and report upstream compatibility changes. Use when the user asks to update or refresh Forge."
metadata:
  category: framework
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Forge Update

Update through Codex plugin and marketplace mechanics.

## Process

1. Identify the installed Forge plugin and marketplace source.
2. Preserve local adaptations and user-owned data under `~/.codex/forge/`.
3. Refresh the marketplace or pull its source repository.
4. Compare the incoming upstream Forge manifest and commit with `references/adaptation-build.json`.
5. Re-run the adaptation builder and plugin validator when the source changed.
6. Report added, removed, changed, and compatibility-sensitive skills.
7. Ask the user to restart Codex or open a new thread.

## Rules

- Never run upstream Claude installation scripts.
- Never discard local plugin adaptations during an update.
- Never modify user-owned Forge data as part of an update.
