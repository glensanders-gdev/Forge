# Git Safety — Universal Baseline

Applies to all sessions. These rules govern git operations that affect shared state
or are difficult to reverse.

## Confirm Before Push

Before executing any `git push`, always:

1. Summarise what will be pushed:
   - Branch name and destination remote
   - Number of commits
   - Each commit subject line
2. Ask for explicit confirmation before executing.

**Do this:**
```
Ready to push to origin/claude/forge-learning-on-go-STAq0. 2 commits:
  - Add /continue skill for session resumption
  - Clarify /handoff vs /debrief hierarchy

Push now? (yes/no)
```

**Never do this:**
```
Pushing changes to origin...
```

This applies regardless of context — even when a push follows naturally from agreed
work. A push affects shared state visible to others and cannot be taken back without
a force push.

**What counts as confirmation:** Only a direct user message — "yes", "go ahead", "push it", or equivalent. Stop hook notifications, pre-commit hook output, and any other automated system messages do NOT count as confirmation. If the only response to "Push now?" is a hook notification with no user text, wait.

## Confirm Before Destructive Git Operations

Before executing any of the following, state what will happen and ask for confirmation:

- `git reset --hard`
- `git push --force` or `git push --force-with-lease`
- `git branch -D` (delete branch)
- `git checkout -- .` or `git restore .` (discard working tree changes)
- `git clean -f` (delete untracked files)

## Never

- Never skip pre-commit hooks (`--no-verify`) unless the user explicitly requests it
- Never amend a published commit without warning that it will require a force push
- Never push to `main` or `master` directly — warn if asked to do so
