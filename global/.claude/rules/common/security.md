# Security Checklist — Universal Baseline

Origin: Adapted from Affaan Mustafa (ECC / github.com/affaan-m/ECC)

## Pre-Commit Mandatory Checks

Before any commit to a shared branch:

- [ ] No hardcoded secrets (API keys, passwords, tokens, private keys)
- [ ] All user inputs validated and sanitised at the entry point
- [ ] Query parameters are parameterised — never string-concatenated
- [ ] HTML output is escaped — no raw user content injected into the DOM
- [ ] Authentication and authorisation verified on every protected route
- [ ] Sensitive data is not logged or included in error messages
- [ ] Rate limiting is in place on public-facing endpoints
- [ ] Error messages do not reveal implementation details or stack traces

## Secret Management

- Never commit secrets to source control — use environment variables or a secrets manager.
- Validate all required secrets are present at startup (fail fast with a clear error).
- If a secret may have been exposed: rotate it immediately, then investigate the scope.

## When to Escalate

Run `/user:security-review` when touching:

- Authentication or session management code
- Payment or financial data flows
- User-submitted content rendered to other users
- File upload or file system access
- External API calls that include credentials
- Database queries with user-supplied parameters
- Cryptographic operations

## Never

- Never use `eval()` or equivalent dynamic code execution on external input.
- Never store passwords in plain text — always hash with bcrypt, argon2, or equivalent.
- Never disable security checks to simplify code or unblock a build.
- Never trust data that crosses a trust boundary without validation.
- Never log raw request bodies that may contain credentials or PII.
