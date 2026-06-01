#!/usr/bin/env bash
# Forge Installer
# Usage: bash install.sh
# Or from GitHub: bash <(curl -fsSL https://raw.githubusercontent.com/glensanders-gdev/Forge/main/install.sh)
#
# Creates junctions (Windows) or symlinks (Mac/Linux) from ~/.claude/ into the repo's
# global/.claude/ so that ~/.claude/skills/, ~/.claude/commands/, and ~/.claude/rules/
# ARE the repo — no copy step, no drift possible.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_SRC="$SCRIPT_DIR/global/.claude"
FORGE_VERSION=$(grep '"forge_version"' "$GLOBAL_SRC/skills/manifest.json" 2>/dev/null | grep -o '[0-9][0-9.]*' | head -1)
FORGE_VERSION="${FORGE_VERSION:-unknown}"
REPO_URL="https://github.com/glensanders-gdev/Forge"
CLAUDE_DIR="$HOME/.claude"

# ── colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        Forge v${FORGE_VERSION} Installer          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# ── detect platform ───────────────────────────────────────────────────────────
detect_platform() {
  case "$OSTYPE" in
    msys*|cygwin*|win32*) echo "windows" ;;
    darwin*)               echo "mac" ;;
    linux*)                echo "linux" ;;
    *)
      local u
      u=$(uname -s 2>/dev/null | tr '[:upper:]' '[:lower:]')
      case "$u" in
        mingw*|cygwin*) echo "windows" ;;
        darwin)         echo "mac" ;;
        linux)          echo "linux" ;;
        *)              echo "unknown" ;;
      esac
      ;;
  esac
}

PLATFORM=$(detect_platform)
if [ "$PLATFORM" = "unknown" ]; then
  echo -e "${YELLOW}⚠  Could not detect platform. Defaulting to symlink mode.${NC}"
  PLATFORM="linux"
fi
echo -e "Platform: ${BLUE}${PLATFORM}${NC}"
echo ""

# ── check ~/.claude exists ────────────────────────────────────────────────────
if [ ! -d "$CLAUDE_DIR" ]; then
  echo -e "${YELLOW}⚠  ~/.claude not found — Claude Code may not be installed.${NC}"
  echo "   Forge will still install. See https://docs.anthropic.com/en/docs/claude-code"
  echo ""
  mkdir -p "$CLAUDE_DIR"
fi

# ── create user-owned dirs (never junctioned) ─────────────────────────────────
for dir in knowledge/company knowledge/systems sprints pi ideas/active ideas/archived tokens instincts projects; do
  mkdir -p "$CLAUDE_DIR/$dir"
done

# ── is_linked: returns 0 if path is already a junction or symlink ─────────────
is_linked() {
  local tgt="$1"
  if [ -L "$tgt" ]; then return 0; fi
  if [ "$PLATFORM" = "windows" ] && [ -d "$tgt" ]; then
    local win_tgt result
    win_tgt=$(cygpath -w "$tgt" 2>/dev/null || echo "$tgt")
    result=$(powershell -NoProfile -Command "
      \$item = Get-Item '$win_tgt' -Force -ErrorAction SilentlyContinue
      if (\$item -and (\$item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) { 'yes' } else { 'no' }
    " 2>/dev/null)
    [ "$result" = "yes" ] && return 0
  fi
  return 1
}

# ── link_dir: junction (Windows) or symlink (Mac/Linux) ──────────────────────
link_dir() {
  local src="$1" tgt="$2"
  local name
  name=$(basename "$tgt")

  if is_linked "$tgt"; then
    echo -e "  ${YELLOW}↩  Already linked: $name${NC}"
    return
  fi

  if [ "$PLATFORM" = "windows" ]; then
    local win_tgt win_src
    win_tgt=$(cygpath -w "$tgt" 2>/dev/null || echo "$tgt")
    win_src=$(cygpath -w "$src" 2>/dev/null || echo "$src")
    # PowerShell handles removal and junction creation reliably on Windows
    local ps_out
    ps_out=$(powershell -NoProfile -Command "
      try {
        if (Test-Path '$win_tgt') { Remove-Item -Recurse -Force '$win_tgt' }
        New-Item -ItemType Junction -Path '$win_tgt' -Target '$win_src' | Out-Null
        Write-Output 'OK'
      } catch {
        Write-Error \$_.Exception.Message
        exit 1
      }
    " 2>&1)
    if [ "$ps_out" != "OK" ]; then
      echo -e "  ${RED}✗  Failed to create junction for $name: $ps_out${NC}"
      return 1
    fi
  else
    [ -d "$tgt" ] && rm -rf "$tgt"
    ln -s "$src" "$tgt"
  fi
  echo -e "  ${GREEN}✓  Linked: $name${NC}"
}

# ── link_file: hard link (Windows) or symlink (Mac/Linux) ────────────────────
# Windows file symlinks require elevation; hard links work without it and stay
# in sync as long as both paths are on the same volume.
link_file() {
  local src="$1" tgt="$2"
  local name
  name=$(basename "$tgt")

  [ -L "$tgt" ] && { echo -e "  ${YELLOW}↩  Already linked: $name${NC}"; return; }
  [ -f "$tgt" ] && rm -f "$tgt"

  if [ "$PLATFORM" = "windows" ]; then
    local win_tgt win_src
    win_tgt=$(cygpath -w "$tgt" 2>/dev/null || echo "$tgt")
    win_src=$(cygpath -w "$src" 2>/dev/null || echo "$src")
    # Try hard link via PowerShell; fall back to copy if it fails (cross-volume)
    powershell -NoProfile -Command "
      try {
        New-Item -ItemType HardLink -Path '$win_tgt' -Target '$win_src' | Out-Null
      } catch {
        Copy-Item '$win_src' '$win_tgt' -Force
      }
    " 2>/dev/null || cp "$src" "$tgt"
    echo -e "  ${GREEN}✓  Linked: $name${NC}"
  else
    ln -s "$src" "$tgt"
    echo -e "  ${GREEN}✓  Linked: $name${NC}"
  fi
}

# ── link framework dirs ───────────────────────────────────────────────────────
echo "Linking framework directories..."
link_dir "$GLOBAL_SRC/skills"   "$CLAUDE_DIR/skills"
link_dir "$GLOBAL_SRC/commands" "$CLAUDE_DIR/commands"
link_dir "$GLOBAL_SRC/rules"    "$CLAUDE_DIR/rules"
echo ""

# ── link framework files ──────────────────────────────────────────────────────
echo "Linking framework files..."
link_file "$GLOBAL_SRC/CHANGELOG.md"       "$CLAUDE_DIR/CHANGELOG.md"
link_file "$GLOBAL_SRC/PRINCIPLES.md"      "$CLAUDE_DIR/PRINCIPLES.md"
link_file "$GLOBAL_SRC/SOUL.md"            "$CLAUDE_DIR/SOUL.md"
link_file "$GLOBAL_SRC/forge-sequence.mmd" "$CLAUDE_DIR/forge-sequence.mmd"
echo ""

# ── version stamp ─────────────────────────────────────────────────────────────
INSTALL_COMMIT=$(git -C "$SCRIPT_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
TODAY=$(date +%Y-%m-%d)
cat > "$CLAUDE_DIR/forge-version" << EOF
version: ${FORGE_VERSION}
installed: ${TODAY}
updated: ${TODAY}
commit: ${INSTALL_COMMIT}
repo: ${SCRIPT_DIR}
platform: ${PLATFORM}
EOF
echo -e "${GREEN}✓  Version stamp: v${FORGE_VERSION} (commit ${INSTALL_COMMIT})${NC}"

# ── preferences ───────────────────────────────────────────────────────────────
if [ ! -f "$CLAUDE_DIR/preferences.md" ]; then
  cat > "$CLAUDE_DIR/preferences.md" << 'EOF'
# Forge Preferences
# Edit these to match your setup. Uncomment and set the values you want.

## Identity
# username: Your Name

## Sprint & Capacity
# sprint-capacity-points: 20
# sprint-capacity-tokens: 400000

## Knowledge Freshness
# staleness-warning-days: 90

## Context Health
# context-health-last-run: (set automatically by /context-health)

## Security Assessment
# security-assessment-last-run: (set automatically by /security-assessment)

## Company (set by /company-add — do not edit manually)
# active_company:
EOF
  echo -e "${GREEN}✓  preferences.md created${NC}"
else
  echo -e "${YELLOW}ℹ  preferences.md already exists — not overwriting.${NC}"
fi

# ── done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Forge v${FORGE_VERSION} installed ✓          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo "How sync works:"
echo "  ~/.claude/skills/, commands/, rules/ are now linked to:"
echo "  $SCRIPT_DIR/global/.claude/"
echo ""
echo "  Editing a skill in ~/.claude/ edits the repo directly."
echo "  To update: cd $SCRIPT_DIR && git pull  (or run /forge-update)"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.claude/preferences.md — set your username and sprint capacity"
echo "  2. Open Claude Code in a project directory"
echo "  3. Run: /user:forge-init  to generate ~/.claude/CLAUDE.md"
echo "  4. Run: /user:commands    to see all available commands"
echo ""
echo "Full docs: $REPO_URL"
echo ""
