# UI Prototype — Method

The method for the **UI branch** of `/prototype`. Adapted from Matt Pocock's `prototype/UI.md` (github.com/mattpocock/skills).

A UI Prototype answers **"what should this look like?"** — a question about layout, hierarchy, and affordances, not about how data flows or state behaves (that's the [Logic Prototype](logic-prototype.md)). You build several **structurally different** takes on the same surface, let the human flip between them, and capture which one wins and why. The winning layout is rebuilt under real constraints; everything else is throwaway.

> The concrete patterns below (`?variant=` query param, `NODE_ENV` gating, a component library like Tailwind/shadcn/MUI) are the **web/React case**. On other platforms, keep the intent — several structurally distinct variants, one switch to flip between them, gated out of production, using the project's own design system — and adapt the mechanism.

## When this is the right shape

Use a UI Prototype when the open question is visual/structural:
- "What should this screen look like — what's the layout and hierarchy?"
- "Which arrangement makes the primary action clearest?"
- "Which of a few structurally different takes reads best?"

**Do not** use this shape when the question is about behaviour, state, or API shape — that's the [Logic Prototype](logic-prototype.md). Keep the two separate: a UI Prototype is **read-only**; it does not validate logic.

## Two sub-shapes — strongly prefer A

| Sub-shape | Use when | How |
|-----------|----------|-----|
| **A — variants inside the existing page** (default) | the surface already has a host page | Reuse the page's existing data-fetching; swap **only the rendering**. Select the variant with a `?variant=A\|B\|C` query param (or the platform's equivalent). |
| **B — throwaway route** (last resort) | there is genuinely no host page yet | Add a throwaway route with `prototype` in its path (e.g. `/prototype/<name>`) that reads the same data and renders the variants. |

Default to **A**. Only reach for **B** when the surface is entirely new. Both are read-only and both get preserved to the throwaway branch at cleanup.

## Process

1. **State the question and pick N** — write the one-line question into `/prototype/UI.md`. Default to **3 variants; cap at 5**. More than that isn't a sharper question, just more noise.
2. **Generate radically different variants** — each must differ **structurally**: layout, information hierarchy, and primary affordance. Colour or copy changes do **not** count as different variants. Export each as a named component (`VariantA`, `VariantB`, …) using the project's component-library conventions.
3. **Wire them together** — a switcher reads the variant key from the URL (or platform equivalent) and renders the matching variant plus the floating switch bar.
4. **Build the floating switcher** — a fixed bottom-centre bar with left/right arrows that navigate by changing the URL, the current variant's key/name shown, and keyboard support (`←`/`→`). **Gate it out of production** (`process.env.NODE_ENV !== 'production'` or the platform equivalent) so it can never ship.
5. **Hand over** — share the URL and the variant keys. Expect feedback that *combines* pieces across variants ("B's header with C's sidebar") — that's the method working.
6. **Capture** — record in `/prototype/UI.md` which variant won and why (and any cross-variant combination). This is the Recommendation for Implementation that feeds the PRD. Preservation and cleanup are then handled by `/write-prd` (spike committed to the `prototype/[feature-name]` throwaway branch, working tree cleaned).

## Rules

- **Variants must be structurally different** — distinct layout, hierarchy, and primary action. Never ship a set that differs only in colour or copy.
- **Minimal shared code between variants** — a shared header is fine; a shared `<Layout>` wrapper defeats the purpose. Each variant owns its layout.
- **Read-only** — the question is visual. Stub any mutations; never wire a UI Prototype to real writes.
- **Reuse existing data** — sub-shape A swaps only rendering over the page's existing data-fetching; sub-shape B reads the same data from its throwaway route. Don't build a new data layer for a look-and-feel question.
- **Comply with the project's design system** — use the existing component library (Tailwind/shadcn/MUI/etc.); don't introduce a new one for a spike.
- **Gate the switcher out of production** — it exists only to drive the decision.

## What carries forward vs what's throwaway

| Throwaway (preserved on the `prototype/[feature-name]` branch) | Carries forward to `src/` |
|---------------------------------------------------------------|---------------------------|
| Losing variant components | The **winning** variant — **rewritten** under real constraints (error handling, accessibility, tests), not pasted |
| The floating switcher | The existing data-fetching layer (sub-shape A — already in `src/`) |
| The throwaway route (sub-shape B) | The recorded decision rationale (into the PRD) |

## Anti-patterns — never

- **Never** make variants that differ only cosmetically (colour, copy) — vary the structure or it isn't a real choice.
- **Never** wrap variants in a shared `<Layout>` — the layout is the thing under test.
- **Never** wire the prototype to real mutations — keep it read-only.
- **Never** let the switcher reach production — gate it to dev/non-production.
- **Never** promote a winning variant by pasting it — rewrite it properly under production constraints during Implementation.
