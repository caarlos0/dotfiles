---
name: writing-tests
description: Write deterministic tests that fail for real product defects. Use when adding tests, fixing flakes, or reviewing test coverage and reliability.
user_invocable: true
---

# Writing Tests

A useful test fails when behavior is wrong, passes when it is right, and
explains the failure without a debugger. Follow repository instructions first.

## Prove the behavior

- Choose the lowest layer that proves the contract: unit for local logic,
  integration for real boundaries, CLI/UI/E2E only for behavior unavailable
  below them.
- Exercise production code. Do not copy its logic into the test or mock the
  unit under test.
- A bug fix needs a focused regression test. Where practical, revert or mutate
  the fix and confirm that exact test fails.
- Assert observable results, not private calls or incidental structure.
- Print expected and actual values, variants, exit status, stderr, and case
  labels needed to diagnose a rare CI failure.
- Cover material success, failure, boundary, default, and state transitions.
  Do not add combinations without a concrete regression risk.

## Control every input

- Inject clocks; fix timezone and locale when formatting matters.
- Seed randomness and print the replay seed on failure.
- Use semantic unordered equality when order is not a contract. Do not hide a
  required order by sorting expected output.
- Give each test an isolated environment, home, working directory, config root,
  database state, cache, and temporary directory.
- Bind servers to port `0` and retain the listener. Never find, close, and
  rebind a "free" port.
- Avoid process-global mutation from parallel tests. Use helpers that restore
  state automatically.

## Synchronize; do not sleep

Replace sleeps and grace periods with a happens-before edge: channel receive,
barrier, latch, event, condition, queue drain, file close, EOF, process exit, or
application readiness.

Use fake time only when time is the contract. Know which clock it controls.
Use a timeout only around an observable wait as an outer deadlock detector;
expiry must fail with diagnostics. Never use a sleep, retry, timeout increase,
or looser assertion as a race fix.

For processes, establish the required order: start output readers, close stdin
when EOF is required, drain stdout and stderr, observe exit, then clean up.
Preserve output even when finalization fails.

## Own resources and cleanup

Register cleanup immediately after acquisition. Teardown in dependency order:
stop producers, cancel work, drain or join consumers, flush, close resources,
then delete storage. Surface cleanup failures.

Parallel tests need separate resources. A shared temp path, port, database row,
clock, fake timer, module cache, or mutable global is a race even if it usually
passes.

Use a local implementation of the real protocol at boundaries: an in-process
HTTP server, transaction-isolated database, or controlled fake implementing the
real interface. Do not put live third-party availability, credentials, mutable
data, or rate limits in required tests.

## Snapshots, properties, and fuzzing

Normalize only fields proven volatile, such as generated IDs or temp roots.
Broad normalization can erase the bug. Golden updates must be explicit and
reviewed.

Use property, fuzz, differential, or metamorphic tests when examples cannot
cover the input space or no simple expected value exists. Retain the minimized
input or seed so every discovery becomes a deterministic regression.

## E2E, browser, CLI, and TUI

Wait for the exact readiness needed by the next action: health response, UI
state, log event, or prompt. Do not use arbitrary sleep or generic network idle.
Prefer user-visible and accessibility-based locators plus retrying assertions.

Control browser, viewport, fonts, animation, and dynamic content for visual
tests. Assert CLI/TUI exit status and relevant stdout/stderr after complete
drain. For AI-backed behavior, assert an objective observable contract, not one
exact natural-language answer unless the text itself is the contract.

## Language mechanics

### Go

- Use `t.TempDir`, `t.Setenv`, `t.Cleanup`, `httptest.Server`, the race detector,
  and shuffled runs where relevant. Record shuffle seeds.
- Process-global environment and working-directory changes are incompatible
  with parallel tests.
- `FailNow` and testify `require` must run on the test goroutine. From handlers
  or spawned goroutines, report errors to the test goroutine and synchronize.
- Use channels and `WaitGroup`; use `testing/synctest` only when supported by
  the repository's Go version.
- Compare maps semantically or sort a copied key set for golden output.

### Rust

- Keep test-only helpers behind `#[cfg(test)]`.
- Use channels and barriers for ordering; use
  `#[tokio::test(start_paused = true)]` for timer behavior. Prefer
  `time::sleep(d).await` over `tokio::time::advance(d)`, which does not wait
  for tasks to be polled and can produce false passes.
- When already present, Loom or Shuttle can explore schedules and Proptest can
  shrink and persist failures.
- Ensure all process pipe owners close so EOF and exit are observable.

### TypeScript and JavaScript

- Always await promise assertions and async timer advancement.
- Restore spies, modules, and fake timers after each test; clearing calls does
  not restore implementations.
- Do not combine process-global fake timers or mutable module state with
  concurrent tests.
- Use Playwright locators and web assertions for readiness.
- For subprocess output assertions, await the `'close'` event, not `'exit'`;
  `'exit'` fires before stdio streams finish flushing.

### Python

- Use `tmp_path` and `monkeypatch` for automatically restored state.
- Cancel and await asyncio tasks before ending a test:
  `task.cancel(); with contextlib.suppress(asyncio.CancelledError): await task`.
- Use `subprocess.communicate()` for bidirectional process I/O.
- When order or property tools are already present, retain their seed or
  minimized example.

## Flake triage

A passing rerun on the same commit proves nondeterminism, not correctness.

1. Read the original failure text, stack, stderr, seed, logs, and artifacts.
2. Separate infrastructure failures such as OOM, disk, runner, or container
   loss from product assertions.
3. Compare the failure window with the lifetime of the failing code. Use history
   to name the introducing or fixing commit; absence of recent failures is not
   evidence of a fix.
4. Inspect every CI attempt because rerun-to-green summaries hide failures.
5. Reproduce on parents when needed to distinguish a landed regression or
   semantic merge conflict from a race.
6. Identify the mechanism: ordering, async completion, data race, resource leak,
   state pollution, clock, randomness, platform, external dependency, or
   infrastructure.
7. Fix the owning layer and write a deterministic regression test controlling
   that mechanism.

Prioritize flaky required checks because they block merges. Retries or
quarantine may temporarily unblock work, but they must retain failed attempts,
an owner, and an issue. Do not weaken assertions or delete safety coverage to
make CI green.

## Related skills

- `code-review`: coverage and determinism review. When invoked from
  `code-review`, do not invoke it again.
- `runtime-process-debugging`: process, pipe, lifecycle, shutdown, and ordering
  mechanisms. When invoked from it, do not invoke it again.
- `go-conventions` and `rust-specialist`: language-specific production changes.
- `change-impact-auditor`: tests for configuration, protocol, default, or shared
  model changes.

Do not recurse. Keep the fix to one concern and run the smallest decisive
validation.
