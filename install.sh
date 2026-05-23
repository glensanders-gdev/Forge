#!/usr/bin/env bash
# Forge Installer
# Usage: bash install.sh
# Or from GitHub: bash <(curl -fsSL https://raw.githubusercontent.com/glensanders-gdev/Forge/main/install.sh)

set -e

FORGE_VERSION="2.5.4"
REPO_URL="https://github.com/glensanders-gdev/Forge"
GLOBAL_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/global"
CLAUDE_DIR="$HOME/.claude"

# ── colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Forge v${FORGE_VERSION} Installer          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# ── check claude code ────────────────────────────────────────────────────────
if [ ! -d "$HOME/.claude" ] && [ ! -f "$HOME/.claude/settings.json" ] 2>/dev/null; then
  echo -e "${YELLOW}⚠  ~/.claude not found — Claude Code may not be installed.${NC}"
  echo "   Forge will still install but you need Claude Code to use it."
  echo "   See https://docs.anthropic.com/en/docs/claude-code"
  echo ""
fi

# ── backup existing ──────────────────────────────────────────────────────────
if [ -d "$CLAUDE_DIR/skills" ]; then
  echo -e "${YELLOW}ℹ  Existing ~/.claude/skills found.${NC}"
  read -p "   Back up existing skills before installing? [Y/n] " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    BACKUP="$CLAUDE_DIR/skills.backup.$(date +%Y%m%d-%H%M%S)"
    cp -r "$CLAUDE_DIR/skills" "$BACKUP"
    echo -e "${GREEN}✓  Backed up to $BACKUP${NC}"
  fi
fi

# ── install global skills ────────────────────────────────────────────────────
echo ""
echo "Installing global skills and commands..."

# Create directory structure
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/commands"
mkdir -p "$CLAUDE_DIR/knowledge/company"
mkdir -p "$CLAUDE_DIR/knowledge/systems"
mkdir -p "$CLAUDE_DIR/sprints"
mkdir -p "$CLAUDE_DIR/pi"
mkdir -p "$CLAUDE_DIR/ideas/active"
mkdir -p "$CLAUDE_DIR/ideas/archived"
mkdir -p "$CLAUDE_DIR/tokens"
mkdir -p "$CLAUDE_DIR/instincts"

# Copy global .claude contents
cp -r "$GLOBAL_SRC/.claude/." "$CLAUDE_DIR/"

echo -e "${GREEN}✓  Skills installed: $(ls "$CLAUDE_DIR/skills" | grep -v manifest | wc -l | tr -d ' ') skills${NC}"
echo -e "${GREEN}✓  Commands installed: $(ls "$CLAUDE_DIR/commands" | wc -l | tr -d ' ') commands${NC}"

# ── project template ─────────────────────────────────────────────────────────
echo ""
echo "Project template available at: $(pwd)/project-template"
echo ""
echo -e "${BLUE}To scaffold a new project:${NC}"
echo "  cp -r $(pwd)/project-template/. /path/to/your/project/"
echo ""
echo -e "${BLUE}Or let Forge do it:${NC}"
echo "  Open Claude Code in any directory and run: /user:create-project"

# ── preferences ──────────────────────────────────────────────────────────────
if [ ! -f "$CLAUDE_DIR/preferences.md" ] || ! grep -q "sprint-capacity-points" "$CLAUDE_DIR/preferences.md" 2>/dev/null; then
  echo ""
  echo -e "${YELLOW}ℹ  preferences.md already exists — not overwriting.${NC}"
  echo "   Review $CLAUDE_DIR/preferences.md and update to match your setup."
fi

# ── done ─────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Forge v${FORGE_VERSION} installed ✓          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.claude/preferences.md — set your username, platform, sprint capacity"
echo "  2. Open Claude Code in a project directory"
echo "  3. Run: /user:commands  to see all available commands"
echo "  4. Run: /user:idea      to start your first feature"
echo ""
echo "Full docs: $REPO_URL"
echo "Quickstart: $(pwd)/QUICKSTART.md"
echo ""
