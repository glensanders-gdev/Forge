# $jira transition \<TICKET-KEY\>

[HITL] Move a ticket through its workflow states.

## Steps

1. **[AFK]** Fetch available transitions via MCP or REST API `GET /rest/api/3/issue/<key>/transitions`.

2. **[HITL]** Present options and wait for selection:

```
Available transitions for <TICKET-KEY> (current status: <status>):

  [1] To Do
  [2] In Progress
  [3] In Review
  [4] Done

Select transition (number) or cancel:
```

3. **[AFK]** Execute the selected transition via `POST /rest/api/3/issue/<key>/transitions`.

4. **[AFK]** Confirm: "✅ <TICKET-KEY> moved to <new-status>."

5. **[AFK]** If the local Forge kanban (`docs/kanban.md`) has a ticket referencing this Jira key, offer to update its status:
   "Jira shows <TICKET-KEY> as Done — update docs/kanban.md to match? (yes / no)"

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No transitions available | Report "No transitions available — check Jira permissions for this ticket" |
