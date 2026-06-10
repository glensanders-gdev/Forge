# $jira get \<TICKET-KEY\>

[AFK] Fetch a Jira ticket and produce structured analysis suitable for planning, TDD, or sprint kick-off.

## Steps

1. Fetch the ticket via MCP `jira_get_issue` or REST API `GET /rest/api/3/issue/<key>`.
2. Extract: summary, description, acceptance criteria, priority, labels, issue type, status, assignee, linked issues, and latest 5 comments.
3. Produce structured output:

```
Ticket: <TICKET-KEY>
Summary: <title>
Status:  <status>
Priority: <priority>
Type:    <Story / Bug / Task / Epic>

Requirements:
1. <extracted requirement>
2. <extracted requirement>

Acceptance Criteria:
- [ ] <criterion>
- [ ] <criterion>

Test Scenarios:
- Happy Path: <what success looks like>
- Error Case: <what failure looks like and expected handling>
- Edge Case:  <boundary conditions, unusual inputs>

Dependencies:
- <linked issues, external APIs, services, teams>

Recommended next steps:
- $link-jira <FORGE-ID> <TICKET-KEY>   ← record this mapping in the Forge registry
- $sprintplan                           ← plan the sprint around these requirements
- $tdd                                  ← implement with tests first, using the AC above
- $jira transition <TICKET-KEY>         ← move to In Progress when ready to build
```

If acceptance criteria are not explicit in the ticket, note: "No explicit AC found — inferred from description" and make the inference visible.

If the ticket is an Epic, list child issues by key and summary rather than doing full analysis.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Ticket key not found (404) | Report the key, confirm the project prefix is correct — don't retry silently |
| Epic fetched instead of Story | Note it's an Epic, list child issues, suggest fetching a specific child instead |
