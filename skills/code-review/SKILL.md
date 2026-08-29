---
name: code-review
description: Review code, diffs, branches, commits, and pull requests for correctness, tests, simplicity, performance, and usability.
user_invocable: true
---

# Code Review

Review read-only by default. Do not edit files or mutate GitHub state unless the
user explicitly asks. Follow repository instructions before this skill.

## Scope

1. Resolve the base and review the complete diff. For a pull request, refresh
   the base ref before computing the merge base.
2. Read the request, linked issue, surrounding code, callers, and tests. Diff
   actual files; prose is not evidence.
3. Identify the intended behavior and review only introduced behavior, except
   pre-existing code made newly reachable or incorrect.

Report only high-confidence problems that a user can trigger and observe. Ignore
style, naming, formatting, generic advice, and unrelated cleanup.

## Required independent checks

Before the verdict, request both checks in parallel. Give each the full target,
base, intent, repository instructions, and known validation; do not split the
diff.

- Ask the `caarlos0` agent for a read-only maintainer check of correctness,
  scope, simplicity, usability, compatibility, public surface, and maintenance
  cost.
- Ask `anvil` in verify-only mode for an adversarial check of correctness, test
  coverage, determinism, performance evidence, and user-visible behavior.

These are leaf tasks: agents must not invoke `code-review`, request agents, edit,
or mutate GitHub. Require exact file/line, reachable scenario, impact, evidence,
smallest fix, and test. If either check cannot run, disclose it.

Agent reports are leads. Independently trace or reproduce each claim and resolve
disagreements with code, tests, logs, history, or specification.

## Correctness

- Trace data and control flow across changed boundaries.
- Check defaults, absent and explicit values, errors, cancellation, cleanup,
  reuse, persistence, serialization, concurrency, and platform paths.
- Check that success cannot hide failure or discarded output, and that errors
  cannot become false success.
- Verify automated findings independently; never act only to satisfy a bot.

## Test coverage

- Require a focused regression test for a bug fix and direct coverage of each
  changed contract. Prefer the lowest decisive test layer.
- Ensure tests exercise production behavior, not mocks, copied implementation,
  or helpers that cannot reproduce the bug.
- Where practical, prove the regression test fails without the fix.
- Cover material success, failure, boundary, default, and transition states, not
  speculative combinations.
- Keep decisive assertions near the behavior and print useful actual values or
  variants on failure.

Report missing coverage only when changed behavior can regress undetected and a
focused test can cover it.

## Test determinism

- Prefer observable state, barriers, channels, events, unique resources, and
  precise assertions over sleeps, timing races, retries, ambient ordering, and
  broad output matches.
- Control clocks, randomness, timezone, locale, environment, working directory,
  network, ports, paths, process-global state, and parallel-test cleanup.
- A larger timeout is not a race fix. Accept retries or timeouts only when time
  or transient failure is part of the contract.
- A passing rerun proves nondeterminism, not correctness. Read the real failure
  text and identify the mechanism before calling a test flaky.
- For CI failures, compare the failure window with the failing code's lifetime.
  Separate regressions and merge conflicts from races; inspect all job attempts
  and prioritize required checks.

## Simplicity

- Prefer the smallest complete change, existing patterns, standard library,
  private implementation, direct control flow, and one concern per change.
- Require a demonstrated caller or failure mode for each dependency, option,
  public API, abstraction, compatibility layer, retry, timeout, or defense.
- Reject drive-by refactors and speculative defenses. Small duplication is
  better than an abstraction that hides behavior.
- Check comments, docs, errors, and names only when the change makes them false.

## Performance and usability

- Trace changed hot paths, I/O, allocations, concurrency, startup, and resource
  lifetime. Require a benchmark, profile, or mechanically clear regression;
  reject optimization folklore and harmless micro-costs.
- Check the complete user workflow, defaults, compatibility, discoverability,
  errors, help, accessibility, and recovery from failure.
- Report usability only through a concrete user task and observable friction,
  not personal taste.

## Related skills

- `change-impact-auditor`: configuration, policy, protocol, or shared models.
- `runtime-process-debugging`: process, shell, pipe, lifecycle, or race behavior.
- `issue-validator`: a claimed issue fix or stale report.
- `go-conventions` or `rust-specialist`: matching language changes.
- `go-doc`: unfamiliar Go APIs, without `go get` or module changes in review.
- `go-performance`, `rust-performance`, `typescript-performance`, or
  `python-performance`: matching language performance work.

Invoke only relevant skills.

## Validation and result

Run the smallest command that can confirm or reject a finding. Before local
builds or tests, check `uptime`; stop when load average exceeds about 12.

List findings by severity with file/line, trigger, impact, smallest fix, and
needed test. Do not add praise, summaries of correct code, or low-confidence
possibilities. State material verification gaps separately.

If there are no findings, say so plainly. Do not post a review unless asked. If
asked to act on a pull request with no findings, approve it and disclose that
the reviewer is a bot.
