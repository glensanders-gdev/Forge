#!/usr/bin/env bash
# Publishes dist/forge-standalone to the standalone skills repository.
#
# Rebuilds from source, mirrors the output into a working clone, and stops with the
# change staged. It never pushes on its own -- pass --push only after reading the diff.
#
#   (no flag)  rebuild, mirror, show the staged diff, stop. Exit 0 either way.
#   --push     the above, then commit and push. The only mode that writes upstream.
#   --check    the guard. Exit 1 when the published tree is behind, 2 when the
#              published tree could not be read, 0 only when it is current.
#
# .github/workflows/standalone-publish.yml runs --push on every merge to main, so a
# release publishes itself. Running this by hand is for publishing out of band, or for
# checking the published tree without waiting for CI.
set -euo pipefail

REMOTE="${FORGE_STANDALONE_REMOTE:-git@github.com:glensanders-gdev/skills.git}"
BRANCH="${FORGE_STANDALONE_BRANCH:-main}"
FORGE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST="$FORGE_ROOT/dist/forge-standalone"
WORK="${FORGE_STANDALONE_WORKTREE:-$FORGE_ROOT/.standalone-sync}"

do_push=0
check_only=0
case "${1:-}" in
    --push)  do_push=1 ;;
    --check) check_only=1 ;;
    "")      ;;
    *)       echo "usage: $(basename "$0") [--push | --check]" >&2; exit 2 ;;
esac

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
published_read=0
if [ -d "$WORK/.git" ]; then
    if git -C "$WORK" fetch origin; then published_read=1; fi
    git -C "$WORK" checkout -B "$BRANCH" "origin/$BRANCH" 2>/dev/null \
        || git -C "$WORK" checkout -B "$BRANCH"
else
    rm -rf "$WORK"
    if git clone "$REMOTE" "$WORK" 2>/dev/null; then
        published_read=1
    else
        # No published repository yet -- bootstrap an empty one so a first release has
        # somewhere to land.
        mkdir -p "$WORK"
        git -C "$WORK" init -q
        git -C "$WORK" remote add origin "$REMOTE"
    fi
    git -C "$WORK" checkout -B "$BRANCH" 2>/dev/null || true
fi

# A failed fetch, a failed clone, or a branch with no upstream all leave the mirror
# comparing against something that is not the published tree. Interactively that is
# visible in the diff a human is about to read. Under --check nobody reads it, and an
# empty local tree would report the whole distribution as drift -- so the guard refuses
# to run instead. An unread remote is not the same answer as a current one.
if [ "$check_only" -eq 1 ]; then
    if [ "$published_read" -ne 1 ] \
       || ! git -C "$WORK" rev-parse --verify -q "refs/remotes/origin/$BRANCH" >/dev/null; then
        echo "Could not read $REMOTE ($BRANCH). The publish guard did not run -- this is" >&2
        echo "not the same as the published tree being current." >&2
        exit 2
    fi
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

if [ "$check_only" -eq 1 ]; then
    echo "The published tree at $REMOTE ($BRANCH) is behind this repository." >&2
    echo "Publish it:" >&2
    echo "  ./tools/sync-standalone-skills.sh          # review the diff" >&2
    echo "  ./tools/sync-standalone-skills.sh --push   # publish" >&2
    exit 1
fi

if [ "$do_push" -ne 1 ]; then
    echo "Nothing pushed. Review the diff above, then re-run with --push."
    echo "  git -C $WORK diff --cached"
    exit 0
fi

git -C "$WORK" commit -q -m "Release $FORGE_VERSION" -m "Build $FORGE_SHA"
git -C "$WORK" push -u origin "$BRANCH"
echo "==> Published to $REMOTE ($BRANCH)"
