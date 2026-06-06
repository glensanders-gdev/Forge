---
name: vibe-security
category: security
description: Active security auditor for AI-generated ("vibe-coded") codebases. Loads technology-specific reference files and produces severity-ranked findings with before/after fixes. Covers secrets, database access control, auth, rate limiting, payments, mobile, AI/LLM integration, deployment, and data access. Trigger proactively when writing or reviewing auth, payments, database, API keys, or user data — not just on explicit security requests.
origin: Adapted from Chris Raroque (vibe-security-skill / github.com/raroque/vibe-security-skill)
license: MIT
---

# Vibe Security

Active security audit skill for AI-generated codebases. AI assistants consistently introduce the same security mistakes: hardcoded secrets, disabled RLS, client-trusted prices, tokens in localStorage. This skill catches those patterns before they ship — and prevents them during code generation.

*Adapted from [Chris Raroque](https://twitter.com/raroque) / [Aloa](https://aloa.co). Original: [raroque/vibe-security-skill](https://github.com/raroque/vibe-security-skill).*

---

## Usage

**Claude Code:** `/vibe-security` or natural language — "check my code for security issues", "audit this project", "is this safe?"  
**Codex:** `$vibe-security` or "review this for vulnerabilities", "check my Supabase RLS"

```
/vibe-security                    ← full codebase audit
/vibe-security --scope auth       ← authentication and authorisation only
/vibe-security --scope payments   ← payment flows only
/vibe-security src/api/           ← specific path
```

Also activates automatically when writing or reviewing code that handles auth, payments, database access, API keys, or user data — even without an explicit security request.

---

## Core Principle

**Never trust the client.** Every price, user ID, role, subscription status, feature flag, and rate limit counter must be validated or enforced server-side. If it exists only in the browser, mobile bundle, or request body, an attacker controls it.

---

## Audit Process

For each step, load the relevant reference file only if the codebase uses that technology. Skip irrelevant steps — don't waste context.

1. **Secrets & Environment Variables** — hardcoded keys, client-side env prefixes (`NEXT_PUBLIC_`, `VITE_`, `EXPO_PUBLIC_`), `.gitignore`. → `references/secrets-and-env.md`
2. **Database Access Control** — Supabase RLS, Firebase Security Rules, Convex auth guards. #1 source of critical vulns in AI-generated apps. → `references/database-security.md`
3. **Authentication & Authorization** — JWT handling, middleware-only auth, Server Action protection, session management. → `references/authentication.md`
4. **Rate Limiting & Abuse Prevention** — auth, AI, email, and file-processing endpoints; tamper-proof counters. → `references/rate-limiting.md`
5. **Payment Security** — client-side price manipulation, webhook signature verification, subscription status validation. → `references/payments.md`
6. **Mobile Security** — React Native / Expo: secure token storage, API key protection via backend proxy, deep link validation. → `references/mobile.md`
7. **AI / LLM Integration** — exposed AI API keys, missing usage caps, prompt injection, unsafe output rendering. → `references/ai-integration.md`
8. **Deployment Configuration** — debug mode in production, source map exposure, security headers, `.git` accessible. → `references/deployment.md`
9. **Data Access & Input Validation** — SQL injection, ORM misuse (Prisma operator injection), missing input validation. → `references/data-access.md`

For partial reviews or code generation in a specific area, load only the relevant reference file(s).

---

## Output Format

Organise findings by severity: **Critical** → **High** → **Medium** → **Low**.

For each finding:
1. File path and relevant line(s)
2. Vulnerability name
3. Concrete attacker impact (not abstract risk)
4. Before/after code fix

Skip areas with no issues. End with a prioritised summary.

If a **Critical** issue is found (exposed secrets, disabled RLS, auth bypass) — flag it immediately at the top, before the full list.

---

## When Generating Code

Before writing code that touches auth, payments, database access, API keys, or user data — consult the relevant reference file proactively. Prevention is better than detection.

---

## Forge Integration

- **`/security-assessment`** — use for full OWASP-structured audits with threat modelling; use `/vibe-security` for fast, technology-specific pattern audits
- **`/review`** — `/vibe-security` runs automatically on auth/payment/data-access scope reviews
- **`/build`** — reference files loaded when writing code in security-sensitive areas
- **`/go-nogo`** — Critical or High findings from `/vibe-security` are a NO-GO gate

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No Supabase / Firebase in codebase | Skip database-security step entirely |
| No Stripe / payment code found | Skip payments step |
| React Native / Expo not in use | Skip mobile step |
| No AI API calls found | Skip AI integration step |
| Critical finding detected | Surface immediately at top of response, don't bury in list |
| Partial audit requested | Load only relevant reference file(s); note what was skipped |

---

## Never

- Never report style issues or non-security concerns
- Never bury a Critical finding in the middle of a long list
- Never run `$queryRawUnsafe` or equivalent in generated code
- Never suggest `jwt.decode()` where `jwt.verify()` is needed
- Never generate code with hardcoded credentials, even as examples
