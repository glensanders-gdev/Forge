# Forge Global Tools Registry

Tools registered here are available to all projects. Skills look up tools by **category**,
not by name — the first installed tool in the requested category wins.

Company tools (`~/.claude/companies/[name]/tools.md`) are checked first and take priority.
Company entries can mark a global tool as `required`, `approved`, or `prohibited`, or define
entirely new tools not listed here.

---

## Standard Categories

| Category | Skills that use it |
|----------|-------------------|
| `security-scanner` | `/security-assessment` |
| `performance-analyser` | `/performance-review` |
| `dependency-auditor` | `/dependency-update`, `/security-assessment` |
| `test-runner` | `/tdd` |
| `linter` | `/review`, `/push-standards` |

Custom categories are allowed — use any descriptive string. The AI will warn if an
unrecognised category is used but will not block it.

---

## Tools

### semgrep

- **category:** security-scanner
- **check-command:** `command -v semgrep`
- **install-hint:** `pip install semgrep` or `brew install semgrep`
- **description:** General-purpose static analysis tool. Finds bugs, security issues, and anti-patterns across many languages using configurable pattern rules.
- **usage:** Run `semgrep --config=auto [path] --json --output [file]` for structured output. Use `--config=p/owasp-top-ten` for OWASP-focused scans. Always write output to a file, not stdout.
- **anti-patterns:** Do not run without `--config` — no rules loaded means zero findings silently. Do not scan `node_modules/` or vendor directories — use `--exclude`. Do not treat zero findings as a clean pass without confirming rules loaded correctly.

---

### bandit

- **category:** security-scanner
- **check-command:** `command -v bandit`
- **install-hint:** `pip install bandit`
- **description:** Python-specific static security analyser. Finds common security issues using AST analysis. Python projects only.
- **usage:** Run `bandit -r [path] -f json -o [file]`. Use `-ll` to filter low-severity noise in large codebases.
- **anti-patterns:** Do not use on non-Python projects. Do not suppress all B-level findings without review — some are serious in specific contexts.

---

### trivy

- **category:** security-scanner
- **check-command:** `command -v trivy`
- **install-hint:** `brew install trivy` or `apt-get install trivy`
- **description:** CVE scanner for filesystems, container images, and dependency lock files. Broad language support via lock file parsing.
- **usage:** Run `trivy fs [path] --format json --output [file]` for filesystem scans. Use `trivy image [name]` for containers. Focus on HIGH and CRITICAL severity findings by default.
- **anti-patterns:** Do not ignore HIGH findings without a documented justification. Do not run without `--format json` when output will be parsed programmatically.

---

### lighthouse

- **category:** performance-analyser
- **check-command:** `command -v lighthouse`
- **install-hint:** `npm install -g lighthouse`
- **description:** Google's web performance auditing tool. Scores pages on Performance, Accessibility, Best Practices, and SEO. Requires a running web server and Chrome/Chromium.
- **usage:** Run `lighthouse [url] --output json --output-path [file] --quiet`. Always use `--quiet` to suppress progress noise. Run against a local dev server, not production.
- **anti-patterns:** Do not run against production — use a local dev server or staging. Do not treat a single run as definitive — scores vary; run three times and average. Do not omit `--quiet` when parsing output programmatically.

---

### npm audit

- **category:** dependency-auditor
- **check-command:** `command -v npm`
- **install-hint:** Install Node.js from nodejs.org
- **description:** Built-in Node.js dependency vulnerability scanner. Checks installed packages against the npm advisory database. Node/npm projects only.
- **usage:** Run `npm audit --json > [file]` from the project root. Requires `package-lock.json` or `yarn.lock` to be present.
- **anti-patterns:** Do not run `npm audit fix` automatically — review breaking changes first. Do not ignore HIGH or CRITICAL advisories without a documented exception.

---

### pip-audit

- **category:** dependency-auditor
- **check-command:** `command -v pip-audit`
- **install-hint:** `pip install pip-audit`
- **description:** Python dependency vulnerability scanner. Checks installed packages against PyPI Advisory Database and OSV. Python projects only.
- **usage:** Run `pip-audit --format json -o [file]` from the project root.
- **anti-patterns:** Do not run without a virtual environment active — results will reflect global packages, not project packages.
