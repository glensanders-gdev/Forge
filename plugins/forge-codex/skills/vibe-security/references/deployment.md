# Deployment Security

## Production Configuration

- **Disable debug mode** in production. Debug pages leak stack traces, environment variables, and internal paths.
- **Disable source maps** in production. Source maps expose your entire source code to anyone in DevTools.
- **Verify `.git` is not accessible** in production. If `https://yoursite.com/.git/HEAD` returns content, your entire source and commit history (including any secrets ever committed) are exposed.

## Environment Separation

Use separate environment variables for each environment (Vercel or equivalent):

| Environment | Purpose |
|-------------|---------|
| Production | Live users, real keys |
| Preview | PR previews — must use test/staging keys, never production |
| Development | Local dev, local/test keys |

Preview deployments are often accessible to anyone with the URL. Never use production API keys, database credentials, or payment keys for previews.

## Security Headers

Set these headers on all responses:

```
Content-Security-Policy: default-src 'self'; script-src 'self'
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=()
```

Start restrictive and loosen as needed — not the other way around.

## CORS Configuration

- Never use `Access-Control-Allow-Origin: *` on authenticated endpoints
- Whitelist only your own domains
- `Access-Control-Allow-Credentials: true` must be paired with specific origins, not wildcards

## Pre-Ship Checks

- Run `gitleaks detect` on your repo to scan for leaked secrets in git history
- Verify `.env` files are in `.gitignore`
- Confirm debug mode and verbose logging are disabled
- Check that error pages don't leak stack traces
- Verify CORS is configured to allow only your domains
