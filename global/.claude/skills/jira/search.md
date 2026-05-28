# /jira search \<JQL\>

[AFK] Run a JQL query and return a summary table.

## Steps

1. Execute the JQL query via MCP or REST API `GET /rest/api/3/search?jql=<encoded-jql>`.
2. Return a markdown table of matching issues (up to 20 results):

```
| Key       | Summary                          | Status      | Priority | Assignee   |
|-----------|----------------------------------|-------------|----------|------------|
| PROJ-1234 | Add OAuth2 login                 | In Progress | High     | Alice      |
| PROJ-1235 | Fix session timeout bug          | To Do       | Medium   | Unassigned |
```

3. If more than 20 results, note: "Showing 20 of N — refine the JQL to narrow results."

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| JQL parse error | Show the Jira error message verbatim — don't attempt to auto-correct the query |
