# Discovery Recap 1-Pager — a Claude Skill

A [Claude skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview)
that turns a discovery-call transcript into a co-branded, single-page PDF a
prospect can forward internally to greenlight a demo.

Adapted from a skill I built and ran in production. All company-specific
positioning has been pulled out into a single editable context file, so the
same workflow works for any product.

## What it does

Give it a prospect URL and a call transcript, and the skill:

1. **Reads the transcript** for disclosed pains — time waste, resource
   blockers, seasonal crunch, tool pain, internal-champion struggles — and
   keeps only what the prospect actually said (not inferred).
2. **Discovers the prospect's brand** from their site (colors, type, vibe)
   and injects those tokens into the doc's CSS, so it feels native to *their*
   world. Your brand is a thin accent only.
3. **Maps pains → use cases** — exactly 3 cards, each with a "Maps to" line
   that names the prospect's own pain. That line is the trust signal: it
   proves you listened.
4. **Builds a one-page PDF** — headless-browser render, no hosting, no deploy.

It replaces the boilerplate "thanks for your time, here's our deck"
follow-up with a personalized leave-behind that gives the prospect's internal
champion something to circulate.

## How it's organized

```
discovery-call-recap/
├── SKILL.md                    # the workflow (company-agnostic)
├── company-context.md.example  # your product context (copy → company-context.md)
├── assets/
│   ├── template.html           # the 1-pager layout, with {{PLACEHOLDERS}}
│   └── template.css            # layout + the 5 brand tokens injected per prospect
└── scripts/
    └── build.sh                # HTML → single-page PDF (cross-platform)
```

The workflow in `SKILL.md` never changes. To point it at your product, you
only edit `company-context.md`.

## Customizing it for your product

1. Copy `company-context.md.example` to `company-context.md`
2. Fill in every `[BRACKET]` and `<!-- FILL IN -->` block: your one-liner,
   the use cases the generator may pick from, competitors, pricing guardrail,
   allowed proof points, the "never claim" list, fallback brand colors, and
   your team roster for the byline
3. That's it — the skill reads `company-context.md`

Keep your filled-in `company-context.md` out of version control (it's in
`.gitignore`). Only the `.example` template ships publicly.

## Building the PDF

```bash
bash scripts/build.sh "<outputs>/discovery-recaps/{date}-{slug}-onepager"
```

Requirements (one-time per machine): a Chrome/Chromium/Edge browser and
Python 3. The script starts a local server, renders `index.html` to a
single-page PDF, and stops the server — nothing gets hosted. It detects the
browser binary across macOS, Linux, and WSL rather than hardcoding a path.

## Design notes

A few choices worth calling out:

- **Product facts live in data, not logic.** `SKILL.md` has zero hardcoded
  positioning — no product name, no use cases, no proof points. Swapping
  products is a one-file edit.
- **Only what they said.** The skill tracks disclosed vs. inferred pains and
  drops the inferred ones unless high-confidence. Credibility comes from
  naming things only the prospect themselves raised.
- **Co-branding, not co-opting.** The doc renders in the prospect's palette
  and type; your brand is a thin accent. The five brand tokens are the only
  per-prospect CSS edit.
- **Honorable guardrails.** No verbatim quotes, no pricing unless the context
  doc allows it, no fake proof points, no roadmap/SLA commitments, and no
  naming a demo owner without confirming their calendar first.
- **One page, hard limit.** If content overflows, the skill cuts copy rather
  than shrinking type past legibility.
