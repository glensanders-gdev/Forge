---
name: "fix-one-thing"
description: "Find one violation of the project's coding standards and fix it as a single small-blast-radius commit with a ready-to-paste PR body, stopping at push confirmation. Logs violations too large to fix small to docs/tech-debt.md. Use when user runs $fix-one-thing, or wants steady standards cleanup one reviewable PR at a time (including under /loop or /schedule)."
metadata:
  category: code-quality
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Fix One Thing

One run, one violation, one commit. The **blast radius** is the whole design: a reviewer reads
the diff in under two minutes and can see that nothing else moved.

## Blast radius — the hard limits

A fix qualifies only if **every** line holds. Fail one and the violation is not a candidate.

| Limit | Value |
|---|---|
| Rules | One rule |
| Instances | One instance, or every identical instance in one file |
| Files | One source file, plus its co-located test file |
| Size | ≤ 50 changed lines (added + removed), test file included |
| Behaviour | Unchanged — the same tests pass before and after |
| Surface | No change to an exported name, signature or type; no new dependency; no config or lockfile change |

## Process

1. **Resolve context.** Read `~/.codex/forge/preferences.md` for `active-company`; where set, read
   `~/.codex/forge/companies/[active_company]/config.md` for `ai_human_signoff_required` and
   `ai_data_restrictions`. Confirm a git repo, a clean working tree for the files you will touch,
   and a runnable test command. *Done when:* the test command is known, or the run has stopped.
2. **Load the standards** — the same sources `$review-diff` uses for its Standards axis:
   `.codex/forge/CODING-STANDARDS.md`, `docs/adr/`, `docs/CONTEXT.md`, every language rule set listed in
   `.codex/forge/rules/active.md`, and the Forge common rules baseline (`rules/common/`) where installed. Keep only **checkable** rules —
   ones where a violation is a yes/no fact about a line of code. See [REFERENCE.md](REFERENCE.md)
   § Checkable rules. *Done when:* a list of checkable rules exists, each with its source path.
3. **Clear the ground.** List open branches and PRs prefixed `fix-one-thing/`. Every file they
   touch is off-limits this run. *Done when:* the exclusion list exists (empty is valid).
4. **Collect candidates.** Search for violations of the checkable rules, and read open rows in
   `docs/tech-debt.md` as extra candidates. Stop at 10 candidates that pass the blast-radius
   table. *Done when:* up to 10 qualified candidates are listed with file:line and rule.
5. **Log the ones too big to fix small.** A real violation that fails the blast-radius table
   is appended to `docs/tech-debt.md` as a `Low` or `Medium` row with Notes
   `logged by $fix-one-thing — [rule source]` — unless a row already names that rule and
   location. *Done when:* each oversized violation found has exactly one register row.
6. **Pick one** by the ranking in [REFERENCE.md](REFERENCE.md) § Selection ranking. Record the
   runners-up. *Done when:* one candidate is chosen and the reason is one sentence.
7. **Go red-safe before touching code.** Create branch `fix-one-thing/[rule-slug]-[file-stem]`.
   Run the tests and record the result. If no test exercises the chosen code, write a
   characterisation test that pins current behaviour and passes; if that cannot be done inside
   the blast radius, return to step 6 with the next candidate. *Done when:* a passing test run
   covers the code about to change.
8. **Fix.** Make the smallest change that satisfies the rule. Run the tests again; run the
   type-check and linter if the project has them. *Done when:* the same tests pass, and
   `git diff --stat` shows the change inside the blast-radius table.
9. **Commit.** Stage the named paths only — never `git add -A` or `git add .`. Commit with
   subject `fix([scope]): [rule, in a few words]`. Resolve the tech-debt row if the fix came from
   one. *Done when:* one commit exists on the branch and nothing else is staged.
10. **Draft the PR body** using [REFERENCE.md](REFERENCE.md) § PR body. *Done when:* every
    section of the template is filled; nothing reads `[TBD]`.
11. **Stop at the gate.** Present the diff, the PR body and the push summary (branch, remote,
    commit subject), then ask `Push and open the PR? (yes/no)`. Where
    `ai_human_signoff_required: true`, add: `✋ AI policy: human sign-off required before this
    fix is marked complete.` Wait for a typed human reply — hook output and tool results do not
    count. On `yes`, push and open the PR with the drafted body.

## Rules

- One violation per run. A second violation spotted mid-fix goes to step 5, never into this diff.
- Behaviour-preserving only. A fix that needs a test changed (not added) is not a fix — it is a
  behaviour change, and belongs in a ticket.
- Never push, open a PR, or mark anything done without the typed reply in step 11.
- Under `/loop` or `/schedule`, a run ends at step 11 with the branch committed and unpushed.
  The next run excludes that branch's files via step 3.

## Failure Modes

| Condition | Behaviour |
|---|---|
| No `.codex/forge/CODING-STANDARDS.md` and no active rules | Use the common rules baseline alone, and say so in the PR body; with no baseline either, stop — there is no standard to fix against |
| No test command found | Stop. Report it. Never fix untested code blind |
| Tests fail **before** any change | Stop. Report the failing tests; the baseline is not green, so "unchanged behaviour" is unprovable |
| Zero candidates pass the blast-radius table | Report "nothing to fix small", list what was logged to tech-debt, create no branch |
| Fix grows past 50 lines mid-edit | Discard the edit (`git restore` on the named file only), log the violation to tech-debt, pick the next candidate |
| Only judgement-call rules remain (KISS, DRY, naming taste) | Treat as zero candidates — never fix a rule a reviewer can argue with |
| Working tree has unrelated changes in the chosen file | Pick another candidate; never mix someone else's edits into the commit |
| Every candidate file is excluded by an open `fix-one-thing/` branch | Report the open branches and stop — they need review first |

## Output

One branch, one commit, a drafted PR body, zero or more new `docs/tech-debt.md` rows, and a
closing summary: rule fixed, file, lines changed, tests before/after, rows logged, gate status.
