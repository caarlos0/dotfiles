---
name: code-review
description: Review code, diffs, branches, commits, and pull requests for correctness, tests, simplicity, performance, and usability.
user_invocable: true
---

# Code Review

Do not edit files except for the review outputs described below.
Limit GitHub mutations to posting and superseding reviews and, when continuous
review is requested, resolving addressed threads. Follow repository instructions
before this skill.

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
  Verify that the feature or fix solves a real problem, especially when the
  change appears fully automated without human input.

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

- `code-simplifier`: assess simpler alternatives without editing files.
- `writing-tests`: review regression coverage, test isolation, and determinism.
- `gh-cli`: GitHub operations and waiting for new pushes.
- `infographic`: explain findings visually when that makes them clearer; follow
  its publishing boundaries.
- `change-impact-auditor`: configuration, policy, protocol, or shared models.
- `runtime-process-debugging`: process, shell, pipe, lifecycle, or race behavior.
- `issue-validator`: a claimed issue fix or stale report.
- `go-conventions` or `rust-specialist`: matching language changes.
- `go-doc`: unfamiliar Go APIs, without `go get` or module changes in review.
- `go-performance`, `rust-performance`, `typescript-performance`, or
  `python-performance`: matching language performance work.

Use `code-simplifier` and `writing-tests` in read-only mode. Invoke the other
skills only when relevant.

## Validation and result

Do not build locally. Assume the build is green for the review, but do not claim
it was verified. Run the smallest non-build command that can confirm or reject
a finding. Before local tests, check `uptime`; stop when load average exceeds
about 12.

List findings by severity with file/line, trigger, impact, smallest fix, and
needed test. Do not add praise, summaries of correct code, or low-confidence
possibilities. State material verification gaps separately.

If there are no findings, say so plainly.

For a local branch, write the result to `review.md`. For other local diffs and
commits, report in chat.

## Posting a review

When the target is a pull request, always post the review. Do not ask first and
do not stop at reporting findings in chat.

Anchor every finding to the code it concerns. Submit one review whose `comments`
array carries an inline comment per finding, each with `path` and `line`, plus
`start_line` for a range. Never collect findings in the review body, and do not
split them into separate top-level comments. `gh pr review` cannot attach inline
comments, so post through the reviews API, for example
`gh api repos/OWNER/REPO/pulls/N/reviews --method POST --input -`.

- Keep the body for the verdict and for anything with no single site:
  cross-cutting scope, missing tests, and disclosed verification gaps.
- Anchor to a line the diff touches. When a finding concerns unchanged code,
  anchor to the changed line that reaches it and say why in the comment.
- Make each comment stand alone: trigger, impact, smallest fix, needed test.
  Reference sibling findings by file and line rather than repeating them.
- After posting, read the comments back and confirm every anchor resolved to the
  intended line instead of silently detaching.
- When a later review replaces an earlier one, dismiss the earlier one if GitHub
  permits it; otherwise name the superseded review in the new review body.

### Approval

Read the PR discussion before choosing the review event:

- For a PR authored by `caarlos0`, post `COMMENT`: GitHub does not permit
  approving or requesting changes on your own PR.
- Do not approve if `caarlos0` made a negative comment, especially about the
  idea, or if the overall discussion is negative.
- If `caarlos0` already left a positive comment, such as saying only the bot
  review remains, approve when the PR is good and only minor suggestions remain.
  If there are bigger issues, label the approval "Tentative approval, pending
  resolution of feedback" and state the unresolved issues in inline comments.
- Otherwise, approve if there are no critical problems. Do not invent style
  findings to accompany an approval.

Disclose that the reviewer is a bot.

## Continuous review

Only when asked to keep reviewing new pushes:

1. After posting, retain the exact head SHA reviewed and check the current PR
   once for work already pushed. Review a new head immediately. Otherwise run
   `gh wait <pr>` for the next observed change. It starts a new snapshot, not a
   comparison against the reviewed SHA; earlier changes do not wake it. Follow
   `gh-cli` for repository targeting, output, and exit behavior.
2. Use the longest supported wait. If the command moves to the background, wait
   for its completion notification. Never poll with Git, `gh`, or sleeps between
   notifications.
3. On `changed`, read the PR. Edits and reviews also wake the command; do not
   post a duplicate code review when the head is unchanged. For a new head,
   review only changes since the last reviewed SHA, with enough surrounding
   context to verify them. Resolve threads whose findings were addressed, post
   the new review, retain the new SHA, and wait again.
4. Stop on `merged` or `closed`, both successful events. Report nonzero watcher
   exits as errors rather than treating them as closure.
