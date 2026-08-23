#!/usr/bin/env bash
# Publishes dist/forge-standalone to the standalone skills repository.
#
# Rebuilds from source, mirrors the output into a working clone, and stops with the
# change staged. It never pushes on its own -- pass --push only after reading the diff.
set -euo pipefail

REMOTE="${FORGE_STANDALONE_REMOTE:-git@github.com:glensanders-gdev/skills.git}"
BRANCH="${FORGE_STANDALONE_BRANCH:-main}"
FORGE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$FORGE_ROOT/dist/forge-standalone"
WORK="${FORGE_STANDALONE_WORKTREE:-$FORGE_ROOT/.standalone-sync}"

do_push=0
[ "${1:-}" = "--push" ] && do_push=1

command -v pwsh >/dev/null || { echo "pwsh is required to rebuild" >&2; exit 1; }
command -v rsync >/dev/null || { echo "rsync is required" >&2; exit 1; }

echo "==> Rebuilding standalone distribution"
pwsh -NoProfile -File "$FORGE_ROOT/tools/build-forge-standalone.ps1" -Strict

if [ -n "$(git -C "$FORGE_ROOT" status --porcelain -- dist/forge-standalone)" ]; then
    echo "Forge's own dist/forge-standalone is uncommitted. Commit it first so the" >&2
    echo "published tree and its source of truth land in the same state." >&2
    exit 1
fi

echo "==> Preparing clone at $WORK"
if [ -d "$WORK/.git" ]; then
    git -C "$WORK" fetch origin
    git -C "$WORK" checkout -B "$BRANCH" "origin/$BRANCH" 2>/dev/null \
        || git -C "$WORK" checkout -B "$BRANCH"
else
    rm -rf "$WORK"
    git clone "$REMOTE" "$WORK" 2>/dev/null || { mkdir -p "$WORK"; git -C "$WORK" init -q; git -C "$WORK" remote add origin "$REMOTE"; }
    git -C "$WORK" checkout -B "$BRANCH" 2>/dev/null || true
fi

echo "==> Mirroring distribution"
# --delete so a skill dropped from the shipped set disappears upstream too.
rsync -a --delete --exclude '.git' "$DIST/" "$WORK/"

FORGE_VERSION="$(python3 -c "import json,sys; print(json.load(open('$FORGE_ROOT/global/.claude/skills/manifest.json'))['forge_version'])")"
FORGE_SHA="$(git -C "$FORGE_ROOT" rev-parse --short HEAD)"

git -C "$WORK" add -A
if git -C "$WORK" diff --cached --quiet; then
    echo "==> Already up to date. Nothing to publish."
    exit 0
fi

echo
echo "==> Staged for $REMOTE ($BRANCH)"
git -C "$WORK" diff --cached --stat | tail -20
echo

if [ "$do_push" -ne 1 ]; then
    echo "Nothing pushed. Review the diff above, then re-run with --push."
    echo "  git -C $WORK diff --cached"
    exit 0
fi

git -C "$WORK" commit -q -m "Sync standalone skills from Forge $FORGE_VERSION ($FORGE_SHA)"
git -C "$WORK" push -u origin "$BRANCH"
echo "==> Published to $REMOTE ($BRANCH)"
