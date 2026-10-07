#!/usr/bin/env bash
# Installs these skills into ~/.claude/skills/, the rules they cite into ~/.claude/rules/, and the
# standards they read on demand into ~/.claude/standards/.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skills_dst="${HOME}/.claude/skills"
rules_dst="${HOME}/.claude/rules"
standards_dst="${HOME}/.claude/standards"

mkdir -p "$skills_dst" "$rules_dst" "$standards_dst"

installed=0
for dir in "$here"/skills/*/; do
    name="$(basename "$dir")"
    if [ -e "$skills_dst/$name" ] && [ ! -d "$skills_dst/$name" ]; then
        echo "skip $name — ~/.claude/skills/$name exists and is not a directory" >&2
        continue
    fi
    rm -rf "${skills_dst:?}/$name"
    cp -R "$dir" "$skills_dst/$name"
    # The single-file copy is for pasting into a chat assistant. An installed skill never reads it.
    rm -f "$skills_dst/$name/$name-standalone.md"
    installed=$((installed + 1))
done

for dir in "$here"/rules/*/; do
    name="$(basename "$dir")"
    rm -rf "${rules_dst:?}/$name"
    cp -R "$dir" "$rules_dst/$name"
done

# Single rule files: the path-scoped pointer that names the requirements standards.
for file in "$here"/rules/*.md; do
    [ -f "$file" ] || continue
    cp "$file" "$rules_dst/$(basename "$file")"
done

for dir in "$here"/standards/*/; do
    [ -d "$dir" ] || continue
    name="$(basename "$dir")"
    rm -rf "${standards_dst:?}/$name"
    cp -R "$dir" "$standards_dst/$name"
done

echo "Installed $installed skills to $skills_dst"
echo "Installed rules to $rules_dst"
echo "Installed standards to $standards_dst"

# Earlier releases installed the requirements standards into ~/.claude/rules/requirements/, where
# Claude Code loads every file into every session. Report it; never delete it.
if [ -d "$rules_dst/requirements" ]; then
    echo ""
    echo "Note: $rules_dst/requirements/ is from an earlier install. Those standards now install"
    echo "to $standards_dst/requirements/, and the old copy still loads into every Claude Code"
    echo "session. Once you have checked it holds nothing of your own, remove it with:"
    echo "  rm -rf \"$rules_dst/requirements\""
    echo ""
fi
echo "Restart your Claude Code session to pick them up."