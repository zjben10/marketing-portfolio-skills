---
name: discovery-call-recap
description: Generates a co-branded post-discovery-call 1-pager for a B2B sales prospect. Takes a call transcript and prospect URL, and produces a single-page PDF styled in the prospect's brand. Use after a discovery call when a prospect needs an artifact to circulate internally before greenlining a demo. Trigger this skill when the user says things like "post-call 1-pager", "discovery recap", "build a 1-pager for [prospect]", "post-meeting onepager", "co-branded leave-behind", "recap doc for [company]". Strict triggers only. Explicitly excludes "meeting prep", "call prep", "pre-call research", "brief me on [company]" (belongs to a meeting-prep skill). Excludes "send proposal", "send contract" (belongs to a proposal skill). Excludes "AE replies", "draft a reply to [company]" (belongs to an ae-replies skill — no artifact generation).
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch
---

# Discovery Recap 1-Pager

Generates a co-branded post-discovery-call 1-pager PDF that a prospect will forward internally to greenlight a demo. The doc echoes pains the prospect disclosed on the call and maps them to your product's use cases, in the prospect's brand language.

This replaces the boilerplate "thanks for your time, here's our deck" follow-up with a personalized artifact that makes the prospect feel heard and gives their internal champion ammunition.

**Skill bundle path** — throughout this doc, `<skill-path>` refers to this skill's own directory inside wherever it's installed (the folder containing this SKILL.md).

## Setup: Your Company Context (Required)

This skill is context-driven — it has no company baked in. Before first use, copy `<skill-path>/company-context.md.example` to `<skill-path>/company-context.md` and fill it in with plain-language answers about your product, use cases, competitors, pricing rules, proof points, and team. It's a fill-in-the-blank doc, not structured data — anyone on the team should be able to complete it without touching code.

Keep the filled-in `company-context.md` out of version control (add it to `.gitignore`) — the `.example` file is what ships in the public repo.

If `company-context.md` doesn't exist yet or looks incomplete, stop and ask the user to fill it in rather than guessing at positioning — inventing product claims is worse than asking. If they'd rather answer questions out loud than fill out the file, that's fine too: interview them for the same information and write `company-context.md` for them before continuing.

## When to Use This Skill

- Just finished a first discovery call with a prospect
- Prospect has soft interest but needs to circulate internally before committing to demo
- A deal moves to a "post-first-call" stage and needs an artifact attached

## Inputs Required

1. **Prospect company URL or name** — primary input. Used for (a) finding the most recent discovery call transcript, (b) brand discovery (colors, typography, logo language, tagline).
2. **Call transcript** — auto-fetched from your CRM in Step 0 below if it's connected; otherwise the user pastes one directly.
3. **(Optional) Prospect contact name + role** — for header metadata. If not provided, infer the primary non-vendor speaker from the transcript.
4. **(Optional) Stage of the deal** — e.g. "first call, soft interest" vs. "second call, technical evaluation." Affects how aggressive the next-step ask should be.
5. **Who's running this skill** — resolved against the team list in `company-context.md` for the "Prepared by" byline. Falls back to prompting at runtime.

## Step 0: Resolve the Transcript from Your CRM

If a CRM MCP connector is available (Attio, HubSpot, Salesforce, etc.), use whatever tools it exposes for record search and call-recording lookup. This skill doesn't assume a specific CRM — adapt the calls below to whichever MCP tools are actually connected.

**Pattern (CRM-agnostic):**

1. **Resolve the company by domain.** Strip the prospect URL to its registrable domain (e.g. `https://example.com/about/` → `example.com`). Search your CRM's company records for that domain. Confirm the match against the company's domain field — don't accept a substring match. Save the resolved company/record ID.
2. **Find the most recent call recording linked to that company.** Query your CRM's call-recording search, filtered to the resolved company ID, ordered most-recent-first. Take the first result — unless it's suspiciously old (>30 days) and the user just said "the call we had," in which case confirm which call.
3. **Fetch the full transcript.** Only proceed if the transcript status is finished/complete. If it's still processing, tell the user and offer to retry shortly. If fetch fails entirely, fall back: *"I couldn't pull a transcript automatically — paste it and we'll continue."*

**Edge case — multi-call deals.** If the user references a specific call ("the technical demo call," "the call with Jordan," a date), scan recording metadata (titles, timestamps, participants) to find the right one. When in doubt, surface the top 2–3 candidates and let the user pick.

If no CRM connector is available at all, skip straight to the user pasting a transcript.

## Step 1: Read the Prospect's Transcript

Read the full transcript carefully. Look for:

- **Time waste** — phrases like "takes 2-3 weeks," "stuck waiting on," "spend half a day"
- **Resource blockers** — "have to bring in," "depends on," "only one person who knows"
- **Cyclical/seasonal pain** — "during summer," "every quarter when," "when X is out"
- **Competitive pressure** — explicit competitor names + how they win/lose
- **Handoff friction** — multi-step workflows where things drop
- **Internal-champion struggles** — "my CFO needs to see," "have to convince leadership"
- **Tool pain** — "we use [tool] but...," "spreadsheet hell," "no source of truth"

**Output of this step:** a private working list of 5–10 raw pain themes with the transcript timestamp/quote that grounds each one. Do not quote the prospect verbatim in the final doc — paraphrase to professional, third-person language. Internally track which themes are *real* (disclosed) vs. *inferred*, and drop the inferred ones unless high-confidence. The doc's credibility comes from naming things only the prospect themselves said.

## Step 2: Discover the Prospect's Brand

`WebFetch {prospect_url}` with a prompt like:

*"Extract the visual brand identity: primary brand colors (hex if visible), accent colors, typography style (serif/sans, weight, feel), logo treatment (wordmark/icon), tagline, and overall aesthetic vibe (corporate/technical/modern/traditional)."*

Also fetch their `/about` or `/who-we-are` page if it exists — more brand voice + positioning tends to show up there.

**Output of this step:** brand tokens to inject into the CSS:

- `--primary` (their main brand color, usually dark)
- `--primary-deep` (slightly darker variant)
- `--primary-soft` (light tint, ~12% mix with white)
- `--accent` (secondary brand color for callouts)
- `--accent-soft` (light tint of accent)

If the prospect's site doesn't give a clean read, fall back to whatever neutral default colors you set under "Fallback brand colors" in `company-context.md`. Don't hardcode a fallback palette into this file — keep it in the context doc so it's yours to change.

## Step 3: Map Pains → Use Cases (3 Cards Max)

This is the highest-judgment step. The 1-pager has exactly 3 use-case cards.

**Pick from the use cases listed in `company-context.md`** — don't invent new ones. The card content (title, description) gets tailored to the prospect's language, but the underlying use case must be one from your config.

**Use-case framing rule:** each card has a title (their language) + 2–3 sentence description + a "Maps to" line that names the prospect's pain explicitly. The "Maps to" line is the trust signal — it proves you listened.

**If more than 3 pains map well:** pick the 3 that connect to the strongest planned next step (the demo). The rest can go in the email body or get saved for the next call.

**It's fine to have all 3 cards map to the same broad use case** if only one genuinely fits — better to triple down on one strong fit than spray across categories that don't land.

## Step 4: Decide Whether to Include an Optional Framing Band

Some products have a natural "stage" or "maturity" framing (e.g. a lifecycle, a phase model, a tiering) worth surfacing visually if it's described in `company-context.md`. Include it if:

- It's genuinely relevant to how this prospect is evaluating you
- The doc has room (it shouldn't push content onto a second page)

Skip it if the prospect's situation doesn't map to it, or the doc is already content-heavy. When in doubt, include it — a good framing band is often the strongest signal to a technical buyer that you understand their world. If `company-context.md` says "N/A" here, skip this step entirely.

## Step 5: Write the Doc

Build a working folder under wherever your outputs directory is configured to be:

```
<outputs>/discovery-recaps/{YYYY-MM-DD}-{prospect-slug}-onepager/
```

Create the directory if it doesn't exist. This folder is a build intermediate, not a deliverable — the HTML/CSS exist only to get you a styled PDF in Step 8, they're not shipped to the prospect or hosted anywhere. Files to write into that folder:

- `index.html` — copy from `<skill-path>/assets/template.html`, fill placeholders
- `styles.css` — copy from `<skill-path>/assets/template.css`, inject brand tokens

**Placeholders in template.html** (search-and-replace):

- `{{PROSPECT_NAME}}` — uppercase wordmark
- `{{PROSPECT_NAME_TITLE}}` — title case for "Prepared for"
- `{{PROSPECT_DESCRIPTOR}}` — short tag under wordmark
- `{{CALL_DATE}}` — ISO date
- `{{CONTACTS}}` — "P. Lastname × {AUTHOR_INITIALS}"
- `{{DOC_TITLE}}` — H1, sentence case, ends with a period
- `{{DOC_SUBTITLE}}` — one-sentence framing
- `{{HEARD_ITEM_1_LABEL}}` / `{{HEARD_ITEM_1_BODY}}` × 3 — pain-theme cards
- `{{USE_CASE_1_TITLE}}` / `{{USE_CASE_1_DESC}}` / `{{USE_CASE_1_MAPS_TO}}` × 3 — use-case cards
- `{{FRAMING_BAND_*}}` — optional band cells, if used
- `{{NEXT_STEP_*}}` × 4 — next-step cards
- `{{AUTHOR_NAME}}` / `{{AUTHOR_EMAIL}}` / `{{AUTHOR_TITLE}}` — runtime values (see Step 6)

The framing band is optional (Step 4). If you're skipping it, delete the whole `<!-- FRAMING BAND -->…<!-- /FRAMING BAND -->` block from `index.html` rather than leaving empty cells.

## Step 6: Resolve Author (Dynamic)

The "Prepared by" byline at the footer comes from whoever is running the skill.

1. Read the "Our team" section of `company-context.md`.
2. Match the current user. Best signals, in order: (a) user identity visible in context, (b) `git config user.email`, (c) prompt the user directly, listing the names from the context doc.
3. Use the matched name/email/title. If no match, prompt for name + email and offer to add them to `company-context.md` (and remind them to commit the update if they want it persisted for the whole team).

Never assume a specific person by default — most sales teams have more than one seller.

## Step 7: Guardrails

1. **Echo pains in their language, paraphrased.** Never quote verbatim.
2. **One page. Hard limit.** If content overflows, cut — don't shrink type below 9.5px.
3. **No pricing**, unless `company-context.md` explicitly says otherwise under "Pricing — what's safe to say?"
4. **No fake proof points.** Only cite what's listed under "Proof points we're allowed to use." Use shape-of-deal references ("a customer with a $50M project") if you don't have permission to name names.
5. **Demo asks must be honorable.** If naming a specific person for the demo, confirm calendar availability before sending. Otherwise write something generic like "a member of our technical team."
6. **Co-branding, not co-opting.** Use the prospect's color + typography to make the doc feel native to *their* world. Your brand is a thin accent only.
7. **No claims of authority you don't have.** No roadmap promises, no pricing commitments beyond what's in the context doc, no SLA language. Check "Things we must never claim" before writing anything that sounds like a commitment.

## Step 8: Build the PDF

Run the bundled build wrapper, passing the working folder you just wrote:

```bash
bash <skill-path>/scripts/build.sh "<outputs>/discovery-recaps/{YYYY-MM-DD}-{prospect-slug}-onepager"
```

The script:

1. Starts a local HTTP server on a free port (so the headless browser can load the HTML with relative CSS paths intact)
2. Renders the HTML → a single PDF file (`{prospect-slug}-onepager.pdf`) via a headless browser
3. Stops the local server
4. Leaves the PDF in the same working folder — no deploy step, no hosting

**Cross-platform note:** `scripts/build.sh` detects an installed Chrome/Chromium/Edge binary across macOS, Linux, and WSL rather than hardcoding a path — a hardcoded macOS Chrome path was the single most brittle part of the original implementation. If you extend the script, keep the detection list rather than pinning one path.

**First-run dependencies** (one-time per machine): a headless-capable Chromium-family browser, and Python 3 to run the local server for the render step. If either is missing, the script fails with a clear instruction message rather than silently breaking the build.

## Step 9: Report

Return to the user:

- PDF file path
- Quick summary: which pains mapped to which use cases (one line each)
- Anything flagged but not included (over-3-pain overflow, weak-fit use cases, etc.)
- Honest confidence call-out: which extracted pains were direct quotes vs. inferred

## What This Skill Does Not Do

- Long-form proposals or SOWs
- Internal-only deal briefs / CRM notes
- Demo decks — the recap is the *invitation* to the demo
- Pricing artifacts beyond the soft guardrail in your config
- Pre-call prep docs (that's a separate meeting-prep skill)

## Gotchas

- **`<skill-path>` is a placeholder**, not a literal env var — expand it to wherever this skill actually lives when you write real commands.
- **`company-context.md` is the single source of truth for anything company-specific.** If you find yourself typing your product's positioning directly into a step above, stop — put it in the context doc instead.
- **Don't commit your real `company-context.md`.** Only the `.example` template should be in the public repo.
- **The outputs folder must persist on disk** for the local server + headless-render step to work from it — don't write to a temp scratchpad.
- **Chrome/browser path is platform-specific** — `scripts/build.sh` handles detection; see Step 8.
