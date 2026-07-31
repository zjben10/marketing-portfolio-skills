---
name: ae-follow-ups
description: >
  AE follow-up agent. Runs a structured daily review of AE-stage deals:
  proposes stage corrections, triages open follow-up tasks, and drafts
  contextual follow-up emails for approval. Reads the active company's
  GTM Context Layer (positioning, ICP, value pillars, voice) so drafts
  are grounded in real strategy, not generic templates.

  Trigger this skill when the user says things like: "follow-ups",
  "pipeline review", "run my deals", "deal review", "who needs a
  follow-up", or anything suggesting they want to review and act on
  their AE-stage pipeline.
---

# AE Follow-ups

## Overview

Runs a structured pipeline review for AE-stage deals (Connected through
Legal, as defined by the active company's stage list). Surfaces stage
corrections, triages follow-up tasks, and drafts follow-up emails —
each draft grounded in the active company's Context Layer rather than
a fixed asset library.

**Data source:** All CRM data (deals, stages, tasks, contacts, threads)
comes through the `CrmClient` interface — a mocked/seeded data source in
this build, swappable for a real CRM integration later without changing
this skill.

**Context Layer:** Before drafting anything, read the active company's
Context Layer file (`/context/{company}.md`). This is what makes a
draft company-specific: positioning, ICP fit reasoning, value pillars,
voice/banned-phrases, and objection reframes all come from here, not
from hardcoded copy rules.

---

## Phase 1: Orient

Load the active company's pipeline snapshot via `CrmClient.getPipeline()`.
Present:

```
**Follow-ups. [Company]**

- [X] stage updates to review
- [X] deals with open follow-up tasks
- [X] reconnect reminders due
```

If everything is zero: "No follow-ups today. Pipeline is clean." End
session.

## Phase 2: Stage Corrections (batch)

Present any stage-correction candidates (e.g. a deal shows demo
activity but is still marked "Connected") in a table. Confirm in
batch — "y" to accept all, or call out exceptions ("skip 2, confirm
rest").

## Phase 3: Task Triage (the table)

Present all deals with open follow-up tasks in one table:

```
| # | Deal | Stage | Follow-up | History |
|---|------|-------|-----------|---------|
| 1 | [Deal] | Demo completed | 2nd | Demo'd [date], pricing question raised |
| 2 | [Deal] | Proposal sent | 3rd | No reply in 12 days |
```

Default: drafting all. User calls out exceptions:
`"Skip: 2. Reconnect: 3 in September. Rest: draft."`

- **Draft** (default) → queued for Phase 4
- **Skip** → mark task(s) complete, no draft
- **Lost** → move to closed-lost, ask for a brief reason
- **Reconnect** → set a reminder (default 6 months out if no date given)

## Phase 4: Drafting

For each queued deal:

1. **Read the Context Layer.** Pull positioning, the value pillar most
   relevant to this deal's stage/history, voice rules, and any
   applicable objection reframe.
2. **Read the deal history** via `CrmClient.getThread(dealId)` — prior
   emails, call summaries, notes.
3. **Classify conversation state**: active (<7 days) / cooling (7-14) /
   silent (14-21) / decision point (21+).
4. **Draft the email** — plain text, one continuous line per paragraph,
   one clear ask, sign-off with the invoking user's name. Voice and
   banned-phrase rules come from the Context Layer, not a fixed list.
5. **Present for approval**:

```
**Draft — [Deal], [Stage], [conversation state]**
*Reasoning: [which value pillar / objection reframe this draft uses, one line]*

[Subject]

[Body]

Best,
[User]

y / edit / skip
```

On approval: `CrmClient.createDraft()`, mark task(s) complete.

## Phase 5: Summary

```
**Follow-ups complete.**
- [X] stages corrected
- [X] drafts created
- [X] deals moved to Lost
- [X] reconnect reminders set
```

---

## Notes for this build

This is a genericized, single-user, mocked-data version of a
multi-user production skill. Deliberately dropped for v1: subagent
look-ahead prefetching, copy-performance logging, Slack session
reports, and live Gmail/CRM writes. The reasoning structure (stage
review → triage → context-grounded drafting) is the part worth
demonstrating; the operational plumbing around it is not.
