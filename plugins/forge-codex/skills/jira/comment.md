# $jira comment \<TICKET-KEY\>

[HITL] Summarise current session progress and post it to the ticket as a structured comment.

## Steps

1. **[AFK]** Gather session context:
   - Read `docs/DEVLOG.md` — most recent entry
   - Read `docs/kanban.md` — current ticket status
   - Summarise: what was built, what was tested, what was committed, any blockers

2. **[HITL]** Preview the comment before posting:

```
── Comment preview for <TICKET-KEY> ──────────────────────────────

Progress update — <date>

**Done this session:**
- <item>
- <item>

**Tests:** <N passing / N added>

**Next:** <what's planned>

**Blockers:** <none / description>

──────────────────────────────────────────────────────────────────
Post this comment? (yes / edit / cancel)
```

Wait for explicit response. If "edit", display the comment text for the user to revise, then re-show the preview and ask again. If "cancel", stop without posting.

3. **[AFK]** Post the approved comment via MCP or REST API `POST /rest/api/3/issue/<key>/comment`.

4. **[AFK]** Confirm: "✅ Comment posted to <TICKET-KEY>."

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Comment post fails | Do not retry automatically — show the error and ask the user what to do |
