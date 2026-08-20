---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled: the questions you can ask _now_ without guessing at answers you haven't heard yet.

**Sub-rounds.** If the frontier has more than 5 questions, split it into sub-rounds (1A, 1B, 1C, etc.) of **max 5 each**. Order sub-rounds by dependency depth or impact - deeper dependencies come later. Ask one sub-round at a time, wait for answers, then move to the next sub-round. Only when all sub-rounds of a round are answered do you recompute the frontier and start the next round. A round isn't done until every sub-round is settled.

Format each question like this:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommendation, or ask for their opinion if you don't have a strong one>
```

**Recommendations are optional.** Only give one if you have a substantive, well-reasoned opinion. If the best you can say is "yes" or you genuinely want the user's perspective, skip the recommendation and instead ask: "What's your take?" or "What are you leaning toward?" The goal is to surface the user's thinking, not substitute yours when you don't have one.

Each round the user answers reshapes the tree: settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, etc.), dispatch a sub-agent to find it; don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report; ask the rest of the frontier now. The _decisions_ are the user's: put each to them and wait.

The session ends when the frontier is empty: you've visited every branch of the design tree and nothing remains silently assumed. Do not act until the user confirms you share the same understanding.
