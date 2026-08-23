# AI / LLM Integration Security

## API Keys Are Server-Side Only

AI API keys (Anthropic, OpenAI, Google, etc.) must never appear in client-side code. A leaked key allows unlimited API usage at your expense — a single exposed key can drain thousands of dollars in minutes.

- No `NEXT_PUBLIC_ANTHROPIC_API_KEY` or `NEXT_PUBLIC_OPENAI_API_KEY`
- No API keys in React Native / Expo bundles
- No API keys in client-side JavaScript

All AI API calls go through your backend. The client sends the user's message to your server; your server calls the AI API.

## Spending Caps

Set hard spending caps on every AI API provider:
- Anthropic: Spending limits in console
- OpenAI: Usage limits in dashboard
- Google: Budget alerts in Cloud Console

Also implement **per-user usage limits** in your application:
- Track token usage per user in your database
- Set daily/monthly caps per user or per tier
- Return a clear error when limits are exceeded
- Don't rely solely on provider caps — they may have lag

## Prompt Injection

User input must not be concatenated directly into system prompts:

```typescript
// BAD: user can override system instructions
const prompt = `You are a helpful assistant. User says: ${userInput}`;

// BETTER: separate system and user messages
const messages = [
  { role: 'system', content: 'You are a helpful assistant.' },
  { role: 'user', content: userInput },
];
```

For high-stakes applications, also consider input validation/filtering and output validation before acting on LLM responses.

## LLM Output Is Untrusted

Treat LLM responses as untrusted input:

- **Sanitize before rendering as HTML** — LLM output can contain script tags or event handlers
- **Never execute LLM output as code** without sandboxing
- **Validate tool/function call parameters** — validate all returned parameters against an allowlist and schema before executing

## Tool / Function Calling

If your application gives an LLM access to tools (database queries, API calls, file operations):
- Restrict operations to a safe allowlist
- Validate all parameters from the LLM against a schema
- Use least-privilege access (read-only where possible)
- Log all tool invocations for audit
