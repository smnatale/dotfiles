---
name: unslop
description: Cut AI tells from any writing. Must always apply.
disable-model-invocation: false
---

# Unslop

Edit text to remove AI patterns and add a human voice.

# Process

Scan for the patterns below. Rewrite, keeping the meaning and the intended tone. Layer in the deslopped effect (next section). Then do one more pass and ask yourself: what gives this away as AI-written? Fix whatever you find.

# The deslopped effect

Have opinions. React to what's actually going on instead of listing pros and cons like a spec sheet. Vary the rhythm - a short sentence, then one that runs longer because it's earned it. Use "I" when it's genuinely your view; first person isn't unprofessional, it's just honest. Let a little mess in, since flawless symmetry is what gives away a machine. And be specific: not "this is concerning" but "there's something unsettling about agents churning away at 3am."

## Patterns to detect and fix

### Content

Puffery is the one everyone's seen a thousand times: "pivotal moment," "testament to," "evolving landscape," "setting the stage for," "indelible mark," "deeply rooted." It says nothing. Cut it and state what happened.

Name-dropping without follow-through is close behind it - a list of media outlets that "covered the story," with no indication of what any of them actually said. Pick one and quote it.

Superficial -ing phrases ("highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...") are usually padding tacked onto the end of a sentence to make it sound like more happened. Delete them, or replace with a real source if there's actually something to cite.

Promotional language - "nestled," "vibrant," "breathtaking," "groundbreaking," "renowned," "stunning," "must-visit" - belongs in ad copy, not description. Say what the thing actually is.

Vague attribution ("experts believe," "industry reports suggest," "some critics argue") is a tell that nobody specific said anything. Name the source, or delete the claim.

And "despite challenges, X continues to thrive" is a shape, not a fact. Replace it with the fact.

### Language

There's a specific vocabulary that shows up almost every time: additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (used abstractly), pivotal, showcase, tapestry (also abstract), testament, underscore, vibrant. None of these are wrong exactly, they're just what a model reaches for by default. Use the plain word instead.

Same goes for fancy stand-ins for "is": "serves as," "stands as," "boasts," "features." It's usually just "is" or "has."

Skip "not just X, but Y" - if the point matters, state it directly.

Watch the rule of three. Forcing everything into groups of three (three examples, three adjectives, three clauses) is a rhythm the model falls into, not one you'd choose on purpose. Use however many you actually need.

Synonym cycling - protagonist, main character, central figure, hero, all describing one person in one paragraph - reads like a thesaurus was open the whole time. Pick a name or a term and repeat it.

False ranges ("from X to Y") only work when X and Y sit on a real scale. If they don't, just list the things.

### Style

Avoid em dashes entirely - periods and commas only. No parentheses either; swapping one crutch for another doesn't fix anything. If a thought needs a break, end the sentence.

Colons are fine before a list or an example. They're not a substitute for actually connecting two ideas mid-sentence. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" doesn't need that colon at all - "Describing when the scheduler should fire works best as plain English" says the same thing without the crutch.

Don't bold every proper noun or acronym just because it's a proper noun or acronym.

Inline-header lists are their own tell: a bold label followed by a colon that just repeats the sentence, like "**Performance:** Performance improved..." Turn it into prose. A bold lead-in is fine when it ends in a period, names something concrete, and is followed by an actual new detail - "**Schema in TypeScript.** Tables live in one file" earns its bold.

Headings should be sentence case, not title case. No decorative emoji in headings or bullets. And straight quotes, not curly ones.

### Communication artifacts

Cut chatbot filler on sight: "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" None of it is information.

Same with cutoff disclaimers like "while specific details are limited..." Either go find the details or drop the sentence.

And drop the sycophancy. "Great question! You're absolutely right!" isn't a response, it's throat-clearing. Just answer.

### Filler

"In order to" is "to." "Due to the fact that" is "because." "It is important to note that" doesn't need to exist - delete it and the sentence still works.

Hedging stacks up the same way: "could potentially possibly be argued that it might" is just "may."

And generic conclusions ("the future looks bright") are a way of ending a paragraph without committing to anything. State the actual plan or fact instead.

### Jargon

There's a family of abstract nouns that sound technical but usually stand in for a plainer word: substrate, wedge, vector, locus, vantage, nexus, primitive (as a noun), harness (as metaphor), surface (as in "API surface"), bedrock, scaffolding (as metaphor), modality, paradigm, gold-plating, ratchet (as metaphor), evacuate (for moving code), endgame, north star, flywheel. "Substrate" is "base." "Wedge in" is "add." "Vector" is "way" or "method." "Gold-plating" is "more than the job needs." "Ratchet" is either the mechanism's real name or "a limit that only tightens." "Evacuate" is "move out." "Endgame" is "the last phase." Whatever the word is standing in for, use that instead.

### Plain speech

Name the mechanism, not the feeling. "The database stays close at hand," "SQL you can read," "types that follow your schema" - these describe a mood, not a fact. Ask what the sentence actually tells the reader to do or know, then write that instead: "`.toSQL()` returns the exact string sent to the database," "a column rename fails the build." If you can't turn it into a concrete instruction, fact, or number, cut it. One more test: if the sentence would read the same in someone else's docs, it's not telling the reader anything about this project. Cut it too.

If a sentence makes the reader backtrack to parse it, split it or drop a clause. One idea per sentence is a good default.

Prefer active voice. "Queries are validated" becomes "the compiler validates queries." "The file is parsed by the loader" becomes "the loader parses the file." Passive voice is fine when the actor genuinely doesn't matter or isn't known, not as a default.

Cut adverbs, or find a verb that doesn't need one. "Runs quickly" is "is fast," or better, the actual number. "Significantly improves" is whatever the measured delta actually was. An adverb propping up a weak verb usually means the verb is wrong.

And prefer the plain word generally: "utilize" is "use," "leverage" is "use," "facilitate" is "help," "numerous" is "many," "in the event that" is "if." The fancier synonym almost never buys you anything.
