# Meeting Prep — a Claude Skill

A [Claude skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
that builds a pre-meeting brief for an upcoming prospect or customer call —
company context, attendee backgrounds, communication history, and deal status
in one place, so anyone can walk in informed after a five-minute read.

Adapted from the skill that powers the Sales Copilot demo app. Talking points
are grounded in the active company's GTM Context Layer, so they reflect real
positioning rather than a feature list.

## What it does

Ask it to prep you for a call ("prep me for the Meridian call") and the skill:

1. **Resolves the deal and meeting** — finds the deal in the CRM and the
   matching calendar invite; asks which one if there are several, or for the
   details if there are none
2. **Gathers attendees** — pulls them from the invite and the deal record, then
   splits external contacts (full research) from internal teammates (just
   listed)
3. **Researches each external attendee** — title, LinkedIn, and a 1–2 sentence
   bio, never blocking the brief on one person it can't find
4. **Assembles company intelligence** — background, scale, and recent activity
   relevant to the deal, tied back to the value pillars
5. **Summarizes 180 days of communication** — notes, calls, and emails
   condensed into a themed summary, pain points, and a compact relationship
   timeline
6. **Writes the brief** — company background, attendees, recent activity, comms
   summary, pain points, timeline, and talking points, in the company's voice

## How it's organized

```
meeting-prep/
└── SKILL.md    # the 6-step workflow (resolve → attendees → research → intel → history → brief)
```

External data (CRM, calendar, email, calls, research) flows through typed
integration ports, so the same workflow runs against seeded demo data or real
providers (HubSpot / Attio / Salesforce, Google, Gong, LinkedIn + web) without
editing the skill.

## Design notes

- **Readable by anyone.** The brief is written so a teammate with zero context
  on the deal can lead the call — the value is the synthesis, not raw data.
- **Never blocks on a gap.** A missing attendee bio or empty comms history is
  noted and skipped, not a dead end.
- **Ports, not integrations.** Each external source sits behind a typed port,
  so pointing the brief at real tools is an adapter swap, not a rewrite.
- **Exportable.** The brief renders in-app and can be handed to the `docx`
  skill for a branded, printable copy.
