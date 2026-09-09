---
name: gh-cli
description: Use GitHub CLI efficiently for pull requests, CI checks, workflow runs, logs, and merge status. Use when running gh, waiting for CI, diagnosing a failed check, or monitoring a pull request.
user_invocable: true
---

# GitHub CLI

Use native `gh` commands before custom API queries or polling scripts. Spend
time on the first actionable failure, not on repeated status reads.

## Fetch once, with a clear target

- Reuse the repository, PR number, head SHA, run ID, and job ID already known.
  Pass `-R OWNER/REPO` to PR/run commands outside the target repository.
  For `gh api`, put the repository in the endpoint; it has no `-R` flag.
- Prefer `gh pr checks`, `gh run view`, and `gh run list` over rebuilding them
  with REST or GraphQL. Check subcommand help instead of guessing flags or
  JSON fields.
- Select only needed `--json` fields and use `--jq` for a compact result.
  Filter lists by commit, workflow, event, or branch before increasing
  `--limit`. Do not fetch a list again to recover an ID it already returned.
- Use `gh api` for data the native command does not expose. Use `--method GET`
  with query fields; adding `-f` or `-F` otherwise changes the method to POST.
  Paginate when the task needs the full set, not just a recent sample.

## Wait for checks, not a timer

For PR merge readiness, start this immediately:

```bash
gh pr checks NUMBER -R OWNER/REPO --required --watch --fail-fast
```

`--required` is the default scope for merge blockers. Omit it only when the
user asks for all checks, or when the task explicitly covers non-required
checks. Do not wait for advisory checks before handling a required failure.
Still report a known regression caused by this change, even if it is optional.

- **Never use `sleep N && gh ...` to wait for CI**, including before a native
  watcher. Do not replace `--watch` with a shell/Python loop or recurring
  status tool calls.
- If a required failure is already known, read its log now. Do not start
  another watcher or wait for unrelated jobs to finish.
- Run one watcher per target in an attached async shell, or let a synchronous
  tool wait on that same process. Reuse its shell ID and completion
  notification. Do useful independent work, or end the turn until notified.
  Do not repeatedly call `read_bash`, start duplicate watchers, or delegate
  an agent just to wait.
- Keep watch output live and preserve its exit status. Do not pipe it through
  `head`/`tail`, redirect errors away, or append `|| true`. A failed watcher
  is not necessarily a failed check: inspect its error before acting.
- Use the native refresh interval. Set `--interval` only for a concrete
  latency or rate-limit need, not as another arbitrary delay.

For one workflow run, when waiting for the whole run is the actual task:

```bash
gh run watch RUN_ID -R OWNER/REPO --exit-status --compact
```

`gh run watch` has no `--fail-fast`; `--exit-status` reports failure when the
run finishes. It is not a substitute for PR required-check fail-fast watching.

## Interpret the result

For a structured snapshot, separate from watch mode:

```bash
gh pr checks NUMBER -R OWNER/REPO --required \
  --json name,bucket,state,link,workflow
```

- `--watch` cannot be combined with `--json`. In plain output, exit code `8`
  means pending checks. With `--json`, a successful fetch can return zero
  even when checks failed; inspect `bucket`, not just the process exit code.
- A cancelled check is not a pass. Watch mode can exit zero with cancelled
  checks, and `--fail-fast` does not treat cancellation as failure. Inspect
  the final states before claiming success. Keep skipped/neutral results
  distinct from passed tests.
- "No checks reported" and "no required checks reported" are not evidence
  of passing CI. Inspect the PR head, workflow triggers, and the PR's actual
  base-branch rules to distinguish missing checks from no required checks.
  Do not silently drop `--required` after an error.
- An auth, permission, API, or network error is not a CI result. Report it.
  Do not hide it in a retry loop or infer success from missing data.
- Native watching covers reported checks, not every review or merge-queue
  transition. For a state with no native watcher, make one focused read per
  scheduled pass if a schedule is already authorized. Stop it when the goal
  is met or the PR is closed. Do not invent an endless polling loop.

## Read the failing job now

Use the failed check's link to identify its run and job. If needed, fetch the
run's jobs once:

```bash
gh run view RUN_ID -R OWNER/REPO --json headSha,event,attempt,status,jobs
```

For a completed run, read only the failed steps, narrowed to the known job:

```bash
gh run view -R OWNER/REPO --job JOB_ID --log-failed
```

If the run is still active, `gh run view --log-failed` can refuse even when
the failing job has finished. Fetch that completed job's log directly:

```bash
gh api repos/OWNER/REPO/actions/jobs/JOB_ID/logs
```

Do not wait for the whole matrix merely to read an already failed job.
If the log is not available, inspect job details or check annotations and
state the limit. Keep large logs in session files and read the relevant
section. Do not label an unavailable log a flake.

Name the exact failing step and error before changing code or rerunning.
Compare the same workflow, event, and relevant code on the base branch or
other heads. "Main is green" means little if that check never runs on main.
A local pass or a green retry alone does not prove a flake. Retry only after
identifying a transient cause and when the task permits it; do not rerun the
whole suite to avoid diagnosing one failure.

## Recheck only what changed

Record the PR head being checked. After a push, rerun, base update, or queue
entry, do not reuse results from the old head or attempt. Use the run IDs and
event for the new state; merge-queue runs can use a different SHA from the PR.

Passing checks, approval, auto-merge enabled, queue entry, and merged are
different states. When the task is to merge, finish with a focused read:

```bash
gh pr view NUMBER -R OWNER/REPO \
  --json headRefOid,state,mergedAt,mergeStateStatus,reviewDecision,autoMergeRequest
```

An enabled auto-merge request is not a completed merge. Report the actual
blocker or confirmed merged state, not another unchanged status dump.
