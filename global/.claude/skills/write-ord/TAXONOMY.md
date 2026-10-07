# write-ord — Quality Taxonomy

The ISO/IEC 25010:2023 characteristics every ORD is classified against in Phase 1, the
ISO/IEC 25059:2023 sub-characteristics that extend them where `ai.md` fires, and the 2011→2023
changes. Where each lands in the ORD is the §7 table in [TEMPLATE.md](TEMPLATE.md).

---

## ISO/IEC 25010:2023 Quality Characteristics

Nine top-level characteristics, in the standard's order. Map every non-functional requirement to one
sub-characteristic before writing the ORD. **The number in each heading is the standard's, not the
ORD's** — the ORD section it lands in is given beside it.

### 1. Functional Suitability — ORD §7.8
Does the system do the right things?
- **Functional Completeness** — all specified tasks covered
- **Functional Correctness** — accurate results with required precision
- **Functional Appropriateness** — functions align with user goals

*ORD relevance:* what must be true in production, never how it is built — the completeness of a
process or a reported measure (§7.8.1) and the correctness of a result, to the precision the
business needs (§7.8.2).

### 2. Performance Efficiency — ORD §7.1
Does the system perform its functions within required time, throughput, and resource constraints?
- **Time Behavior** — response and processing times, throughput rates *(highest ORD priority)*
- **Resource Utilization** — CPU, memory, storage, network, energy usage
- **Capacity** — maximum concurrent users, peak transaction volumes, data volume limits

*ORD relevance:* the wait, delay or deadline the business tolerates, and what is breached beyond
it — never a latency, throughput or utilisation figure, which is the design response's answer.
"Fast" is not a requirement.

### 3. Compatibility — ORD §7.4
Can the system exchange information and coexist with other systems?
- **Coexistence** — operates without harming other systems sharing the environment
- **Interoperability** — exchanges information with specified external systems per defined protocols

*ORD relevance:* what must keep working with each named counterpart system or party, and the
business consequence when an exchange fails or arrives late — never a protocol or integration
pattern. Technical attributes of an existing interface go to §16 as specification, not commitment.

### 4. Interaction Capability — ORD §7.7 *(formerly Usability — 2011)*
Can specified users operate the system to achieve their goals?
- **Appropriateness Recognizability** — users can identify if the system fits their needs
- **Learnability** — users can learn to operate it within a specified timeframe
- **Operability** — easy to operate and control
- **User Engagement** — features encourage continued use *(replaced UI Aesthetics)*
- **Accessibility** — usable by people with the widest range of characteristics
- **Inclusivity** — designed for diverse abilities and backgrounds *(NEW in 2023)*
- **Self-Descriptiveness** — system communicates how to use it correctly *(NEW in 2023)*

*ORD relevance:* who must be able to use it and to what standard — an accessibility obligation
(WCAG 2.2 AA where policy or law requires it), how quickly a new operator reaches competence, and
what a customer completes without assistance. Training itself is referred (§10.3), never a
requirement here.

### 5. Reliability — ORD §7.2
Does the system perform its functions without failure over a specified period under specified conditions?
- **Faultlessness** — degree to which the system is free from faults *(replaced Maturity — 2023)*
- **Availability** — system is operational and accessible when required
- **Fault Tolerance** — maintains operation despite hardware or software faults
- **Recoverability** — restores data and operations following interruption or failure

*ORD relevance:* how long the business tolerates losing the capability, how much completed work
it can afford to lose, what must still work in a degraded state, and what is breached beyond each —
never uptime percentages, MTBF, MTTR, RTO or RPO, which answer the demand. KPP candidates live here.

### 6. Security — ORD §7.3
Does the system protect information and data with appropriate access controls?
- **Confidentiality** — data accessible only to authorized parties
- **Integrity** — state and data protected from unauthorized modification or deletion
- **Non-repudiation** — actions can be proven to have taken place
- **Accountability** — actions traceable to the entity that performed them
- **Authenticity** — identity of subjects and resources can be verified
- **Resistance** — system sustains operations under attack *(NEW in 2023)*

*ORD relevance:* the compliance obligations that apply (FedRAMP, HIPAA, ISO 27001, PCI-DSS) and the
consequence of breach, who may see or change what, and what must be provable afterwards — never an
encryption algorithm, a penetration-test threshold or an access-control model, which answer it.

### 7. Maintainability — ORD §7.6
Can the system be effectively and efficiently modified without degrading quality?
- **Modularity** — change to one component has minimal impact on others
- **Reusability** — components can be used across products or contexts
- **Analyzability** — impact of intended changes can be assessed
- **Modifiability** — changes can be made without introducing defects

*ORD relevance:* how quickly a correction or a rule change reaches operation in business terms, the
change windows the business imposes, what must be diagnosable when something goes wrong, and what a
support function resolves without engineering — never a patching cadence or tooling choice.

### 8. Flexibility — ORD §7.5 *(formerly Portability — 2011)*
Can the system operate effectively in contexts not originally specified?
- **Adaptability** — adapts to different or evolving hardware, software, and usage environments
- **Installability** — can be successfully installed/uninstalled in specified environments
- **Replaceability** — can replace another specified product for the same purpose
- **Scalability** — handles growing or shrinking workloads; elastic capacity *(NEW in 2023)*

*ORD relevance:* the growth, peaks and new contexts the business expects — volumes, regions,
tenants, channels — and how much disruption an upgrade or a rollback may cause to operations —
never a hosting model, an elasticity mechanism or a deployment topology, which are the response's.

### 9. Safety — ORD §7.9 *(NEW top-level characteristic — 2023)*
Does the system protect against risk of injury or harm to people, property, or the environment?
- **Operational Constraint** — operational constraints prevent hazardous situations
- **Risk Identification** — hazardous situations and conditions are identified
- **Fail Safe** — system reaches a safe state on failure
- **Hazard Warning** — timely, effective warnings about hazards are provided
- **Safe Integration** — safe integration with other systems

*ORD relevance:* applicable to safety-critical systems (healthcare, infrastructure, industrial control). If not applicable, note explicitly.

---

## ISO/IEC 25059:2023 — AI Extension *(conditional)*

**Applies only where the trigger test in `~/.claude/standards/requirements/ai.md` fires** — a delivered
component whose output for a given input is not fully determined by written logic. 25059 sits inside
the same SQuaRE series as 25010 and **extends it**: it adds the sub-characteristics below and
inherits everything above unchanged. It is not a replacement taxonomy and does not restructure §7.

| Added sub-characteristic | Extends | Covers |
|---|---|---|
| **Functional Adaptability** | Functional Suitability (§7.8) | Behaviour holding as data, context or usage shifts from what the component was tuned on |
| **Robustness** | Reliability (§7.2) | Behaviour under out-of-distribution, adversarial or malformed input |
| **User Controllability** | Interaction Capability (§7.7) | The operator's ability to direct, constrain or halt the component |
| **Intervenability** | Interaction Capability (§7.7) | A named human's authority to override an output, and the point at which they can |
| **Transparency** | Interaction Capability (§7.7) | Output labelling, explanation of a decision, disclosure that a component is AI |

*ORD relevance:* every one of these needs a threshold on a named held-out `EVL-NNN` evaluation set,
a floor, and a review hook — see `standards/requirements/ai.md` § *The evaluative criterion*. Accuracy
and fairness are **not** new sub-characteristics: they are Functional Correctness measured the AI
way, which is why they sit under §7.8.2 Functional Correctness in TEMPLATE.md rather than here.

**Watch item (ADR-0003):** the 25059 second edition awaits member-body vote. Its AI *service*
quality model — traceability, service adaptability, customizability — is the part most relevant to
AI consumed as a service. Re-check before treating this patch as stable.

---

## 2011 vs 2023 Quick Reference

| Changed | 2011 | 2023 |
|---|---|---|
| Top-level count | 8 | 9 |
| New characteristic | — | Safety |
| Renamed | Usability | Interaction Capability |
| Renamed | Portability | Flexibility |
| New sub-characteristics | — | Inclusivity, Self-Descriptiveness, Resistance, Scalability |
| Replaced sub-characteristic | Maturity | Faultlessness |
| Replaced sub-characteristic | UI Aesthetics | User Engagement |
