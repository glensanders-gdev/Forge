Invoke the testplan skill. Design the testing strategy — classify behaviours as automated or manual, identify critical path items, define what is explicitly not tested.

Feature mode (default): reads the active PRD, saves to docs/testplan-[feature].md.
Operational mode (--operational): reads the ORD register, triages every requirement by verification venue, saves to docs/testplan-operational.md once per release.

Feeds into /tdd and /qa-plan.

Skill: global/.claude/skills/testplan/SKILL.md
