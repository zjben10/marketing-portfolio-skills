# Event Evaluator — a Claude Skill

A [Claude skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
that scores conferences, trade shows, and summits against a company's
go-to-market strategy and returns a go/no-go verdict with rationale and
action items.

Adapted from a skill I built and ran in production for a marketing team. All
company-specific content has been pulled out into a single editable profile,
so the same rubric works for any company.

## What it does

Give it an event — by name, URL, or description — and the skill:

1. Gathers the facts (fetches the URL if you give it one)
2. Scores the event on a **6-criteria, 30-point rubric**: Strategic Fit,
   ICP Coverage, ICP Composition, Fuel & Engine Fit, Quality of
   Interaction, and Cost / ROI
3. Assigns a verdict — **Strong Pursue / Selective Pursue / Monitor /
   Skip** — and returns a clean score card with rationale, action items,
   stacking opportunities, and (for long-haul events) trip justification

It's built for honest differentiation, not score inflation — the point is to
make consistent go/no-go calls without re-deriving the logic every time.

## How it's organized

```
event-evaluator/
├── SKILL.md                    # the rubric + workflow (company-agnostic)
└── references/
    └── company-profile.md      # your company's profile (ships as a template)
```

The workflow in `SKILL.md` never changes. To point it at your company, you
only edit one file.

## Customizing it for your company

`references/company-profile.md` ships as a template. To adopt the skill:

1. Open `references/company-profile.md`
2. Fill in every `[BRACKET]` and `<!-- FILL IN -->` block: what the company
   is, your GTM phases, segments, ICP personas, competitors, team capacity,
   budget philosophy, geography, regional connections, and your event
   calendar
3. That's it — the skill reads `company-profile.md`

The template is self-documenting: every section has inline `e.g.` examples
showing the shape and level of detail to aim for, so you can see how a
completed profile should read without a separate sample company.

## Design notes

A few choices worth calling out:

- **Company facts live in data, not logic.** `SKILL.md` has zero hardcoded
  company facts — no company name, no ICP, no event list. Swapping companies
  is a one-file edit, not a rewrite.
- **Honest scoring by design.** The rubric explicitly tells the reviewer not
  to inflate scores. A 3 is a fine answer. Consistent differentiation is the
  whole value.
- **Geography without a blanket penalty.** Long-haul events aren't
  auto-penalized. They're judged on real trip justification — can you book
  client meetings and stack a second event on the same trip?
- **Self-updating profile.** New confirmed events, regional contacts, or
  budget/GTM changes get written back into the profile, so the skill's
  context stays current the more you use it.
