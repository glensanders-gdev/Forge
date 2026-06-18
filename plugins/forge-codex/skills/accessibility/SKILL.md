---
name: "accessibility"
description: "Design, implement, and audit inclusive digital products using WCAG 2.2 Level AA standards. Generates semantic ARIA for Web and accessibility attributes for native platforms (iOS/Android). Use when building or reviewing any user-facing interface, running an accessibility audit, or when $qa-plan flags accessibility as a concern."
metadata:
  category: code-quality
  version: 1.0.0
  origin: Adapted from ECC (github.com/affaan-m/ECC) by Affaan Mustafa
---

# Accessibility (WCAG 2.2)

Ensures digital interfaces are Perceivable, Operable, Understandable, and Robust (POUR) for all users — including those using screen readers, switch controls, or keyboard navigation. Covers WCAG 2.2 Level AA compliance for Web, iOS, and Android.

## When to Use

- Building any user-facing UI component for Web, iOS, or Android
- Auditing existing code for accessibility barriers or compliance gaps
- During `$qa-plan` — accessibility should be included in the QA checklist for any UI-bearing feature
- During `$review` — flag accessibility issues alongside code quality issues
- When a PRD includes a UI component with interactive elements

## Forge Integration Points

- **`$qa-plan`** — request an accessibility section in the QA checklist for any UI feature
- **`$review`** — include accessibility anti-patterns in the review
- **`$pii-check`** — accessible error messages must not expose PII
- **`docs/CONTEXT.md`** — add accessibility terms (ARIA, WCAG, POUR) as domain terms via `$add-term`
- **`docs/adr/`** — record accessibility approach decisions as ADRs (e.g. "We use native elements over custom ARIA")
- **`docs/known-issues.md`** — log known accessibility gaps that are deferred

---

## Core Concepts

**POUR Principles** — the four pillars of WCAG:
- **Perceivable** — information must be presentable in ways all users can perceive
- **Operable** — UI components must be operable by all users
- **Understandable** — information and operation must be understandable
- **Robust** — content must be robust enough to work with current and future assistive technologies

**Semantic Mapping** — use native elements over generic containers to provide built-in accessibility support.

**Accessibility Tree** — the representation of the UI that assistive technologies actually read.

**Focus Management** — controlling the order and visibility of the keyboard/screen reader cursor.

**Labelling and Hints** — providing context through `aria-label`, `accessibilityLabel`, and `contentDescription`.

---

## Implementation Steps

### Step 1 — Identify the Component Role

Determine the functional purpose. Is this a button, a link, a tab, a form field? Use the most semantic native element available before resorting to custom roles.

### Step 2 — Define Perceivable Attributes

- Text contrast must meet **4.5:1** (normal text) or **3:1** (large text / UI components)
- Add text alternatives for non-text content (images, icons, charts)
- Implement responsive reflow — content must work at up to 400% zoom without horizontal scrolling

### Step 3 — Implement Operable Controls

- Minimum **24×24 CSS pixel** touch/click target (WCAG 2.2 SC 2.5.8)
- All interactive elements reachable via keyboard
- Visible focus indicator on all focusable elements (SC 2.4.11)
- Single-pointer alternatives for any dragging interaction

### Step 4 — Ensure Understandable Logic

- Consistent navigation patterns throughout the interface
- Descriptive error messages with correction suggestions (SC 3.3.3)
- Avoid asking for the same data twice — Redundant Entry (SC 3.3.7)

### Step 5 — Verify Robust Compatibility

- Correct `Name, Role, Value` patterns throughout
- `aria-live` regions for dynamic status updates
- Test with at least one screen reader (VoiceOver, TalkBack, NVDA)

---

## Cross-Platform Mapping

| Feature | Web (HTML/ARIA) | iOS (SwiftUI) | Android (Compose) |
|---------|----------------|--------------|-------------------|
| Primary label | `aria-label` / `<label>` | `.accessibilityLabel()` | `contentDescription` |
| Secondary hint | `aria-describedby` | `.accessibilityHint()` | `Modifier.semantics { stateDescription = ... }` |
| Action role | `role="button"` | `.accessibilityAddTraits(.isButton)` | `Modifier.semantics { role = Role.Button }` |
| Live updates | `aria-live="polite"` | `.accessibilityLiveRegion(.polite)` | `Modifier.semantics { liveRegion = LiveRegionMode.Polite }` |

---

## Code Examples

### Web — Accessible Search Form

```html
<form role="search">
  <label for="search-input" class="sr-only">Search products</label>
  <input type="search" id="search-input" placeholder="Search..." />
  <button type="submit" aria-label="Submit Search">
    <svg aria-hidden="true">...</svg>
  </button>
</form>
```

### iOS — Accessible Action Button

```swift
Button(action: deleteItem) {
    Image(systemName: "trash")
}
.accessibilityLabel("Delete item")
.accessibilityHint("Permanently removes this item from your list")
.accessibilityAddTraits(.isButton)
```

### Android — Accessible Toggle

```kotlin
Switch(
    checked = isEnabled,
    onCheckedChange = { onToggle() },
    modifier = Modifier.semantics {
        contentDescription = "Enable notifications"
    }
)
```

---

## Anti-Patterns to Avoid

- **Div-buttons** — using `<div>` or `<span>` for click events without adding `role="button"` and keyboard support
- **Colour-only meaning** — indicating error or status only with a colour change, with no text or icon alternative
- **Uncontained modal focus** — modals that don't trap focus, allowing keyboard users to navigate background content. Focus must be contained while the modal is open and escapable via `Escape` or a close button (WCAG SC 2.1.2)
- **Redundant alt text** — using "Image of..." or "Picture of..." in alt text (screen readers already announce the role)
- **Missing error text** — showing validation failure only with a red border, no associated text message

---

## QA Checklist (for `$qa-plan` integration)

Include this section in the QA plan for any UI-bearing feature:

- [ ] All interactive elements meet the **24×24px** (Web) or **44×44pt** (Native) target size
- [ ] Focus indicators are clearly visible on all focusable elements
- [ ] Modals contain focus while open and release it cleanly on close
- [ ] Dropdowns restore focus to the trigger element on close
- [ ] All icon-only buttons have a descriptive accessible label
- [ ] Error messages are text-based and provide correction suggestions
- [ ] Content reflows properly when text is scaled to 200%
- [ ] Non-decorative images have meaningful alt text
- [ ] Colour contrast meets 4.5:1 for normal text, 3:1 for large text
- [ ] Page/screen can be navigated entirely via keyboard

---

## Rules

- Always prefer semantic native elements over custom ARIA solutions
- Accessibility is not an afterthought — flag concerns during grill and PRD phases, not just QA
- Known accessibility gaps that are deferred must be recorded in `docs/known-issues.md` with impact noted
- Screen reader testing is the only reliable way to verify — automated tools catch ~30% of issues

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| Tempted to build a custom ARIA widget | Prefer a semantic native element first — fall back to custom roles only when none fits. |
| Status or error shown by colour alone | Add a text or icon alternative — colour-only meaning fails WCAG. |
| Accessibility raised only at QA | Too late — flag concerns during grill and PRD phases too. |
| Relying on automated tooling alone | Tools catch ~30% — verify with a real screen reader (VoiceOver / TalkBack / NVDA). |
| A modal doesn't trap focus | Contain focus while open and make it escapable via `Escape` or a close button. |
| An accessibility gap must be deferred | Record it in `docs/known-issues.md` with impact noted — never drop it silently. |

## References

- [WCAG 2.2 Guidelines](https://www.w3.org/TR/WCAG22/)
- [WAI-ARIA Authoring Practices](https://www.w3.org/TR/wai-aria-practices/)
- [iOS Accessibility Programming Guide](https://developer.apple.com/documentation/accessibility)
- [Android Accessibility Developer Guide](https://developer.android.com/guide/topics/ui/accessibility)
