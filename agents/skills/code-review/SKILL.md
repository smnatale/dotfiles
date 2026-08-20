---
name: code-review
description: "Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to \"review since X\"."
---

Review the diff between `HEAD` and a fixed point the user gives you.

- **Standards**: does the code follow this repo's documented conventions?
- **Spec**: does the code do what the originating issue or spec asked for?

Run both reviews as parallel sub-agents so they stay independent, then combine their findings.

The issue tracker should already be available. If `docs/agents/issue-tracker.md` is missing, tell the user to run `/setup-matt-pocock-skills`.

## Process

### 1. Pin the fixed point

Use whatever the user named - a commit SHA, branch, tag, `main`, `HEAD~5`, etc. Ask if they didn't specify one.

Capture the diff once: `git diff <fixed-point>...HEAD` (three-dot, comparing against the merge-base). Also grab the commit list: `git log <fixed-point>..HEAD --oneline`.

Before spawning agents, confirm the ref resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. Fail early on a bad ref or empty diff rather than inside the sub-agents.

### 2. Find the spec

Look for the originating spec in this order:

1. Issue references in commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.), fetched via `docs/agents/issue-tracker.md`.
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` matching the branch or feature name.
4. If nothing turns up, ask the user where the spec lives. If they say there isn't one, skip the Spec sub-agent and note "no spec available" in the final report.

### 3. Find the standards

Collect anything that documents how code should be written in this repo - `CODING_STANDARDS.md`, `CONTRIBUTING.md`, etc.

The Standards axis always carries this smell baseline, even when the repo documents nothing. Two rules apply:

- **Repo wins.** A documented standard always overrides the baseline. If the repo endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic, never a hard violation. Skip anything tooling already enforces.

Match each smell against the diff. For each hit, name the smell and quote the hunk.

**Smell baseline**

| Smell | What to look for | Fix |
|---|---|---|
| Mysterious Name | A function, variable, or type whose name hides what it does or holds. | Rename it. If no honest name fits, the design is murky. |
| Duplicated Code | The same logic shape in more than one hunk or file. | Extract the shared shape and call it from both. |
| Feature Envy | A method that reaches into another object's data more than its own. | Move the method onto the data it envies. |
| Data Clumps | The same few fields or params travelling together. | Bundle them into one type and pass that. |
| Primitive Obsession | A primitive or string standing in for a domain concept. | Give the concept its own small type. |
| Repeated Switches | The same `switch` or `if`-cascade on the same type across the change. | Replace with polymorphism or one shared map. |
| Shotgun Surgery | One logical change forces scattered edits across many files. | Gather what changes together into one module. |
| Divergent Change | One file or module edited for several unrelated reasons. | Split so each module changes for one reason. |
| Speculative Generality | Abstraction, parameters, or hooks added for needs the spec doesn't have. | Delete it. Inline back until a real need shows. |
| Message Chains | Long `a.b().c().d()` navigation the caller shouldn't depend on. | Hide the walk behind one method on the first object. |
| Middle Man | A class or function that mostly just delegates onward. | Cut it and call the real target directly. |
| Refused Bequest | A subclass or implementer that ignores or overrides most of what it inherits. | Drop the inheritance and use composition. |

### 4. Spawn both sub-agents in parallel

**Standards sub-agent prompt**

Include:
- The diff command and commit list.
- The standards-source files you found in step 3, plus the smell baseline table from step 3 pasted in full (the sub-agent has no other access to it).
- This brief: "Report, per file or hunk: (a) every place the diff violates a documented standard - cite the standard file and rule; (b) any baseline smell you spot - name it and quote the hunk. Distinguish hard violations from judgement calls: documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words."

**Spec sub-agent prompt**

Include:
- The diff command and commit list.
- The path or fetched contents of the spec.
- This brief: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

### 5. Aggregate

Present the two reports under `## Standards` and `## Spec` headings, verbatim or lightly cleaned. Do not merge or rerank findings - the two axes are deliberately separate.

End with a one-line summary: total findings per axis, and the worst issue within each axis (if any). Don't pick a single winner across axes.

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing - Standards pass, Spec fail.
- Code that does exactly what the issue asked but breaks project conventions - Spec pass, Standards fail.

Reporting them separately stops one axis from hiding the other.
