#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
COMMAND=""
if command -v jq >/dev/null 2>&1; then
  COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')"
elif command -v python3 >/dev/null 2>&1; then
  COMMAND="$(printf '%s' "$INPUT" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("tool_input", {}).get("command", ""))' 2>/dev/null || true)"
fi

[ -z "$COMMAND" ] && exit 0
if printf '%s' "$COMMAND" | grep -qE 'git[[:space:]]+(push|reset[[:space:]]+--hard|clean[[:space:]]+-f[d]?|branch[[:space:]]+-D|checkout[[:space:]]+\.|restore[[:space:]]+\.)'; then
  python3 -c 'import json,sys; print(json.dumps({"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Destructive git command blocked by Forge: "+sys.argv[1]}}))' "$COMMAND"
fi
