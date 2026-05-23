# Deploy Configuration: [Project Name]

**Last updated:** YYYY-MM-DD

---

## Pre-Build Check (Optional)

Command to run before the build loop begins. If it fails, /build stops and surfaces the output.

```
build-check: [command]

# Examples:
# build-check: npm test
# build-check: python -m pytest
# build-check: cargo check
# build-check: node --check src/index.js
```

Leave blank to skip the pre-build check.

---

## Deploy Order

Position in `/deploy-pi` sequence (lower = deployed first):

```
deploy-order: 1
```

---

## Environments

### Staging (optional)

```
staging:
  platform: Vercel | Railway | GitHub Pages | custom
  command: [deploy command]
  url: https://staging.[your-domain].com
  health-check: https://staging.[your-domain].com/health
```

### Production

```
production:
  platform: Vercel | Railway | GitHub Pages | custom
  command: [deploy command]
  url: https://[your-domain].com
  health-check: https://[your-domain].com/health
```

---

## Deployment Commands

```bash
# Staging deploy command
# e.g. vercel --env staging
# e.g. railway deploy --environment staging

# Production deploy command
# e.g. vercel --prod
# e.g. railway deploy --environment production
# e.g. git push heroku main
```

---

## Rollback Command

```bash
# Command to rollback to a previous version
# e.g. vercel rollback [deployment-url]
# e.g. railway rollback
# e.g. git revert HEAD && git push heroku main
```

---

## Health Check

```
health-check-url: https://[your-domain].com/health
health-check-timeout: 30s
expected-status: 200
```

---

## Environment Variables

List the environment variables required for deployment. Never store values here — reference only.

```
# Required environment variables (configure in your hosting platform's dashboard)
# Variable name → where to find the value

# DATABASE_URL       → set in [platform] dashboard → Environment → Production
# API_KEY            → obtain from [service] → API settings
# SECRET_KEY         → generate with: openssl rand -hex 32
```

**Rule:** Never commit secret values to the repository. If a secret is accidentally committed, rotate it immediately.

---

## Notes

Any platform-specific deployment notes, environment variable requirements, or pre-deploy steps.

---

## Example — Vercel

```
deploy-order: 2

staging:
  platform: Vercel
  command: vercel
  url: https://my-app-git-main-username.vercel.app
  health-check: https://my-app-git-main-username.vercel.app/api/health

production:
  platform: Vercel
  command: vercel --prod
  url: https://my-app.com
  health-check: https://my-app.com/api/health
```

## Example — Railway

```
deploy-order: 1

production:
  platform: Railway
  command: railway up
  url: https://my-app.railway.app
  health-check: https://my-app.railway.app/health
```
