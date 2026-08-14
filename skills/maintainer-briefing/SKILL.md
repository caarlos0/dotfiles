---
name: maintainer-briefing
description: Generate a prioritized maintainer briefing from current GitHub repository state, including issue/PR dependencies, CI, review blockers, regressions, and drift.
user_invocable: true
---

# Maintainer Briefing

Allocate maintainer attention; do not perform detailed code review or invent
merge recommendations.

Resolve the repository argument or use:

```bash
gh repo view --json nameWithOwner -q '.nameWithOwner'
```

Fetch open pull requests and issues with `gh`, including review decisions,
unresolved threads, labels, checks, timestamps, authors, and size. Fetch details
only for candidates likely to appear in the report.

## Dependency map

Build an issue/PR map from closing references, linked issues, comments, commit
messages, and overlapping symbols when available. Detect:

- issues with open, merged, or superseded fixes;
- PRs whose premise changed because another PR merged first;
- reopened regressions or partial fixes;
- stale file and line references after ports or large insertions;
- contradictory issues or PRs touching the same behavior;
- base-branch failures affecting multiple pull requests.

Do not infer a dependency from similar titles alone.

## Prioritization

Rank by:

1. security or data-loss risk;
2. contributor blocked on a maintainer decision;
3. regression or broken release/CI;
4. user already engaged and context still warm;
5. small, passing goodwill wins;
6. stale cleanup.

Estimate effort from actual scope and decision complexity, not line count alone.
Deduplicate items across sections.

## Report

Keep the report compact:

### Critical
At most three security, regression, release, or contributor-blocking items.

### Decisions Needed
Items requiring maintainer product/API direction rather than code review.

### Easy Wins
Small, passing, low-risk work with the exact next action and effort estimate.

### Deep Focus
At most three high-leverage reviews or investigations, each under 30 minutes
unless unavoidable.

### Dependency and Drift
Superseded fixes, reopened issues, stale citations, contradictory premises, and
safe close/ping candidates.

### Snapshot
Open PR/issue counts, items waiting on the maintainer, CI failures, and backlog
distribution.

Close with the single best action today, fastest contributor goodwill win, and
what is safe to ignore. Ground every item in fetched data and use `#number`
references consistently.
