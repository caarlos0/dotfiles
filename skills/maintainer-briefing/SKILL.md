---
name: maintainer-briefing
description: Generate a daily maintainer briefing for a GitHub repository. Fetches open PRs, issues, CI status, and produces a prioritized attention-allocation report. Use when user says "/maintainer-briefing" or asks for a maintainer report. Examples - "/maintainer-briefing external-secrets/external-secrets", "/maintainer-briefing", "give me a maintainer briefing".
user_invocable: true
---

# Maintainer Daily Briefing

You are a maintainer copilot and attention allocator — NOT a code reviewer.
Do NOT perform detailed code review. Do NOT suggest merge decisions.

## Arguments

The user may provide a repo in `owner/repo` format. If not provided, detect from the current git remote:

```bash
gh repo view --json nameWithOwner -q '.nameWithOwner'
```

Store the resolved repo as `$REPO` for all subsequent commands.

## Grounding Rules

- Do NOT invent events or states. If data is missing, state that briefly.
- Prefer concrete references (PR #, issue #, file paths, labels, CI job names).
- If uncertain about a signal (e.g., security relevance), say so explicitly.
- All summaries must be concise and derived from fetched data or stored memory.

## Step 1 — Fetch Repository State

Use the Bash tool to run `gh` CLI commands. Run independent queries in parallel:

```bash
gh pr list --repo $REPO --state open --json number,title,author,labels,createdAt,updatedAt,additions,deletions,changedFiles,reviewDecision,statusCheckRollup,isDraft,url --limit 100
```

```bash
gh issue list --repo $REPO --state open --json number,title,author,labels,createdAt,updatedAt,comments,url --limit 50
```

For each open PR that looks relevant, fetch review and comment details:

```bash
gh pr view $PR_NUMBER --repo $REPO --json reviews,comments,latestReviews
```

To detect CI status per PR, use the `statusCheckRollup` field from the PR list.

To detect maintainer involvement, check if the repo owner or known maintainer handles appear in reviews/comments.

## Step 2 — Update Memory

Memory files live at: `~/.agents/projects/$PROJECT_KEY/memory/maintainer/`

Create this directory if it doesn't exist. Use the project key derived from the repo name.

Maintain these files:

- `last-briefing.json` — timestamp and summary of last briefing
- `pr-state.json` — per-PR tracked state (last seen status, your involvement, contributor responsiveness, staleness)

Incrementally update (do NOT regenerate from scratch each time):

- Detect if the user previously reviewed or commented on each PR
- Detect if the user is currently the blocker
- Detect responsive contributors waiting for maintainer input
- Detect security-relevant discussions (labels, keywords in titles/comments)
- Detect CI failures requiring maintainer attention
- Detect inactivity drift (>7 days no maintainer response)
- Classify PR review difficulty (Small / Medium / Large) based on changedFiles, additions, deletions
- Estimate review effort in minutes
- Identify PRs likely reviewable primarily by an LLM (extensive but low-risk mechanical changes)

Compare current state against `pr-state.json` to detect what's new since last briefing.

## Step 3 — Generate Report

Output the following sections. If a section has no items, state that clearly and move on. Keep signal high — limit surfaced items, minimize context switching.

---

### Critical Risk (Max 3)

Only include if: security-relevant, escalating discussion, active contributor blocked by maintainer, or CI failures blocking release.

For each:

- PR/Issue #
- Why this is critical
- 2-3 sentence context summary
- Type of thinking required: decision / direction / clarification / coordination
- Estimated effort

---

### New PRs Since Last Briefing

For each new PR:

- PR # and title
- Author
- Size signal (files changed / additions)
- Difficulty estimate (Small / Medium / Large)
- One-line suggested focus area

---

### Easy Wins — Small, Easy-to-Review PRs (Prioritized)

Include PRs classified as Small AND not high-risk. Order by:

1. Responsive contributor waiting
2. User previously engaged
3. CI passing
4. Recently updated

For each:

- PR #
- Why it's small/easy (concrete signal)
- What to focus on during review (1-2 bullets)
- Estimated effort (prefer <=15 min)
- Contributor responsiveness status
- Context freshness: HOT / WARM / COLD

---

### Deep Focus Stack (Max 3, <=30 min each)

Prioritize: security > responsive contributor waiting > user already engaged > waiting on maintainer > CI failures.

For each:

- PR #
- 2-3 sentence context summary
- Why it's high leverage
- Suggested next maintainer action (not code-level review)
- Estimated effort
- Context freshness: HOT / WARM / COLD

Avoid cold-context large items unless high priority.

---

### LLM-Review Candidates

Large PRs that are not security-sensitive, not urgently blocking, and involve mechanical changes (refactors, renames, docs, tests).

For each:

- PR #
- Why suitable for LLM-assisted review
- Risk level (Low / Medium)
- Suggested LLM task framing
- Estimated human oversight time

---

### Side Mode Stack (<=15 min each)

Quick replies, triage new issues, labeling, small unblockers, inactivity pings.

For each:

- PR/Issue #
- One-line description
- Suggested action
- Estimated effort

---

### Drift & Cleanup

PRs stalled >7 days, issues approaching abandonment, threads safe to close.

For each:

- Reference #
- Staleness duration
- Suggested action (ping / close / defer)
- Short suggested ping message (<=2 sentences)

---

### Maintainer Health Snapshot

- Total open PRs
- PRs waiting on maintainer
- PRs user previously engaged in
- Issues needing triage
- Threads where user is the blocker
- CI failure count
- Backlog trend (growing / stable / shrinking) if detectable from memory

---

### Close With

- Best single high-leverage action today
- Fastest contributor goodwill win
- Safe to ignore today

## Output Style

- Use markdown headers and bullet points
- Keep total output focused — no filler
- Reference PRs with `#number` format consistently
- Do not repeat items across sections — deduplicate
