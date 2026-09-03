---
name: dependabot-merge
description: Review and merge open dependency pull requests from Dependabot, Renovate and similar bots, across one or more organizations or users. Use for dependency update triage, supply-chain checks on bumps, or bulk dependency merges.
user_invocable: true
---

# Dependabot Merge

Merge safe dependency updates. Stop and report the unsafe ones. Never merge a
pull request that you did not check in this run.

The checks are the same for every dependency bot. Only the discovery query and
the place that holds the update metadata change. See "Which bots".

## Scope

The argument can name more than one owner, and can mix them, for example
`org goreleaser and user caarlos0`. Without an argument, use the current user:

```bash
gh api user -q .login
```

**Never widen the scope on your own.** A user belongs to many organizations
that they do not maintain. Merging there affects other people. List them:

```bash
gh api user/orgs --jq '.[].login'
```

Then ask which ones to process, and default to the owners the user clearly
controls. Do not merge in a shared community organization without a clear yes.

## Ledger

Keep a ledger, so that a second run does not check the same pull request again.
Create it once per run with the `sql` tool:

```sql
CREATE TABLE IF NOT EXISTS dependabot_prs (
  url TEXT PRIMARY KEY,
  repo TEXT, number INTEGER, title TEXT,
  bot TEXT,       -- dependabot | renovate | pre-commit-ci | ...
  state TEXT,     -- pending | merged | skipped | blocked | failed
  reason TEXT,
  checked_at TEXT
);
```

Write a row with `state='pending'` when you find a pull request. Update the row
immediately after each decision. Read the ledger before each step and process
only `pending` rows. Report the terminal rows again at the end, but do not
check them again.

## Which bots

Handle every dependency bot, not only Dependabot. They differ in three ways:
the author login, where the update metadata lives, and the branch prefix.

| Bot         | Author login        | Metadata lives in            | Branch prefix |
| ----------- | ------------------- | ---------------------------- | ------------- |
| Dependabot  | `dependabot[bot]`   | `updated-dependencies:` block in the commit body | `dependabot/` |
| Renovate    | `renovate[bot]`     | a table in the **pull request body** | `renovate/`   |
| Mend/self-hosted Renovate | a custom account, often `renovate-bot` | same as Renovate | `renovate/` |
| pre-commit.ci | `pre-commit-ci[bot]` | the pull request body; edits `.pre-commit-config.yaml` | `pre-commit-ci-update-config` |

**Renovate has no commit metadata block.** Its versions live in a markdown
table in the pull request body, next to a `<!--renovate-debug:...-->` comment:

```bash
gh pr view NUMBER -R REPO --json body -q .body
```

That table is generated at the same time as the diff, but it is still a
summary. The rule below does not change: **read the diff.**

Two Renovate-only things to watch:

- A pull request that edits `renovate.json`, `.github/renovate.json` or
  `.renovate.json` is a **configuration** change, not a dependency bump. It is
  outside the manifest/lockfile/workflow allowlist, so it is `blocked` for a
  human.
- Renovate can run `postUpgradeTasks` and custom managers, so it can touch
  files a version bump does not explain. Treat any such file as a block.

## Collect

`gh search prs` takes only one `--author`, and a second flag silently replaces
the first. To cover several bots in one query, use the search API, where a
repeated `author:` qualifier means OR:

```bash
gh api -X GET search/issues -f per_page=100 \
  -f q='is:pr is:open draft:false org:OWNER author:app/dependabot author:app/renovate' \
  --jq '.items[] | "\(.user.login)\t\(.html_url)\t\(.title)"'
```

Keep the `q` value on one line. A newline inside it makes the search API reject
the whole query with `422 Validation Failed`.

Use `user:OWNER` instead of `org:OWNER` for a personal account, and repeat the
qualifier to cover both. Add any self-hosted bot with a plain
`author:renovate-bot` (no `app/` prefix, because it is a normal account).

**Do not trust `is_bot`.** In `gh search prs` output, `dependabot[bot]` reports
`is_bot: false`. Match on the login instead.

Insert the results into the ledger, recording which bot opened each one.

Use single quotes for every SQL string. SQLite rejects a double-quoted literal
that does not name a column, and the whole insert fails.

Fetch the facts for all of them in parallel, then triage from one table
instead of one round trip per pull request. Write the worker to a file: on
macOS, `xargs -I` combined with `-n 1` and a long inline `sh -c` fails with
`command line cannot be assembled, too long`.

```bash
cat > fetch.sh <<'EOF'
#!/bin/sh
gh pr view "$1" --json number,url,author,isDraft,mergeable,mergeStateStatus,\
files,commits,statusCheckRollup > "out/$(echo "$1" | tr '/:' '__').json" 2>&1
EOF
chmod +x fetch.sh
xargs -P 8 -I{} ./fetch.sh {} < urls.txt
```

## Check each pull request

Get the facts in one call:

```bash
gh pr view URL --json number,author,isDraft,mergeable,mergeStateStatus,\
reviewDecision,files,commits,statusCheckRollup
```

The commit body holds the metadata in the `updated-dependencies:` block:
`dependency-name`, `dependency-version`, `dependency-type`, and `update-type`.
A grouped update lists many entries. Check every entry. Renovate puts the same
information in the pull request body instead — see "Which bots".

**The metadata can disagree with the diff. The diff wins.** The bot rebases and
the summary goes stale. One pull request declared
`dependency-version: 5.24.0` and `update-type: version-update:semver-minor`
while `gh pr diff` showed `5.22.0` to `6.0.0`. Another declared
`dependency-version: 10.0.1` while the workflow comment still read `# v6.6.1`
and the real old pin was `v8.2.0` — three different answers, and only the diff
was right. Read the diff before you call a bump minor:

```bash
gh pr diff NUMBER -R REPO -- package.json go.mod
```

For a pinned action, the comment after the SHA is decoration and can be stale.
Resolve the SHA itself:

```bash
gh api repos/OWNER/REPO/tags --paginate \
  --jq '.[] | select(.commit.sha=="NEWSHA") | .name'
```

Set `state='blocked'` and continue to the next pull request if any of these is
true:

- the author is not the expected bot, or a commit has a different author;
- `mergeable` is `CONFLICTING`;
- **a _required_ check failed** — see "Which checks matter";
- the diff changes a file that is not a manifest, a lockfile, or a workflow
  (lockfiles include `uv.lock`, `flake.lock`, `Cargo.lock`, `pnpm-lock.yaml`),
  or it changes the bot's own configuration;
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

Query the advisory database for **both** versions, not only the new one:

```bash
gh api '/advisories?ecosystem=ECOSYSTEM&affects=NAME@VERSION&per_page=5' \
  --jq '.[] | {ghsa_id, severity, summary}'
```

An open advisory that affects the new version blocks the merge. An advisory
that the bump repairs is a reason to merge — name the GHSA in the report,
because it tells the maintainer which merges are urgent.

**An upgrade is not automatically a fix.** Check that the new version is
outside the vulnerable range, not merely newer. `golang.org/x/image` 0.20.0 to
0.38.0 looked like a big catch-up, but GHSA-q675-qj96-32m9 is patched only in
0.41.0, so the bump landed still vulnerable. Block, and say which version
would actually close it.

### A check that fails everywhere is one broken tool

Before blaming any bump, ask whether the same check fails in unrelated
repositories. If it does, it is a broken tool, and it is one problem rather
than many. A `ruleguard / scan` job failed on seven pull requests across four
repositories with `internal error: package "context" without types`, because
the workflow installs it with `go install ...@latest` against a newer Go. It
even failed on a pull request that only edited YAML, which the linter never
reads — proof on its own that no bump caused it.

Two signals that a red check is not the bump's fault:

- the same failure appears on the base branch;
- the failing job cannot read any file the diff touched.

Ask the user whether a recurring failure is known-broken, and once they say it
is, stop re-deriving it in later runs.

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

## Comment on the pull request

When a pull request is blocked for anything a reader would call suspicious,
**post the evidence as a comment on that pull request**, then leave it open.
The finding belongs where the next person will look, not only in the report.

Comment for a supply-chain finding: a maintainer set that shrank, a repository
that moved, a bundle that does not match its source, an unexplained file in a
release tag, an advisory the bump fails to close, or a version published inside
the cool-down. A plain red test or a merge conflict does not need a comment.

Write the comment so it stands on its own:

- name the finding in the first line, and say the pull request was not merged;
- show the evidence, with the exact numbers or the two version strings;
- **say what is _not_ wrong**, so nobody re-does the work — for example that
  the maintainer who remains is the long-standing lead, or that a large bundle
  diff is explained by an ESM migration in the same commit;
- give the smallest action that unblocks it, such as splitting one dependency
  out of a group or targeting a later patch version;
- if the blocked bump also fixes advisories, say so, so it is not left to rot.

Markdown bodies with backticks break shell heredocs. Write the body to a file
first, then:

```bash
gh pr comment NUMBER -R REPO --body-file comment.md
```

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

`--delete-branch` fails with `Cannot use -d or --delete-branch when merge queue
enabled`. Drop the flag for those repositories.

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

`Base branch was modified` means the bot replaced the pull request while you
worked. Dependabot closes the old one with "Looks like these dependencies are
updatable in another way"; Renovate silently force-pushes the same branch
instead. Find the replacement, record the old row as `skipped`, and check the
new pull request from the start:

```bash
gh pr list -R REPO --author app/dependabot --state open --json number,title
```

Update the ledger after every merge. A failed merge is `state='failed'` with
the error text as the reason.

**Watch what your own merges did.** A merged bump can break the default branch
even when the pull request was green, because a workflow may not run on pull
requests at all. After a batch, check the default branch, and establish whether
a red run predates the merge before claiming either way:

```bash
gh run list -R REPO --branch "$(gh api repos/REPO --jq .default_branch)" \
  --limit 6 --json conclusion,workflowName,createdAt
```

A run with `0` jobs and "workflow file issue" is a broken workflow file or an
unreachable reusable workflow, not a dependency problem.

## Report

One line for each pull request, grouped by result:

- **Merged** — repository, dependency, and version change. Mark the ones that
  close an advisory, and name the GHSA.
- **Blocked** — the single reason, and the evidence for it.
- **Skipped** — an archived repository, or a superseded pull request.
- **Failed** — the error.

Group the blocked ones by cause, so that one broken workflow does not look like
ten bad dependencies. Four pull requests that all fail `ruleguard / scan` are
one problem.

Close with the count for each group, and the pull requests that need a human.
Name the suspicious dependency first, and call out any blocked pull request
that is holding back a security fix, because those must not sit forever.

Expect to be asked "what is left?" — every blocked row needs a reason a person
can act on, not just a status.

## Gotchas

- `gh repo view --json defaultBranch` is not a field. Use `defaultBranchRef`,
  or `gh api repos/REPO --jq .default_branch`.
- A `403` from the rules API means a private repository on a plan that hides
  them. Trust `mergeStateStatus` instead.
- On a private repository the only pull-request check may be a linter while the
  real build never runs there. Weak signal — say so rather than implying the
  bump was proven safe.
- `HTTP 410` on a job log means it expired. That is `unknown`, so `blocked`.
- Merging one pull request can make a sibling in the same repository conflict.
  Merge, then re-poll the rest instead of trusting the earlier snapshot.
