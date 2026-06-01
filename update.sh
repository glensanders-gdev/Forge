#!/usr/bin/env bash
# DEPRECATED — this script is no longer needed.
#
# Since Forge v3.6.0, ~/.claude/skills/, commands/, and rules/ are junctions/symlinks
# pointing directly into the repo. Updating Forge is simply:
#
#   cd ~/forge && git pull
#
# Or use the /forge-update skill in Claude Code, which handles this automatically.
#
# This file is retained for backwards compatibility only.
# It will continue to work for legacy copy-based installs but will not be
# called by install.sh or /forge-update going forward.
#
# ──────────────────────────────────────────────────────────────────────────────
# Forge Updater (legacy) — pull latest skills from GitHub
# Usage: bash update.sh
# Or: cd ~/forge && git pull && bash update.sh

set -e

FORGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}Forge Updater${NC}"
echo ""

# Pull latest from GitHub if this is a git repo
if [ -d "$FORGE_DIR/.git" ]; then
  echo "Pulling latest from GitHub..."
  git -C "$FORGE_DIR" pull
  echo ""
fi

# Get new version from manifest
NEW_VERSION=$(grep '"forge_version"' "$FORGE_DIR/global/.claude/skills/manifest.json" | grep -o '[0-9.]*')

# Backup current skills
BACKUP="$CLAUDE_DIR/skills.backup.$(date +%Y%m%d-%H%M%S)"
echo "Backing up current skills to $BACKUP..."
cp -r "$CLAUDE_DIR/skills" "$BACKUP"
cp -r "$CLAUDE_DIR/commands" "$BACKUP-commands" 2>/dev/null || true

# Install updated skills (preserve user data files)
echo "Installing updated skills..."
cp -r "$FORGE_DIR/global/.claude/skills/." "$CLAUDE_DIR/skills/"
cp -r "$FORGE_DIR/global/.claude/commands/." "$CLAUDE_DIR/commands/"

# Update framework files (not user data)
for file in PRINCIPLES.md SOUL.md CHANGELOG.md forge-sequence.mmd; do
  if [ -f "$FORGE_DIR/global/.claude/$file" ]; then
    cp "$FORGE_DIR/global/.claude/$file" "$CLAUDE_DIR/$file"
  fi
done

# Update decisions/ directory (ADRs for Forge design decisions)
if [ -d "$FORGE_DIR/global/.claude/decisions" ]; then
  mkdir -p "$CLAUDE_DIR/decisions"
  cp -r "$FORGE_DIR/global/.claude/decisions/." "$CLAUDE_DIR/decisions/"
fi

echo ""
echo -e "${GREEN}✓  Forge updated to v${NEW_VERSION}${NC}"
echo -e "${GREEN}✓  Previous skills backed up to $BACKUP${NC}"

# Write version stamp — preserve original installed: date, update updated: to today
INSTALL_COMMIT=$(git -C "$FORGE_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
ORIG_INSTALLED=$(grep '^installed:' "$CLAUDE_DIR/forge-version" 2>/dev/null | awk '{print $2}')
if [ -z "$ORIG_INSTALLED" ]; then
  ORIG_INSTALLED=$(date +%Y-%m-%d)
fi
cat > "$CLAUDE_DIR/forge-version" << EOF
version: ${NEW_VERSION}
installed: ${ORIG_INSTALLED}
updated: $(date +%Y-%m-%d)
commit: ${INSTALL_COMMIT}
EOF
echo -e "${GREEN}✓  Version stamp updated: v${NEW_VERSION} (commit ${INSTALL_COMMIT})${NC}"
echo ""
echo "User data preserved:"
echo "  ~/.claude/registry.md          (ID registry)"
echo "  ~/.claude/tokens/ledger.md     (token ledger)"
echo "  ~/.claude/instincts/           (your instincts)"
echo "  ~/.claude/knowledge/           (your knowledge base)"
echo "  ~/.claude/preferences.md       (your preferences)"
echo "  ~/.claude/priorities.md        (your priorities)"
echo "  ~/.claude/backlog.md           (your backlog)"
echo ""
