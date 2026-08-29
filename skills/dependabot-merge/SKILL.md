---
name: dependabot-merge
description: Review and merge open Dependabot pull requests across an organization or user. Use for dependency update triage, supply-chain checks on bumps, or bulk dependency merges.
user_invocable: true
---

# Dependabot Merge

Merge safe dependency updates. Stop and report the unsafe ones. Never merge a
pull request that you did not check in this run.

Resolve the owner from the argument, or use the current user:

```bash
gh api user -q .login
```

## Ledger

Keep a ledger, so that a second run does not check the same pull request again.
Create it once per run with the `sql` tool:

```sql
CREATE TABLE IF NOT EXISTS dependabot_prs (
  url TEXT PRIMARY KEY,
  repo TEXT, number INTEGER, title TEXT,
  state TEXT,     -- pending | merged | skipped | blocked | failed
  reason TEXT,
  checked_at TEXT
);
```

Write a row with `state='pending'` when you find a pull request. Update the row
immediately after each decision. Read the ledger before each step and process
only `pending` rows. Report the terminal rows again at the end, but do not
check them again.

## Collect

```bash
gh search prs --owner OWNER --author app/dependabot --state open \
  --limit 100 --json number,repository,title,url,createdAt
```

Add `--draft=false` to skip drafts. Insert the results into the ledger.

## Check each pull request

Get the facts in one call:

```bash
gh pr view URL --json number,author,isDraft,mergeable,mergeStateStatus,\
reviewDecision,files,commits,statusCheckRollup
```

The commit body holds the authoritative metadata in the
`updated-dependencies:` block: `dependency-name`, `dependency-version`,
`dependency-type`, and `update-type`. A grouped update lists many entries.
Check every entry.

Set `state='blocked'` and continue to the next pull request if any of these is
true:

- the author is not the `dependabot` bot, or a commit has a different author;
- `mergeable` is `CONFLICTING`;
- a required check failed;
- the diff changes a file that is not a manifest, a lockfile, or a workflow;
- `update-type` is `version-update:semver-major`;
- the new version is less than 3 days old, or the release notes and the tag do
  not exist upstream;
- the package repository, the homepage, or the maintainer changed;
- a lockfile adds a package with an install script (`preinstall`,
  `postinstall`, `prepare`).

Query the advisory database for each new version:

```bash
gh api '/advisories?ecosystem=ECOSYSTEM&affects=NAME@VERSION&per_page=5' \
  --jq '.[] | {ghsa_id, severity, summary}'
```

An open advisory that affects the new version blocks the merge. An advisory
that the bump repairs is a reason to merge.

## Deep check

A version number proves nothing about the content. Read the upstream diff for
every bump that is not a patch of a dependency that you already trust, and for
every `npm` or `pypi` bump.

Send this work to parallel subagents, one subagent for each dependency. Give
each subagent the dependency name, both versions, and the compare URL:

```
https://github.com/OWNER/REPO/compare/vOLD...vNEW
```

Ask the subagent to report only evidence, with file and line references:

- obfuscated code, long base64 or hex strings, or a new minified file;
- new network calls, new subprocess calls, or new file-system writes;
- reads of environment variables, tokens, keys, or wallet paths;
- a new install script, or a new build step that downloads code;
- a change of maintainer, of signing key, or of the release workflow;
- a diff that is much larger than the version bump promises.

The subagent reports `clean`, `suspicious`, or `unknown`. Treat `suspicious`
and `unknown` as `blocked`. A compare page that does not exist is `blocked`,
because the tag does not match the release.

## Merge

Merge only a pull request that passed every check above and has green checks.
Use the method that the repository permits:

```bash
gh repo view REPO --json squashMergeAllowed,mergeCommitAllowed
gh pr merge NUMBER -R REPO --squash --delete-branch
```

Prefer squash. Use `--merge` when squash is not permitted. Add `--auto` when
the checks are still running, and record `state='pending'` instead of
`merged`. Never rebase.

Update the ledger after every merge. A failed merge is `state='failed'` with
the error text as the reason.

## Report

One line for each pull request, grouped by result:

- **Merged** — repository, dependency, and version change.
- **Blocked** — the single reason, and the evidence for it.
- **Failed** — the error.

Close with the count for each group, and the pull requests that need a human.
Name the suspicious dependency first.
