---
name: approve
category: pipeline
version: 1.0.0
description: Close a completed feature by archiving the PRD, sealing the DEVLOG session, and optionally pushing coding standards. Use when human runs /approve after QA is passed.
---

# Approve

The `/approve` command signals that QA has passed and the feature is complete. This closes the current work cycle cleanly and prepares the project for the next feature.

## Trigger

Human runs `/approve` explicitly. Never run this automatically.

## Process

1. **Confirmation gate** — before doing anything else, present:

```
⚠️  You are about to approve and archive this feature.

Feature:  [PRD name — read from docs/prd/active/]
Tickets:  [list of Done tickets from kanban.md]
Action:   PRD moved to archived — AI will not reference it again

This cannot be undone within the current workflow.

Type APPROVE to confirm, or anything else to cancel.
```

If the response is not exactly `APPROVE`, respond: "Approval cancelled. No changes made." and stop.

2. **QA report gate** — check `docs/tests/results/` for a file matching `[feature-name]-*.md`:
   - If no report exists → hard stop: "No QA report found for this feature. Run `/user:qa-report` to record results before approving."
   - If the report's approve gate status is `Blocked` → hard stop: "QA report has unresolved P1 failures. Resolve or formally waive all P1 failures in the QA report, then re-run `/user:qa-report` before approving." List the blocking TC IDs from the report.
   - If the report's approve gate status is `Clear` → proceed.

3. **PII check gate** — read `docs/pii-report.md`:
   - If no report exists → warn: "No PII report found. Run `/user:pii-check` before approving. Or type OVERRIDE [reason] to proceed without a PII check."
   - If unresolved findings exist → warn with finding list and require `OVERRIDE [reason]`
   - If all findings resolved → proceed
   - Record any override in the PII report's Approve Override Log

5. **Archive the PRD**
   - Move `docs/prd/active/[feature-name].md` to `docs/prd/archived/[feature-name].md`
   - Add a header to the archived file:
     ```markdown
     > **Archived:** YYYY-MM-DD — QA passed. Do not reference this document in future sessions.
     ```

6. **Seal the DEVLOG session**
   - Append to `docs/DEVLOG.md`:
     ```markdown
     ## Session YYYY-MM-DD — APPROVED ✓

     **Feature:** [Feature name]
     **Tickets Completed:** #N, #N, ...
     **QA:** Passed
     **PRD:** Archived
     **Status:** Approved
     ```

7. **Update kanban.md**
   - Move all remaining tickets to Done.
   - Add a closing note:
     ```markdown
     <!-- Feature approved YYYY-MM-DD. Board archived. -->
     ```

8. **Reset HANDOFF.md**
   - Overwrite `docs/HANDOFF.md` with a clean state:
     ```markdown
     # Handoff: [Project Name]

     **Last updated:** YYYY-MM-DD HH:MM
     **Session type:** QA

     ## Current Ticket
     Feature [feature-name] approved. Board cleared.

     ## Next Action
     Ready to start next feature — run /user:front-gate (non-technical intake), /user:idea (developer), or /user:grill-with-docs (planning phase for existing project).

     ## Open Decisions
     None.

     ## Blockers
     None.
     ```

9. **Optionally push coding standards**
   - Suggest: "Would you like to capture any new coding patterns that emerged from this feature? Run `/user:push-standards` — it will extract and document them in `.claude/CODING-STANDARDS.md`."

10. **Suggest README update**
   - Prompt: "Want me to update the README to reflect this feature? Run `/user:update-readme`."

11. **Suggest PIR**
   - Prompt: "Consider running a Post Implementation Review: `/user:pir [PROJ-NNN]`. Did this feature achieve its stated goals?"

12. **Update idea diagram** — if an idea in `~/.claude/ideas/active/` is linked to this project:
   - Read `~/.claude/ideas/active/[idea-name]/diagram.mmd`
   - Update to reflect the final delivered state
   - Save as `diagram.mmd` (current) and `diagram-v4-final.mmd` (snapshot)
   - Update diagram version history in `idea.md`
   - Update idea status to `Delivered — YYYY-MM-DD`

13. **Roll up token record to global ledger** — read `docs/tokens/[feature-name].md`, sum all phases, append to `~/.claude/tokens/ledger.md`:

```markdown
### [Feature Name] — [Project] — YYYY-MM-DD

**PRD:** [feature-name].md | **Sprint:** Sprint-NN | **PI:** PI-N

| Phase | Input | Output | Total | Band | Sessions |
|-------|-------|--------|-------|------|---------|
| [phases...] | | | | | |
| **Total** | **~Nk** | **~Nk** | **~Nk** | **M** | **N** |

**Estimate vs Actual:** Pre-build M → Actual ~Nk (M) ✅ On band
```

Update the ledger summary totals by recalculating from all entries (not just adding the new one) — this prevents drift if any past entry was corrected:
- Total features: count all entries
- Total tokens: sum all feature totals
- Total input: sum all input totals
- Total output: sum all output totals
- Total sessions: sum all session counts

**Failure mode:** If `docs/tokens/[feature-name].md` does not exist or is empty, append to ledger:
```markdown
### [Feature Name] — [Project] — YYYY-MM-DD
**Note:** Token record not available for this feature — recording was not set up or files were missing.
```
Then continue with approval normally — missing token records do not block approval.

14. **Confirm closure**
    - Respond: "✓ Approved. PRD archived. Token record logged. Session sealed. Ready for next feature."

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No QA report in `docs/tests/results/` | Hard stop. "No QA report found for this feature. Run `/user:qa-report` first." |
| QA report approve gate is `Blocked` | Hard stop. List unresolved P1 TC IDs. "Resolve or waive all P1 failures, then re-run `/user:qa-report`." |
| No active PRD found | Stop. "No active PRD found in docs/prd/active/. Nothing to approve." |
| Kanban has incomplete P1 tickets | Stop. "There are incomplete P1 tickets. Resolve these before approving." Surface the tickets. |
| `docs/releases/` folder missing | Create it before saving the approval record. |
| Idea diagram not found | Skip diagram update. Note it in the approval record. |

## Rules

- After `/approve`, the AI **must never reference the archived PRD** in any future session.
- The archived PRD is a historical record only — not an active instruction set.
- If the human asks about a past feature, summarize from `docs/DEVLOG.md`, not from the archived PRD.
