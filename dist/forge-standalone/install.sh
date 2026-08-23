#!/usr/bin/env bash
# Installs these skills into ~/.claude/skills/ (and the rules they cite into ~/.claude/rules/).
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_dst="${HOME}/.claude/skills"
rules_dst="${HOME}/.claude/rules"

mkdir -p "$skills_dst" "$rules_dst"

installed=0
for dir in "$here"/skills/*/; do
    name="$(basename "$dir")"
    if [ -e "$skills_dst/$name" ] && [ ! -d "$skills_dst/$name" ]; then
        echo "skip $name — ~/.claude/skills/$name exists and is not a directory" >&2
        continue
    fi
    rm -rf "${skills_dst:?}/$name"
    cp -R "$dir" "$skills_dst/$name"
    installed=$((installed + 1))
done

for dir in "$here"/rules/*/; do
    name="$(basename "$dir")"
    rm -rf "${rules_dst:?}/$name"
    cp -R "$dir" "$rules_dst/$name"
done

echo "Installed $installed skills to $skills_dst"
echo "Installed rules to $rules_dst"
echo "Restart your Claude Code session to pick them up."