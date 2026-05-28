# /jira setup

[HITL] First-time credential configuration.

## Steps

1. Ask which auth method to use:
   ```
   Jira authentication — choose one:
     [1] MCP server (recommended — no credentials in environment)
     [2] Environment variables
   ```

2. **If MCP:** Show the MCP server config snippet to add to Claude Code's MCP settings.
   Config file location:
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   Instruct the user to restart Claude Code after adding the server.

3. **If env vars:** Ask for `JIRA_URL`, then instruct the user to set `JIRA_EMAIL` and
   `JIRA_API_TOKEN` as environment variables. Never ask for credentials directly in chat.
   Store `JIRA_URL` in `~/.claude/preferences.md`:
   ```
   jira-url: https://yourorg.atlassian.net
   ```

4. Test the connection: attempt `GET /rest/api/3/myself` (REST) or equivalent MCP call.
   Report success or the specific error.

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| `JIRA_API_TOKEN` missing or invalid | Report 401; direct user to id.atlassian.com/manage-profile/security/api-tokens |
| MCP server not responding | Fall back to env var REST API if set; otherwise stop with clear error |
