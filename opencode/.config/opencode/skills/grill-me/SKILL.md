---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me". Also use when starting from a raw idea or feature description to collaboratively build a plan.
disable-model-invocation: true
---

# Grill Me

If a plan or design is provided, interview me relentlessly about every aspect of it until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

If only a raw idea or feature description is provided, first help me shape it into a concrete plan by exploring the codebase to understand conventions and constraints, then interview me about the design decisions.

For each question, provide your recommended answer.

CRITICAL: Ask exactly ONE question per response. Never list multiple questions. Wait for the user's answer before asking the next question.

If a question can be answered by exploring the codebase, explore the codebase instead of asking.
