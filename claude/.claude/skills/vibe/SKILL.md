---
name: vibe
description: Skip discussion and planning for this session and just build what's asked. Only run when the user types /vibe.
argument-hint: <what to build>
disable-model-invocation: true
---

For the rest of this session, skip the discussion, planning and decision check-ins. Just build:

$ARGUMENTS

Still:
- Mirror the closest existing code in the codebase.
- Run the completion gate (lint, type checks, relevant tests).
- End with the usual short summary, and list any decisions you made along the way so I can push back.

Safety rules are unchanged - deletes, git and external writes still need asking.
