#!/usr/bin/env bash
# block-dangerous-git.sh — Codex PreToolUse hook
# Blocks dangerous git commands before Codex executes them.
#
# Origin: Adapted from Matt Pocock (AIHero.dev / github.com/mattpocock/skills)
#
# To customize, edit BLOCKED_PATTERNS below.
# Each pattern is matched as a regex substring against the full command string.

set -euo pipefail

INPUT=$(cat)

# Extract command string from the JSON payload Codex sends to hooks.
# Tries jq first (faster), falls back to Python 3, then to basic grep.
if command -v jq &>/dev/null; then
  COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')
elif command -v python3 &>/dev/null; then
  COMMAND=$(printf '%s' "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except Exception:
    print('')
")
else
  # Last resort — fragile but functional for simple cases
  COMMAND=$(printf '%s' "$INPUT" | grep -o '"command":"[^"]*"' | head -1 | cut -d'"' -f4)
fi

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Edit this list to add or remove blocked patterns
BLOCKED_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -f"
  "git clean -fd"
  "git branch -D"
  "git checkout \."
  "git restore \."
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if printf '%s' "$COMMAND" | grep -qE "$pattern"; then
    printf '[BLOCKED] Codex does not have authority to run: %s\n' "$COMMAND" >&2
    printf 'To run this command, execute it directly in your terminal.\n' >&2
    exit 2
  fi
done

exit 0
