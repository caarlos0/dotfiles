---
name: change-impact-auditor
description: Trace a behavioral change through consumers, defaults, docs, tests, errors, and UI. Use when changing configuration, policy, defaults, protocols, or shared data models.
---

# Change Impact Auditor

Audit the semantic concept, not just the edited symbol.

1. Identify the old and new behavior in one sentence.
2. Search all producers, consumers, serializers, defaults, migrations, caches,
   and fallback paths.
3. Check command help, user-facing errors, documentation, examples, UI status,
   and tests for claims that became false.
4. Trace equivalent implementations across languages or process boundaries.
5. Verify absent, explicit false, explicit true, error, reload, and startup
   states when relevant.
6. Report contradictions separately from intentionally deferred scope.

Do not update text mechanically. Confirm each reference describes the changed
behavior before editing it.
