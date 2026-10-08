# AI Use — Universal Baseline

> Applies to all sessions. Governs what information may enter an AI tool, how AI output is
> checked, and who owns the result. A company's AI usage policy always takes precedence.

Origin: Adapted from the Digital Transformation Agency, *Using public generative AI tools safely
and responsibly* (Australian Government / digital.gov.au/policy/ai/staff-guidance-public-generative-ai, 2025)

The DTA's three principles for public servants carry over to any team delivering with AI:
**protect the information**, **critically assess the output**, and **own the decision**.

## Company Policy First

If `active_company` is set, its `## AI Usage Policy` in `config.md` governs. Read
`ai_data_restrictions`, `ai_public_tool_ceiling` and `ai_enterprise_tools` there. This baseline
fills gaps and never loosens a company rule.

## 1 — Protect the Information

- **Know which tier a tool is.** A *public* tool (open-web chat, web search, a third-party
  service or connector) may share what it receives with its provider. An *enterprise* tool is
  configured to the company's data-control requirements. Two tools can look alike while sitting
  in different tiers, such as an enterprise M365 Copilot tenant and the consumer Copilot web app.
  If the tier is unknown, treat the tool as public.
- **Respect the ceiling.** Information above `ai_public_tool_ceiling` never goes into a public
  tool. An enterprise tool may hold more, but only up to the level recorded for it in
  `ai_enterprise_tools`.
- **Assume anything sent to a public tool could become public.** That includes search queries,
  fetched URLs and the arguments sent to external services.
- **Send the minimum.** Pass only the data elements a task needs, never a whole dataset or file
  "for context".

## 2 — Critically Assess the Output

AI produces convincing content that can be inaccurate, and it can reproduce bias. Before any
AI-drafted document is presented as finished (an ORD, BRD, PRD, article, brief or summary):

- [ ] **Accuracy:** each factual claim traces to a source the reader can check. Claims that can't
      be supported are removed, not softened.
- [ ] **Citations:** every cited source exists and says what the document claims it says.
- [ ] **Fairness and bias:** wording does not disadvantage or stereotype any group, and options
      are presented on their merits.
- [ ] **Expert check:** complex or ambiguous content is flagged for a subject-matter expert to
      validate, never asserted as settled.
- [ ] **Disclosure:** AI involvement is stated wherever the team or company expects it.

## 3 — Own the Decision

- The human stays responsible for every piece of content they create, share or act on.
- AI drafts, analyses and recommends. It never makes the final decision. This is
  Forge Principle 1, and the reason every HITL gate exists.
- AI never assesses or ranks people, applications, bids or suppliers for selection. It may
  summarise the criteria; the human applies them.

## Never

- Never put personal information, customer data or credentials into a public AI tool.
- Never put information above the public-tool ceiling into a public tool, and never put
  information above an enterprise tool's recorded level into that tool.
- Never put third-party copyright material into a public tool, and never use one to imitate or
  generate culturally significant work, such as First Nations art.
- Never use AI translation for public-facing material without professional review.
- Never present an unverified AI claim as fact, or a fabricated citation as a source.
- Never let an AI output stand as the final decision on selection, approval or advice.
