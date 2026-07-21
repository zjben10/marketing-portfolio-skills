---
name: evaluate-event
description: >
  Scores conferences, trade shows, summits, and other events against a
  company's go-to-market strategy on a 6-criteria, 30-point rubric, then
  returns a verdict (Strong Pursue / Selective Pursue / Monitor / Skip)
  with rationale and specific action items. All company-specific context —
  ICP, segments, GTM phase, budget philosophy, geography, regional
  connections, and the current event calendar — lives in one editable
  profile file, so the same rubric adapts to any company.

  Trigger this skill when the user says things like: "evaluate this event",
  "score this conference", "should we attend/sponsor X", "is this event
  worth it", "rate this event", "go or no-go on this conference", "add this
  event to the tracker", shares an event URL or Eventbrite/Luma link, or
  asks about speaking opportunities at a specific event.
---

# Evaluate Event

## Overview

This skill scores an event on a 6-criteria rubric (1–5 each, 30 points
total) and returns a verdict with rationale and concrete action items. The
goal is fast, consistent go/no-go decisions so the team never re-derives
the logic from scratch.

The workflow below is company-agnostic. Every company-specific fact — who
the ICP is, what the segments are, which GTM phase you're in, how you think
about budget and geography, which events are already on the calendar —
lives in **one reference file**. To point this skill at a different
company, you edit that file, not this workflow.

Reference files:

- `references/company-profile.md` — the company's evaluation profile: GTM
  phases, segments, ICP personas, competitors, team capacity, budget
  philosophy, geography, regional connections, and the current event
  calendar. Start from `references/company-profile.template.md` and fill it
  in.

**Before scoring anything, read `references/company-profile.md` in full.**
Every criterion below anchors its scores to a section of that file.

---

## Step 1: Gather event facts

If the user provides a URL, **fetch it first** — do not score on the name
alone if real details are available. If they provide only a name, search
for it. Collect:

- Event name
- Date(s)
- Location (city, country)
- Industry / topic focus
- Event type (conference, tradeshow, expo, summit, workshop)
- Estimated size / audience profile (if available)
- Registration cost
- Sponsorship / speaking options and costs (if available)
- Any notes from the user about why they're considering it

If the event is fewer than ~2 weeks away and would require a CFP submission
or a sponsorship negotiation, flag that it may be **too late to act on**
before you score it.

---

## Step 2: Score on 6 criteria

Score each criterion 1–5 using the definitions below, anchoring every score
to the relevant section of `company-profile.md`. **Be honest. Do not
inflate scores to be nice.** A 3 is fine. A 2 is fine. Honest
differentiation is the entire point.

### 1. Strategic Fit (1–5)

Does this event align with the company's **current GTM phase** (see the
*GTM phases* section of the profile)?

- **5:** Directly serves the current pipeline motion. Attendees make or
  influence the decisions the product is built for. Broad segment coverage.
- **4:** Serves one core segment well. Decision-maker audience. Good timing
  relative to GTM milestones.
- **3:** Adjacent audience. Some ICP overlap. Timing is neutral.
- **2:** Tangential. Mostly wrong audience with a few relevant people.
- **1:** No strategic alignment.

Use the profile's GTM timeline to judge timing: events that seed awareness
just before a conversion window, or drive pipeline during one, score
highest.

### 2. ICP Coverage (1–5)

How many target accounts / personas attend? Use the *ICP personas* section
of the profile — **treat every listed persona category as equally ICP** unless
the profile says otherwise.

- **5:** Dominated by ICP roles from any of the profile's persona
  categories.
- **4:** Strong representation of ICP roles from one or more categories.
  Multiple target accounts likely attending.
- **3:** Some ICP roles present within a broader audience.
- **2:** ICP is a small minority of attendees.
- **1:** No meaningful ICP presence.

Apply any persona-scoring notes in the profile (for example, whether
adjacent roles such as investors, founders, or channel partners count as
ICP for this company). Do not score an event low just because the attendee
titles differ from your most obvious user — check the profile's definition
of who the buyer and influencer actually are.

### 3. ICP Composition (1–5)

What **percentage** of attendees are ICP? Composition matters more than raw
headcount.

- **5:** 50%+ ICP. Small, curated, high-density events.
- **4:** 30–50% ICP. Focused industry events.
- **3:** 10–30% ICP. Broader events with a relevant track or segment.
- **2:** 2–10% ICP. Large events where you have to hunt for the right
  people.
- **1:** <2% ICP. Needle in a haystack.

A 300-person event at 60% ICP outscores a 15,000-person event at 2% ICP.
Use the profile's persona-scoring notes when counting who is ICP.

### 4. Fuel & Engine Fit (1–5)

Can we create content and drive pipeline from this? (**Fuel** = the
content/assets an event lets you create. **Engine** = how you get people
there and follow up.)

- **5:** Speaking slot available. Content-creation opportunities (video,
  case study, demo). Can drive signups or meeting bookings. Positions the
  company across multiple segments.
- **4:** Speaking likely available. Good follow-up potential. Strong
  single-segment positioning.
- **3:** Attend-only is the likely mode. Some follow-up potential. Limited
  content creation.
- **2:** Networking only. Hard to create lasting assets.
- **1:** No content or pipeline potential.

### 5. Quality of Interaction (1–5)

What kind of conversations will we actually have? Hierarchy:
**speaking > sponsoring > booth > attending**, and **intimate/curated >
large trade-show floor**.

- **5:** Speaking slot (30+ min). Structured 1:1s. Intimate/curated
  setting. Demo opportunities.
- **4:** Speaking slot (lightning/panel). Good networking structure.
  Roundtables.
- **3:** Standard conference networking. Booth traffic. Breakout sessions.
- **2:** Large expo floor. Unstructured mingling. Hard to get quality time.
- **1:** Passive attendance. No interaction structure.

### 6. Cost / ROI Potential (1–5)

All-in cost vs. expected pipeline value. Anchor geography to the *Geography*
and *Regional connections* sections of the profile.

- **5:** Low cost, high expected conversations. Local or low-travel, or a
  team member is already in the area.
- **4:** Reasonable cost. Accessible home-region location. Clear path to 5+
  quality conversations.
- **3:** Moderate cost. Standard travel. 3–5 expected conversations.
- **2:** High cost relative to expected conversations. Distant/expensive
  travel or a costly sponsorship with uncertain ROI.
- **1:** Very expensive. Long-haul travel to a region with no pipeline.
  Poor cost/conversation ratio.

**Geography scoring:**

- **Home hubs** (see profile): low friction. Score 4–5 if the event itself
  is strong.
- **Other domestic cities:** moderate. Standard travel. Score 3–4.
- **International / long-haul:** do **not** apply a blanket penalty.
  Evaluate on two trip-justification criteria instead:
  1. **Client meetings around the event** — can the team book 3+ meetings
     with existing contacts, prospects, or pipeline accounts in the region
     on the same trip?
  2. **Event stacking** — is there another event within ~1–2 weeks and
     reasonable travel distance that could be combined into one trip?

  Score long-haul events:
  - Client meetings **and** stacking available → 3–5 (same as domestic)
  - Client meetings **or** stacking (one, not both) → 2–3
  - **Neither** → 1–2

  Check the profile's *Regional connections* section first — it lists known
  contacts and stackable anchors by region. Explicitly list the meetings or
  stacking opportunities you're relying on, or flag that you need the user
  to confirm whether meetings can be arranged.

---

## Step 3: Total and verdict

Sum the six scores and apply:

| Total  | Verdict           | What it means                                                                          |
|--------|-------------------|----------------------------------------------------------------------------------------|
| 25–30  | **Strong Pursue** | Actively seek speaking and/or sponsorship. Get budget-holder approval. Pre-book meetings. |
| 18–24  | **Selective Pursue** | Attend + seek speaking if low-cost. Worth targeted effort, not a major investment.  |
| 12–17  | **Monitor**       | Send 1 person if logistics are easy. Do not sponsor. Do not make a special trip.       |
| < 12   | **Skip**          | Does not justify time or budget.                                                        |

---

## Step 4: Rationale and action items

Every evaluation must include:

- **One-sentence summary** of why this event does or doesn't work.
- **Segments served** — map to the segment list in the profile.
- **Specific action items** — who should do what, by when, with what ask.
- **Stacking opportunities** — check the profile's event calendar; flag any
  event in the same city/week (confirmed or being pursued) to combine with.
- **Negotiation notes** — if sponsoring, which pieces of the package matter
  and what to drop (follow the profile's budget philosophy).
- **Trip justification** — long-haul events only: list known client
  meetings that could be booked around the event, stackable events in the
  region, and whether the trip pencils out. If you don't know whether
  meetings can be arranged, ask the user.

---

## Step 5: Present the score card

Output a clean card in this format:

```
EVENT: [Name]
DATE: [Date] | LOCATION: [City]
SEGMENTS: [List]

SCORES:
  Strategic Fit:          x/5
  ICP Coverage:           x/5
  ICP Composition:        x/5
  Fuel & Engine:          x/5
  Quality of Interaction: x/5
  Cost / ROI:             x/5
  TOTAL:                  xx/30

VERDICT: [Strong Pursue / Selective Pursue / Monitor / Skip]

RATIONALE: [One-sentence summary]

ACTION ITEMS:
- [Specific action 1]
- [Specific action 2]

STACKING: [Any nearby events to combine with]

TRIP JUSTIFICATION: [Long-haul only. Known client meetings, stackable
events, and whether the trip pencils out. If unknown, ask the user.]

NEGOTIATION NOTES: [If applicable]
```

---

## Scoring rules

- **Do not inflate scores.** Honest differentiation is the point.
- **Weight segments as the profile says** — equal unless the profile sets
  weights. Do not use sales-call or discovery ratios as evidence of segment
  importance; those samples are usually skewed.
- **Cross-segment events outscore single-segment events** at the same
  quality level — they spread exposure without concentrating the bet.
- **Always check for stacking.** If the event is within a week and travel
  distance of another event on the calendar, flag it.
- **Speaking > sponsoring > booth > attending.** Recommend pursuing
  speaking first. Only recommend a paid sponsorship if the package includes
  stage time and the audience density justifies the cost.
- **Note competitors.** If a competitor listed in the profile sponsors the
  event, call it out — it confirms ICP presence but also means head-to-head
  visibility.
- **Respect team capacity.** Factor in the profile's limit on events per
  month; every event has real opportunity cost.
- **Fetch URLs before scoring.** Don't score on the name alone if you can
  get real details.

---

## Live profile updates

At any point the user may share something that should become standing
context — a new contact in a region, a newly confirmed event, a change in
budget or GTM phase, a competitor to watch. Watch for phrases like:

- "We just confirmed [event]"
- "Add [contact/region] to the connections"
- "We're now sponsoring X" / "We dropped Y"
- "From now on, treat [persona] as ICP"

When you hear these, update `references/company-profile.md` and confirm the
change to the user so it carries forward next time.
