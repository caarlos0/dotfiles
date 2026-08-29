---
name: runtime-process-debugging
description: Debug cross-platform process, shell, sandbox, pipe, handle, startup, and shutdown behavior. Use for hangs, output loss, focus changes, lifecycle races, or platform-specific runtime failures.
---

# Runtime Process Debugging

Prove where lifecycle behavior diverges before changing it.

1. Map process ownership, parent/child relationships, pipe and handle owners,
   cancellation, completion, and teardown.
2. Trace macOS, Linux, and Windows separately; do not assume their process or
   pipe semantics match.
3. Instrument the narrow boundary where data, focus, or completion is lost.
4. Reproduce under the relevant scheduler, load, descendant-process, and EOF
   conditions.
5. Fix the owning runtime layer, preserving intentional bounds such as avoiding
   hangs from inherited handles.
6. Add a deterministic regression test that controls ordering explicitly; use
   `writing-tests` for synchronization, pipe-drain, EOF, and assertion patterns.

Do not fix races with sleeps, retries, looser assertions, or larger timeouts
unless evidence shows elapsed time is the intended contract. Prefer observable
state—EOF, process exit, handle ownership, channel closure—over timing.

## Related skills

- `writing-tests`: deterministic lifecycle regression tests. When invoked from
  `writing-tests`, do not invoke it again.
- `code-review`: review a completed lifecycle fix and its regression test.
