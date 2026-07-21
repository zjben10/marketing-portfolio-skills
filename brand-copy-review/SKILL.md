---
name: review-copy
description: >
  Reviews and rewrites outbound copy to match a brand's voice, style, and
  messaging rules. Takes a draft (pasted into chat) and rewrites it to align
  with a brand style guide — checking tone, value props, banned language,
  writing rules, and channel-appropriate conventions.

  Trigger this skill when the user says things like: "review this copy",
  "rewrite this", "check this against the style guide", "does this follow
  our rules", "clean up this message", "review copy", "fix this draft",
  "make this sound like us", "check my copy", "rewrite this email",
  "rewrite this LinkedIn message", or anything suggesting they want a piece
  of outbound copy reviewed and rewritten to match their brand voice.
---

# Review Copy

## Overview

This skill takes a draft of outbound copy (pasted into chat by the user),
checks it against a brand style guide, and produces a clean rewrite that
matches the brand voice and rules.

To adapt this skill to your brand, edit the one reference file — you don't
touch the workflow below.

Reference files:

- `references/style-guide.md` — the brand's copy and style guide
  (voice, tone, value props, writing rules, banned language, approved
  phrases). Start from `references/style-guide.template.md` and fill it in.

---

## Step 1: Receive the draft

The user will paste their draft copy directly into chat. If they haven't
provided any copy yet, ask: "Paste the draft you'd like me to review and
I'll rewrite it to match the style guide."

---

## Step 2: Ask for channel context

Ask the user what channel this copy is for. This determines which
conventions to apply. Typical options:

- **LinkedIn message** — short (under ~300 chars for connection requests,
  under ~500 for follow-ups), conversational, no subject line
- **Cold email** — concise subject line, scannable body, one clear CTA,
  professional but human
- **Follow-up email** — reference prior context, add new value, don't just
  "bump"
- **One-pager / document** — can run longer and more structured, still
  matches voice and tone
- **Other** — let the user specify

Store the channel choice — it affects rewrite decisions in Step 3. If the
style guide defines its own channel conventions, defer to those.

---

## Step 3: Review and rewrite

Read `references/style-guide.md` and evaluate the draft against every
section. Then produce a rewrite.

### Review checklist (internal — don't show this to the user)

Run through each of these silently. Don't list them out — use them to
inform the rewrite:

1. **Voice and tone** — Does it match the brand's defined voice? Right
   level of confidence, warmth, and technical register for the audience?
2. **Writing rules** — Follows the brand's formatting, grammar, and
   punctuation conventions? Honors any hard rules (e.g. banned characters,
   CTA style, topics that are off-limits)?
3. **Banned language** — Check against every banned opener, CTA, subject
   line, and cliché in the guide. Flag and replace any matches.
4. **Value props** — Using the right value pillar for the context? Is the
   positioning accurate? Is the one-liner correct?
5. **Approved phrases** — Could any phrasing be upgraded to the brand's
   preferred language?
6. **Red flags** — Is it about the reader, not about us? One clear CTA?
   Does it add value? Professional but human? Clean grammar?
7. **Channel fit** — Length, structure, and tone right for the channel
   from Step 2?

### Rewrite approach

- Preserve the user's intent and core message
- Fix anything that violates the style guide
- Tighten the language — cut filler, make it more direct
- Swap banned language for natural alternatives
- Keep the CTA low-pressure (a question or an offer, not a demand)
- Keep the rewrite the same length or shorter than the original
- Match the channel conventions from Step 2

---

## Step 4: Present the rewrite

Present the output in this format:

---

**Channel:** [channel from Step 2]

**Rewrite:**

> [The rewritten copy, formatted appropriately for the channel]

**What I changed:**
- [Brief bullet list of the key changes and why — e.g., "Replaced banned
  opener 'Wanted to reach out' with a direct hook", "Shortened to fit the
  LinkedIn character limit", "Swapped an em dash for a comma"]

---

Do NOT show the full review checklist or scores. Keep it clean and
actionable — just the rewrite and a short summary of what changed.

---

## Step 5: Handle feedback

After presenting the rewrite, wait for the user's response.

**If they approve it** — say something brief like "Good to go." and end.

**If they want changes** — revise based on their feedback and present again
in the same format.

**If they give permanent style feedback** — if the user says something that
should become a standing rule (e.g., "we never say X anymore, use Y",
"add that phrase to the approved list", "that CTA style is better, remember
it"), then:

1. Acknowledge the feedback
2. Apply it to the current rewrite
3. Update `references/style-guide.md` with the change
4. Tell the user the guide has been updated so it carries forward next time

**Permanent vs. one-off:** If the user frames it as a general rule
("we never...", "always...", "add this to...", "from now on..."), treat it
as permanent and update the guide. If it's specific to this draft ("make
this one shorter", "swap that word here"), treat it as a one-off edit.

---

## Live copy feedback

At ANY point during this skill, the user may give permanent copy or style
feedback that should be saved to the guide. Watch for phrases like:

- "Add that to the style guide"
- "We don't say X anymore"
- "From now on, always..."
- "Update the style guide"
- "Remember that for next time"

When you hear these, update `references/style-guide.md` and confirm the
change to the user.
