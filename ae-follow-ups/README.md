# AE Follow-ups — a Claude Skill

A [Claude skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
that runs a structured daily review of an AE's pipeline: it proposes stage
corrections, triages open follow-up tasks, and drafts contextual follow-up
emails for approval.

Adapted from the skill that powers the Sales Copilot demo app. Every draft is
grounded in the active company's GTM Context Layer — positioning, value
pillars, voice, and objection reframes — so the output reads like real
strategy, not a generic template.

## What it does

Ask for a pipeline review and the skill:

1. **Orients** — pulls a pipeline snapshot: stage updates to review, deals with
   open follow-up tasks, and reconnect reminders due
2. **Proposes stage corrections** — flags deals whose recent activity implies a
   later stage than their label (e.g. demo activity on a deal still marked
   "Connected") and confirms them in a batch
3. **Triages tasks** — lays every open follow-up in one table so you can call
   exceptions in a single line (`"Skip: 2. Reconnect: 3 in September. Rest: draft."`)
4. **Drafts** — for each queued deal, reads the deal history, classifies the
   conversation state (active / cooling / silent / decision point) from
   days-since-activity, and writes a follow-up email with one clear ask, then
   presents it for `y / edit / skip`
5. **Summarizes** — reports what changed: stages corrected, drafts created,
   deals moved to Lost, reminders set

## How it's organized

```
ae-follow-ups/
└── SKILL.md    # the 5-phase workflow (orient → corrections → triage → draft → summary)
```

CRM data (deals, stages, tasks, contacts, threads) flows through a single
`CrmClient` interface, so the same workflow runs against seeded demo data or a
real CRM without editing the skill.

## Design notes

- **Grounded, not templated.** Voice, banned phrases, value pillars, and
  objection reframes come from the company Context Layer, not hardcoded copy —
  so the same skill sounds different (and correct) for a different company.
- **Batch-first interaction.** Corrections and triage are confirmed in bulk
  with exceptions called out, so a full pipeline pass is a few lines of input,
  not a deal-by-deal interrogation.
- **One seam to production.** Swapping the mocked `CrmClient` for a live CRM
  integration is an adapter change; the review-and-draft reasoning stays put.
