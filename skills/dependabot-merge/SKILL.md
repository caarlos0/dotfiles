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

Use single quotes for every SQL string. SQLite rejects a double-quoted literal
that does not name a column, and the whole insert fails.

Fetch the facts for all of them in parallel, then triage from one table
instead of one round trip per pull request:

```bash
gh search prs --owner OWNER --author app/dependabot --state open \
  --draft=false --limit 100 --json url --jq '.[].url' > urls.txt
xargs -P 8 -n 1 -I URL sh -c 'gh pr view "$1" --json \
  number,url,author,mergeable,mergeStateStatus,files,commits,statusCheckRollup \
  > "out/$(echo "$1" | tr "/:" "__").json"' _ URL < urls.txt
```

## Check each pull request

Get the facts in one call:

```bash
gh pr view URL --json number,author,isDraft,mergeable,mergeStateStatus,\
reviewDecision,files,commits,statusCheckRollup
```

The commit body holds the metadata in the `updated-dependencies:` block:
`dependency-name`, `dependency-version`, `dependency-type`, and `update-type`.
A grouped update lists many entries. Check every entry.

**The metadata can disagree with the diff. The diff wins.** Dependabot rebases
and the block goes stale. One pull request declared
`dependency-version: 5.24.0` and `update-type: version-update:semver-minor`
while `gh pr diff` showed `5.22.0` to `6.0.0`. Read the diff before you call a
bump minor:

```bash
gh pr diff NUMBER -R REPO -- package.json go.mod
```

Set `state='blocked'` and continue to the next pull request if any of these is
true:

- the author is not the `dependabot` bot, or a commit has a different author;
- `mergeable` is `CONFLICTING`;
- **a _required_ check failed** — see "Which checks matter";
- the diff changes a file that is not a manifest, a lockfile, or a workflow
  (lockfiles include `uv.lock`, `flake.lock`, `Cargo.lock`, `pnpm-lock.yaml`);
- the new version is less than 3 days old, or the release notes and the tag do
  not exist upstream;
- the package repository, the homepage, or the maintainer set changed;
- a lockfile adds a package with an install script (`preinstall`,
  `postinstall`, `prepare`).

A `version-update:semver-major` is not an automatic block. See "Major updates".

For an `npm` bump, compare the maintainer set of both versions, not only the
new one:

```bash
for v in OLD NEW; do
  curl -s "https://registry.npmjs.org/PKG/$v" | jq -c '[.maintainers[].name]'
done
```

A set that shrinks inside the bump window is a block. `axios` went from 4
maintainers to 1 between 1.13.6 and 1.18.0, which concentrates publish rights
on one account.

## Which checks matter

Do not block on a red check until you know it is required. `mergeStateStatus`
already answers this:

| Value      | Meaning                                                        |
| ---------- | -------------------------------------------------------------- |
| `CLEAN`    | mergeable, nothing red                                          |
| `UNSTABLE` | mergeable; **only non-required checks are red** — not a blocker |
| `BEHIND`   | strict protection, branch out of date                           |
| `BLOCKED`  | required check, missing review, **or an archived repository**   |
| `UNKNOWN`  | GitHub is still computing — poll again, do not judge            |

Confirm with the branch protection and the rulesets:

```bash
db=$(gh api repos/REPO --jq .default_branch)
gh api "repos/REPO/branches/$db/protection" --jq '.required_status_checks.contexts'
gh api "repos/REPO/rules/branches/$db" \
  --jq '[.[]|select(.type=="required_status_checks")
        |.parameters.required_status_checks[].context]'
```

`404 Branch not protected` and an empty ruleset list mean nothing is required.
A `403` on a private repository means you cannot read it — trust
`mergeStateStatus` instead.

**Check `isArchived` first.** You cannot merge into an archived repository, and
GitHub reports it as `BLOCKED` with no protection and no rules, which looks
like a required check:

```bash
gh repo view REPO --json isArchived,archivedAt
```

Report an archived repository as `skipped`, not as a CI failure.

## Major updates

A major bump is a question, not a verdict: **does the breaking change reach
this project?** Ask the deep-check subagent to state the documented breaking
change in one sentence, then test it against the repository.

The evidence is the pull request's own CI. A green `build` on the pull request
proves the new version works there, because the workflow ran with the bump
applied. `actions/checkout` v7 only blocks fork checkout under
`pull_request_target` and `workflow_run`, so this settles it:

```bash
for f in $(gh api repos/REPO/contents/.github/workflows --jq '.[].name'); do
  gh api "repos/REPO/contents/.github/workflows/$f" --jq .content | base64 -d \
    | grep -qE '^\s*(pull_request_target|workflow_run)\s*:' && echo "$f"
done
```

Merge when the breaking change cannot reach the project and CI is green. Block
when it can, and name the mechanism.

### A red check is not proof that the bump broke it

Compare against the base branch before you blame the bump:

```bash
gh run list -R REPO --limit 6 \
  --json conclusion,workflowName,headBranch,createdAt
```

Then read the log and name the error:

```bash
gh api --allow-escape-sequences repos/REPO/actions/jobs/JOB_ID/logs \
  | perl -pe 's/^.*?\dZ //' | perl -pe 's/(\e|\^\[)\[[0-9;]*m//g' \
  | grep -iE 'error|failed' | head -20
```

Two examples from one run. A `snapshot` job failed with an OpenCV `aruco` C++
compile error that also failed on `master` — unrelated, so the bump merged. A
`test` job failed with `npm ERESOLVE`, because
`@typescript-eslint/eslint-plugin@8.65.0` needs `typescript <7` through
`ts-api-utils` — caused by the bump, so it stayed blocked.

`HTTP 410` means the log expired. That is `unknown`, so it is `blocked`.

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

Batch several dependencies into one subagent when they share an ecosystem. Ten
subagents for ten dependencies wastes time; three grouped subagents do not.

Ask the subagent to report only evidence, with file and line references:

- obfuscated code, long base64 or hex strings, or a new minified file;
- new network calls, new subprocess calls, or new file-system writes;
- reads of environment variables, tokens, keys, or wallet paths;
- a new install script, or a new build step that downloads code;
- a change of maintainer, of signing key, or of the release workflow;
- a diff that is much larger than the version bump promises.

For a major bump, also ask for the documented breaking change in one sentence.
You need it for the impact test above.

Tell the subagent that a minified `dist/` bundle is normal in a GitHub Action.
Only a bundle change that does not match the source change in the same diff is
evidence. That rule found a real one: `svenstaro/upload-release-action` 2.11.5
changed `dist/index.js` by +37822/-33780 with no source change, and also
shipped the maintainer's `.claude/settings.local.json` in the release tag.

The subagent reports `clean`, `suspicious`, or `unknown`. Treat `suspicious`
and `unknown` as `blocked`. A compare page that does not exist is `blocked`,
because the tag does not match the release.

One `suspicious` entry blocks the whole grouped pull request, even when the
other entries are clean.

## Merge

Merge only a pull request that passed every check above. A red check is
acceptable only when it is not required and you showed that the bump did not
cause it.

Use the method that the repository permits:

```bash
gh repo view REPO --json squashMergeAllowed,mergeCommitAllowed
gh pr merge NUMBER -R REPO --squash --delete-branch
```

Prefer squash. Use `--merge` when squash is not permitted. Never rebase.

`--auto` is only useful when the repository has `allow_auto_merge`. Otherwise
it merges at once:

```bash
gh api repos/REPO --jq .allow_auto_merge
```

**`gh pr merge` prints nothing when it succeeds, and it can fail silently in a
loop. Always verify:**

```bash
gh pr view NUMBER -R REPO --json state,mergedAt
```

`Base branch was modified` means Dependabot replaced the pull request while you
worked. It closes the old one with "Looks like these dependencies are updatable
in another way". Find the replacement, record the old row as `skipped`, and
check the new pull request from the start:

```bash
gh pr list -R REPO --author app/dependabot --state open --json number,title
```

Update the ledger after every merge. A failed merge is `state='failed'` with
the error text as the reason.

## Report

One line for each pull request, grouped by result:

- **Merged** — repository, dependency, and version change.
- **Blocked** — the single reason, and the evidence for it.
- **Skipped** — an archived repository, or a superseded pull request.
- **Failed** — the error.

Group the blocked ones by cause, so that one broken workflow does not look like
ten bad dependencies. Four pull requests that all fail `ruleguard / scan` are
one problem.

Close with the count for each group, and the pull requests that need a human.
Name the suspicious dependency first.
