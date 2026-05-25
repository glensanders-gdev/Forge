---
name: tool-add
description: Register a new tool in the Forge tools registry — global or company-specific. Grills on name, category, check-command, install-hint, description, usage, and anti-patterns. Use when user runs /tool-add or /tool-add --company [name].
---

# Tool Add

Register a tool so Forge skills can discover and invoke it by category. Tools registered
here are used by `/security-assessment`, `/performance-review`, `/build` pre-flight, and
any other skill that queries the tools registry.

---

## Usage

```
/tool-add                          ← add to global registry (~/.claude/tools/global.md)
/tool-add --company [name]         ← add to company registry (~/.claude/companies/[name]/tools.md)
/tool-add --company [name] trivy prohibited   ← quick-add: mark an existing global tool as prohibited
```

---

## Standard Categories

| Category | Used by |
|----------|---------|
| `security-scanner` | `/security-assessment` |
| `performance-analyser` | `/performance-review` |
| `dependency-auditor` | `/dependency-update`, `/security-assessment` |
| `test-runner` | `/tdd` |
| `linter` | `/review`, `/push-standards` |

Custom categories are allowed — use any descriptive string.

---

## Process

### Step 1 — Determine destination

- If `--company [name]` flag: target `~/.claude/companies/[name]/tools.md`
  - If the file does not exist, create it with the template in the Appendix below.
  - Verify the company directory exists — if not, suggest running `/company-add [name]` first.
- Otherwise: target `~/.claude/tools/global.md`

### Step 2 — Quick-add (optional)

If the user provides `name` and `status` inline (e.g. `/tool-add --company acme trivy prohibited`):

- For company registries: add a status-only entry (no need to re-define fields already in global registry):
  ```
  ### trivy
  - **status:** prohibited
  ```
- Confirm to the user and stop.

### Step 3 — Grill on tool details

Ask one question at a time. For each, provide the recommended answer format.

1. **Name** — what is the tool's name? (e.g. `semgrep`, `internal-scanner`)
   - Check if it already exists in the target file. If yes, ask: "This tool is already registered. Update the existing entry? (yes/no)"

2. **Category** — which category does this tool belong to?
   - Show the standard category list. Accept any string.
   - Warn if the category doesn't match a standard one: "That's a custom category — skills that query standard categories won't find this tool unless they explicitly query `[custom-category]`."

3. **Status** (company registries only) — `required`, `approved`, or `prohibited`?
   - `required` — `/build` pre-flight will fail if this tool is absent
   - `approved` — use if present, skip gracefully if not
   - `prohibited` — never invoke; skills will note the restriction

4. **Check command** — how do we verify the tool is installed? (e.g. `command -v semgrep`)
   - Recommend: `command -v [name]` for CLI tools; `python -c "import [pkg]"` for Python libraries.

5. **Install hint** — one-line install command (e.g. `pip install semgrep` or `brew install semgrep`)

6. **Description** — one sentence: what does this tool do and for what projects?

7. **Usage** — how should a skill invoke this tool correctly? Include flags, output format, path handling.

8. **Anti-patterns** — what should a skill never do when invoking this tool?

### Step 4 — Confirm and write

Present a preview of the entry:

```
Ready to add to [global / company: name] registry:

### [tool-name]

- **category:** [category]
- **status:** [required / approved / prohibited]  ← company only
- **check-command:** [command]
- **install-hint:** [hint]
- **description:** [one sentence]
- **usage:** [usage guidance]
- **anti-patterns:** [what not to do]

Add this tool? (yes / no)
```

On confirmation, append the entry to the appropriate file under the `## Tools` section.
Create a `---` separator between entries.

### Step 5 — Confirm

```
✅ [tool-name] registered in [global / [company]] tools registry.

   Category: [category]
   Run /tool-check to verify it is installed on this machine.
```

---

## Appendix — Company tools.md Template

Create this file when a company registry doesn't yet exist:

```markdown
# [Company Name] — Tool Configuration

Last updated: YYYY-MM-DD

Tools listed here override the global registry for this company's projects.
- required: /build pre-flight fails if absent
- approved: use if installed, skip gracefully if not
- prohibited: never invoke — compliance restriction

---

## Tools

```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Company directory doesn't exist | Stop — suggest `/company-add [name]` first |
| Tool already exists in registry | Ask to update or cancel — never silently overwrite |
| Custom category used | Warn about discoverability, accept if user confirms |
| `~/.claude/tools/global.md` missing | Create it with the standard header before appending |

---

## Rules

- Never register a tool without the full set of fields (except status-only quick-add)
- Company entries with `status` only are valid — they reference global tool definitions
- Never auto-run check-command during registration — `/tool-check` does that
- Standard categories should be used where they fit — custom categories are last resort
