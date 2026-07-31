---
name: meeting-prep
description: >
  Generates a pre-meeting prep brief for an upcoming prospect or customer
  call. Pulls deal data from the CRM, finds the attendees from the calendar
  invite, researches each person's background, gathers company intelligence,
  and summarizes email and call history (last 180 days) — all grounded in the
  active company's Context Layer so talking points reflect real strategy.

  Trigger this skill when the user says things like: "prep me for the
  [company] meeting", "meeting prep for [deal]", "get me ready for my call
  with [company]", "brief me on [company] before the call", "create a meeting
  brief", "prep for tomorrow's demo", "meeting prep", "call prep", "meeting
  brief", "pre-call research", or anything suggesting they want a pre-meeting
  briefing for a prospect or customer call.
---

# Meeting Prep

## Overview

Creates a meeting prep brief that gets anyone on the team fully briefed before
a prospect or customer call. It pulls company context, attendee backgrounds,
communication history, and deal status into a single brief that someone with
zero context on the deal can read in five minutes and walk in informed.

**Data source:** All external data comes through the integration clients in
`lib/integrations.ts` — `CrmPort`, `CalendarPort`, `EmailPort`,
`ConversationPort`, and `ResearchPort`. These are mocked/seeded in this
build and swappable for real providers (Attio / HubSpot / Salesforce for the
CRM, Google for calendar + email, Gong for calls, LinkedIn + web for research)
without changing this skill.

**Context Layer:** Read the active company's Context Layer
(`/context/{company}.md`) for positioning, value pillars, ICP fit, and voice.
Talking points draw from here, not from hardcoded copy.

---

## Step 1: Identify the deal and meeting

The user references a deal, company, or meeting — e.g. "prep me for the
Meridian call."

1. `CrmPort.searchDeals(name)` → resolve the deal. Pull deal name, stage,
   owner, value, industry, associated company, associated people.
2. `CalendarPort.getUpcomingMeetings(companyId, 14)` → meetings in the next
   14 days for that company.
3. If multiple meetings are found, present them and ask which one. If none,
   ask the user for the meeting date/time and attendees.

### Smart ask

Check the meeting title. If the purpose is clear ("Demo", "Pricing Review",
"Technical Deep-Dive"), proceed. If ambiguous (just a company name, or
"Follow-up"), ask: "What's the focus — demo, pricing, technical review, or
something else?" Store the focus for the Talking Points section.

## Step 2: Gather attendees

1. Read `meeting.attendees` (from the calendar invite) plus any people on the
   CRM deal record.
2. Optionally `ConversationPort.search("[company] prep")` — prep-call
   transcripts often reveal who will attend and what they care about.
3. Split **external** attendees (prospect/customer contacts — these get full
   research) from **internal** ones (your own team — just list names). Use
   `CrmPort.getTeam()` to identify internal members. Note where an external
   attendee is a third party (consultant, partner) rather than an employee.

## Step 3: Research each external attendee

For each external attendee, `ResearchPort.findPerson(name, company)` →
title, LinkedIn URL, and a concise 1–2 sentence bio (current role + one
relevant detail, e.g. "Leads process engineering; likely technical
decision-maker."). If someone can't be found, note "background not found" and
move on — never block the whole brief on one person.

## Step 4: Company intelligence

Synthesize two sources:

1. `CrmPort` company record → description, size, industry.
2. `ResearchPort.companyIntel(name)` → recent news and technology/operations
   context.

Produce:
- **Company Background & Technology** (2 short paragraphs) — what they do,
  their scale, and the landscape they operate in, with the pain points that
  connect to the value pillars in the Context Layer.
- **Recent Activity** (3–5 bullets) — only items relevant to this deal or
  meeting. If nothing relevant, write "No significant recent news found."

## Step 5: Communication history (last 180 days)

- Notes and deal history: `CrmPort.getThread(dealId)`.
- Calls: `ConversationPort.search(company)` → transcripts/summaries.
- Emails: `EmailPort.searchThreads(domain, 180)`.

Condense into:
- **Communication Summary** (3–5 sentences), organized by theme, leading with
  what matters for the upcoming meeting. Call out pricing (numbers,
  objections), implementation (requirements, timelines), and open questions.
- **Pain Points** (bulleted, if a discovery/prep call exists) with bold
  lead-ins.
- **Relationship Timeline** (3–6 compact `[date] [one line]` items).

## Step 6: Assemble the brief

Compile into the meeting brief, following the Context Layer's voice and
banned-phrase rules. Sections, in order: Company Background & Technology;
Attendees (external with bios, internal listed); Recent Activity;
Communication Summary; Pain Points; Relationship Timeline; Talking Points.

**Talking points** connect specific pain points to the value pillars from the
Context Layer — woven in naturally, not listed as features.

Render the brief in-app. It can also be exported to a branded `.docx` via the
`docx` skill when a hard copy is needed.

---

## Handling edge cases

- **No deal found:** ask for the company name and build a web-research-only
  brief; skip deal-specific fields.
- **No meeting found:** ask for meeting details and build it anyway — still
  useful as a company brief.
- **No communication history:** note it and offer to include anything the user
  pastes.
- **Multiple deals for one company:** present options and ask which one.
- **Attendee not found:** include with "background not available" rather than
  blocking.

## Closing

Present the brief with a one-line summary of what's in it, then ask: "Anything
you'd like me to add or change before your call?"

---

## Notes for this build

Genericized, single-user, mocked-data version. The reasoning structure
(resolve deal + meeting → attendees → research → company intel → comms history
→ brief) is the part worth demonstrating; the live CRM / calendar / email /
call / research reads all go through `lib/integrations.ts`, so wiring real
providers is an adapter swap, not a rewrite of this skill.
