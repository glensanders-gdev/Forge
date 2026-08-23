# Rate Limiting & Abuse Prevention

## Where Rate Limiting Is Required

Every one of these endpoints needs rate limiting. AI assistants almost never add it:

- **Auth endpoints** — login, register, password reset, OTP, magic link. Without limits, attackers brute-force passwords or enumerate accounts.
- **AI API calls** — any endpoint calling OpenAI, Anthropic, or similar. One user can drain your entire monthly budget in minutes.
- **Email / SMS sending** — attackers use your app as a spam relay.
- **File processing** — upload, resize, convert. CPU-intensive operations without limits enable denial-of-service.
- **Webhook-like endpoints** — anything accepting external input at scale.

## Don't Store Rate Limit Counters in Public Tables

If counters live in a Supabase public table, users can reset their own counters via the REST API. Use instead:

- **Upstash Redis** — serverless Redis with built-in rate limiting primitives
- **Private schema table** — not exposed via PostgREST
- **Middleware-level limiting** — at the edge or API gateway

## Combine Per-IP and Per-User Limiting

- IP-only limits are defeated by rotating IPs (trivial with VPNs)
- User-only limits are defeated by creating new accounts
- Use both together.

## Billing Protection

- Set billing alerts on every cloud provider (AWS, GCP, Vercel)
- Set **hard spending caps** on AI API providers (OpenAI, Anthropic)
- Per-user usage quotas with hard limits, not soft warnings
- Monitor for anomalous usage spikes

## Implementation Pattern

```typescript
// Upstash Redis rate limiting
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '1 m'),
});

export async function POST(request: Request) {
  const ip = request.headers.get('x-forwarded-for') ?? '127.0.0.1';
  const { success } = await ratelimit.limit(ip);
  if (!success) return new Response('Too many requests', { status: 429 });
  // ...
}
```
