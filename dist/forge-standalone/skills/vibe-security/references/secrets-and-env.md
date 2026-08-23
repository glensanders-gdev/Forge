# Secrets & Environment Variables

## Hardcoded Credentials

Never hardcode API keys, tokens, passwords, or credentials in source code — including connection strings with embedded passwords, private keys, or certificates. If a secret was ever committed to git history, consider it compromised — deleting the file does not remove it from history. Rotate immediately. Run `gitleaks detect` to scan history.

## Client-Side Environment Variable Prefixes

These prefixes inline env vars into the client bundle at build time. Everything in the bundle is visible to anyone:

| Framework | Client Prefix | Risk |
|-----------|--------------|------|
| Next.js | `NEXT_PUBLIC_` | Inlined into browser JS at build time |
| Vite | `VITE_` | Inlined into browser JS at build time |
| Expo / React Native | `EXPO_PUBLIC_` | Baked into the app bundle |
| Create React App | `REACT_APP_` | Inlined into browser JS at build time |

**Safe client-side:**
- Stripe publishable key (`pk_live_*`, `pk_test_*`)
- Supabase anon key
- Firebase client config (apiKey, authDomain, projectId)
- Public analytics IDs

**Never client-side:**
- Supabase `service_role` key — bypasses all RLS
- Stripe secret key (`sk_live_*`, `sk_test_*`)
- Any database connection string
- Any third-party API secret key
- JWT signing secrets
- OAuth client secrets

## .gitignore

Ensure `.env`, `.env.local`, `.env.*.local`, and any file containing secrets is in `.gitignore` **before the first commit**. `.env.example` / `.env.sample` files must contain only placeholder values, never real keys.

## Detection Patterns

When auditing, search for:
- `.env` files tracked by git: `git ls-files | grep .env`
- Key pattern strings: `sk_live_`, `sk_test_`, `AKIA`, `ghp_`, `glpat-`, `xoxb-`, `Bearer `
- `process.env.NEXT_PUBLIC_` or `import.meta.env.VITE_` referencing anything with "secret", "private", "service", or "key" in the name
- Hardcoded URLs containing credentials: `postgresql://user:password@host`
