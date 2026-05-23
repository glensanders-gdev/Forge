<!-- Forge v2.3.2 — update from project template when upgrading Forge -->

# Error Handling Standards

Reference file — loaded on demand when debugging or setting up error infrastructure. Do not load at session start.

---

## Required Infrastructure (Before Any Feature Work)

```
1. Pre-DOM error capture
   - window.__earlyErrors = [] in <head> script
   - window.onerror stores to __earlyErrors[] (no DOM access)
   - window.onunhandledrejection stores promise rejections

2. Init-time error capture
   - Each startup function wrapped in individual try/catch
   - On failure: display error banner, stop init, do not continue
   - Error shows: function name, error message, stack trace lines

3. Runtime error capture
   - window.onerror installed AFTER successful init completes
   - Displays visible on-screen banner with full detail
   - window.onunhandledrejection also installed

4. On-screen error banner
   - Always present in HTML as a hidden div (not dynamically created)
   - Built using DOM methods only — createElement, textContent
   - Never innerHTML, never inline event handler strings
   - Shows: label, detail, stack trace, Dismiss button
   - Dismissible but not auto-dismissing
   - Positioned above navigation (z-index highest in app)
```

---

## Error Display Rules

- Use `createElement` / `textContent` — **never `innerHTML`** in error handlers.
- No inline `onclick` strings in error UI — use `addEventListener`.
- Capture callback reference to local variable before nulling it (null-before-call bug).
- The error trap must never itself throw — test it independently first.
- Never modify error trap code as part of another feature's patch.

---

## Platform-Specific Notes (iOS Safari)

- `confirm()` and `alert()` silently return `false` in PWA / WKWebView — **banned**.
- `file://` origin masks all error detail — always test over HTTPS.
- `window.onerror` requires `document.body` to exist — install after DOM ready.
- "Script error" with no detail = cross-origin issue or pre-DOM error.
- Custom in-app dialogs required for all confirmations and alerts.

---

## Silent Failure Discipline

Not all bugs throw errors. For every interactive element, verify the full chain:

- Event fires ✓
- Handler is called ✓
- State changes correctly ✓
- UI updates ✓
- Side effects occur (save, sync, toast, navigation) ✓

---

## Logging Standards

```
console.warn  — recoverable issues (sync failure, missing optional element)
console.error — genuine errors that affect functionality
// Never silence errors without logging them
```

---

## Common Bug Patterns

- **Null-before-call:** callback stored then nulled before use — capture to local var first.
- **Global selector bleed:** `querySelectorAll('.class')` matching unintended elements — scope to container.
- **String quote mismatch:** single quotes inside single-quoted strings in generated HTML.
- **Positional assumption:** code assumes element X follows element Y — use IDs not position.
- **Async timing:** DOM not ready when script runs — check element existence before access.
