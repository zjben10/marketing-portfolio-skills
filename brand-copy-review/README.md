# Brand Copy Review — a Claude Skill

A [Claude skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
that reviews and rewrites outbound copy (LinkedIn messages, cold emails,
follow-ups, one-pagers) to match a brand's voice and messaging rules.

Adapted from a skill I built and ran in production. All brand-specific
content has been pulled out into a single editable style guide, so it works
for any brand.

## What it does

Paste a draft into chat and the skill:

1. Asks what channel the copy is for (LinkedIn / cold email / follow-up / one-pager)
2. Reviews it against a brand style guide — voice, value props, writing
   rules, banned language, approved phrases
3. Returns a clean rewrite plus a short list of what changed
4. Learns: if you give it a permanent style rule ("we never say X anymore"),
   it writes that back into the style guide so it sticks next time

The review checklist runs silently — the user just gets the rewrite and a
tight summary, not a wall of scoring.

## How it's organized

```
brand-copy-review/
├── SKILL.md                          # the workflow (brand-agnostic)
└── references/
    ├── style-guide.md                # example brand, so it runs on clone
    └── style-guide.template.md       # blank template — start here for your brand
```

The workflow in `SKILL.md` never changes. To point it at your brand, you
only edit one file.

## Customizing it for your brand

1. Copy `references/style-guide.template.md` over `references/style-guide.md`
2. Fill in every `[BRACKET]` and `<!-- FILL IN -->` block: your one-liner,
   voice, value pillars, writing rules, banned language, approved phrases
3. That's it — the skill reads `style-guide.md`

The included `style-guide.md` is a filled-in example for a made-up brand
("Northwind") so you can see the shape and try the skill immediately.

## Design notes

A few choices worth calling out:

- **Brand rules live in data, not logic.** The skill file has zero
  hardcoded brand facts. Swapping brands is a one-file edit, not a rewrite.
- **Silent checklist.** The reviewer reasons through a full rubric but only
  surfaces the rewrite plus what changed — the output stays usable.
- **Self-updating guide.** Permanent feedback is written back to the style
  guide, so the skill gets more on-voice the more you use it.
- **Channel-aware.** Length, structure, and CTA conventions shift based on
  where the copy is going.
