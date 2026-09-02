# UI Prototype — Method

The method for the **UI branch** of `$prototype`. Adapted from Matt Pocock's `prototype/UI.md` (github.com/mattpocock/skills).

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
| **B — throwaway route** (last resort) | there is genuinely no host page yet | Add a throwaway route with `prototype` in its path (e.g. `$prototype/<name>`) that reads the same data and renders the variants. |

Default to **A**. Only reach for **B** when the surface is entirely new. Both are read-only and both get preserved to the throwaway branch at cleanup.

## Structural accessibility — decided here, not later

A UI Prototype chooses layout, information hierarchy and primary affordance. That is precisely the input to a subset of WCAG 2.2 A/AA criteria, so those criteria are **decided by the variant you pick** and cannot be retrofitted during Implementation without discarding the decision. Everything else — contrast, names and roles, live regions, error handling — is implementation-phase work and correctly belongs to the rewrite.

Run this as a **screen over the variant set, not an audit of the spike**. The question per criterion is *"is this reachable from this structure?"*, never *"does this throwaway code conform?"* — auditing variants that are about to be deleted is the effort the prototype method exists to avoid. See `$accessibility` for the criteria themselves; the table below is only the subset this stage owns.

| SC | Name | Level | What the layout choice determines |
|----|------|-------|-----------------------------------|
| 1.3.1 | Info and Relationships | A | Heading hierarchy, landmarks, whether visual grouping has a programmatic equivalent |
| 1.3.2 | Meaningful Sequence | A | Whether reading order survives linearisation |
| 1.4.1 | Use of Color | A | Whether the variant's hierarchy mechanism *is* colour, with no second channel |
| 1.4.4 | Resize Text (200%) | AA | Fixed-height containers, side-by-side panes |
| 1.4.10 | Reflow (320 CSS px, no 2-D scroll) | AA | Multi-column and multi-pane arrangements |
| 1.4.12 | Text Spacing | AA | Tight vertical rhythm chosen for density |
| 1.4.13 | Content on Hover or Focus | AA | Whether the primary affordance is hover-revealed — a menu, a tooltip, a preview. An affordance decision, like 2.5.7 |
| 2.4.3 | Focus Order | A | DOM order against visual order |
| 2.4.6 | Headings and Labels | AA | The hierarchy under test *is* the heading structure |
| 2.4.11 | Focus Not Obscured (Minimum) | AA | Sticky chrome, floating action bars, docked drawers |
| 2.5.7 | Dragging Movements | AA | Whether the primary affordance is a drag — an affordance decision, not polish |
| 2.5.8 | Target Size (Minimum), 24×24 CSS px | AA | Density of the chosen control arrangement |
| 3.2.3 | Consistent Navigation | AA | A variant that relocates navigation relative to its siblings |
| 3.2.4 | Consistent Identification | AA | As above, for repeated controls |
| 3.2.6 | Consistent Help | A | Placement and relative order of the help affordance |

**WCAG 2.2 Level AA is the floor, not the aspiration.** In Australia it is the minimum for any public-facing digital service in *either* sector — Disability Discrimination Act 1992 s.24, via the Australian Human Rights Commission's April 2025 guidelines — and it is mandated for Commonwealth entities by the Digital Transformation Agency's Digital Experience Policy. A procurement clause citing AS EN 301 549 names WCAG 2.1 and does not discharge that. Check the jurisdiction the surface actually ships into; where it is not Australia, the structural subset above is unchanged because WCAG is jurisdiction-neutral.

## Switcher operability — the harness must not gate the study

The switcher never ships, so it carries no **shipping** obligation. It carries an **operability** one, and the source is this method's own step 5: where the surface is public-facing the evaluation includes participants with disability, and the bar is the only way to reach a variant. A switcher they cannot drive gates them out of the study you just told them to run. The harness must not distort the evaluation — and it must not prevent it.

Build to this floor. It is a floor, not an audit — five checks, none of which needs a tool.

| | Requirement | Why it bites |
|---|---|---|
| Arrows are real buttons | Native `<button>`, or the platform's focusable control | A `<div>` is not Tab-reachable and carries no role — every keyboard and screen-reader participant is locked out at the first step |
| Each arrow has an accessible name | "Previous variant" / "Next variant" | Two controls both announcing "button" name no direction |
| The variant change is announced | Move focus to the new variant's first heading, **or** announce the key through a live region — one or the other, deliberately | The URL changes and the region re-renders in silence otherwise. This is the gap that most often ends the session |
| The bar's own controls meet 24×24 CSS px | 2.5.8, applied to the harness | The table above holds every variant to it; a cramped harness exempting itself is the failure it screens for |
| Focus is visible on the bar | 2.4.7, and 2.4.13 where the project takes it | A participant who cannot see where focus sits cannot report what they were looking at |

Nothing beyond this list. The switcher is throwaway code and the rest of WCAG is the rewrite's.

## Process

1. **State the question and pick N** — write the one-line question into `$prototype/UI.md`. Default to **3 variants; cap at 5**. More than that isn't a sharper question, just more noise.
2. **Generate radically different variants** — each must differ **structurally**: layout, information hierarchy, and primary affordance. Colour or copy changes do **not** count as different variants. Export each as a named component (`VariantA`, `VariantB`, …) using the project's component-library conventions. **A variant that cannot reach WCAG 2.2 AA without changing its layout is not a candidate** — screen it against the structural table above and discard it before the human sees it, or record why it is shown anyway.
3. **Wire them together** — a switcher reads the variant key from the URL (or platform equivalent) and renders the matching variant plus the floating switch bar.
4. **Build the floating switcher** — a fixed bottom-centre bar with left/right arrows that navigate by changing the URL, the current variant's key/name shown, and keyboard support (`←`/`→`). **Gate it out of production** (`process.env.NODE_ENV !== 'production'` or the platform equivalent) so it can never ship. Never shipping discharges its **shipping** obligation and not its **operability** one — meet the floor in § Switcher operability. Scope `←`/`→` to when focus is on the switcher (those keys belong to any listbox, tablist, radio group or slider inside the variant, and to a screen reader's browse mode), and keep the bar clear of the variant's focusable content — a bar sitting over the bottom edge manufactures a 2.4.11 failure that is the harness's, not the variant's.
5. **Hand over** — share the URL and the variant keys. Expect feedback that *combines* pieces across variants ("B's header with C's sidebar") — that's the method working. **Where the surface is public-facing, the evaluation includes participants with disability** — the DTA's Digital Inclusion Standard requires co-design and usability testing with diverse user groups for Commonwealth entities, and for everyone else it is the cheapest available evidence against a DDA claim. A variant set judged only by a product owner and a designer was chosen the way the standard says not to choose it.
6. **Capture** — record in `$prototype/UI.md` which variant won and why (and any cross-variant combination). Record the winner's **structural accessibility constraints** alongside the rationale. They land in the PRD as **`CON-NNN` rows in § Solution Constraints** — a demand-side given with a regulatory source, not prose in Further Notes; a binding statement written as prose is the defect `rules/requirements/tables.md` exists to prevent. The PRD inherits a known constraint rather than an Implementation surprise. This is the Recommendation for Implementation that feeds the PRD. Preservation and cleanup are then handled by `$write-prd` (spike committed to the `prototype/[feature-name]` throwaway branch, working tree cleaned).

## Rules

- **Variants must be structurally different** — distinct layout, hierarchy, and primary action. Never ship a set that differs only in colour or copy.
- **Minimal shared code between variants** — a shared header is fine; a shared `<Layout>` wrapper defeats the purpose. Each variant owns its layout.
- **Read-only** — the question is visual. Stub any mutations; never wire a UI Prototype to real writes.
- **Reuse existing data** — sub-shape A swaps only rendering over the page's existing data-fetching; sub-shape B reads the same data from its throwaway route. Don't build a new data layer for a look-and-feel question.
- **Comply with the project's design system** — use the existing component library (Tailwind/shadcn/MUI/etc.); don't introduce a new one for a spike. A mature system already ships the conformant behaviour (focus, target size, semantics); a government or GBE surface reuses the relevant government design system for the same reason.
- **Screen the variant set for structural accessibility before hand-over** — the table above is what this stage owns; `$accessibility` owns everything else, at rewrite time.
- **Gate the switcher out of production** — it exists only to drive the decision.

## What carries forward vs what's throwaway

| Throwaway (preserved on the `prototype/[feature-name]` branch) | Carries forward to `src/` |
|---------------------------------------------------------------|---------------------------|
| Losing variant components | The **winning** variant — **rewritten** under real constraints (error handling, *implementational* accessibility, tests), not pasted |
| — | The winner's **structural** accessibility constraints, decided at this stage and inherited by the PRD |
| The floating switcher | The existing data-fetching layer (sub-shape A — already in `src/`) |
| The throwaway route (sub-shape B) | The recorded decision rationale (into the PRD) |

## Anti-patterns — never

- **Never** make variants that differ only cosmetically (colour, copy) — vary the structure or it isn't a real choice.
- **Never** wrap variants in a shared `<Layout>` — the layout is the thing under test.
- **Never** wire the prototype to real mutations — keep it read-only.
- **Never** let the switcher reach production — gate it to dev/non-production.
- **Never** pick a winner whose primary affordance is drag-only with no single-pointer alternative (SC 2.5.7).
- **Never** let colour be the sole mechanism carrying the hierarchy under test (SC 1.4.1).
- **Never** let the switcher obscure the variant or claim keys the variant needs — the harness must not out-rank the thing being measured.
- **Never** hand over a switcher a participant with disability cannot drive — the harness must not out-rank the thing being measured, and it must not gate who gets to measure it (§ Switcher operability).
- **Never** run a full WCAG audit on throwaway variants — screen the structure, audit the rewrite.
- **Never** promote a winning variant by pasting it — rewrite it properly under production constraints during Implementation.
