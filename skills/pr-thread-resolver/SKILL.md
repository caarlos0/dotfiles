---
name: pr-thread-resolver
description: Resolve pull-request review feedback with evidence. Use for /pr fix, unresolved threads, bot review findings, or requests to address all PR comments.
---

# PR Thread Resolver

Inspect every unresolved review thread at the current head.

Classify each thread:

- `actionable`: the finding is correct and in scope;
- `outdated`: later commits removed or changed the cited code;
- `incorrect`: the claimed behavior does not match reachable code;
- `out-of-scope`: real, but pre-existing or unrelated to the pull request;
- `needs-decision`: multiple valid product or API choices remain.

Fix only actionable findings. Validate the changed path, reply with concrete
evidence, and resolve only threads that are actually settled. Leave intentional
deferrals open and link a follow-up issue when one exists. Re-fetch threads
after pushing because review state may have changed.

Never treat a reviewer's confidence as proof. Never hide unresolved decisions
inside a broad cleanup.
