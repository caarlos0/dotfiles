---
name: issue-validator
description: Verify a GitHub issue against current code and related pull requests. Use for issue triage, stale reports, duplicates, regressions, or "is this still true?" investigations.
---

# Issue Validator

Validate before proposing or making a fix.

1. Fetch the issue, comments, labels, and referenced pull requests with `gh`.
2. Resolve the target branch and inspect its current code, not only the issue's
   cited revision.
3. Translate stale paths, symbols, and line numbers through renames or ports.
4. Trace the reachable user path and reproduce the behavior when practical.
5. Search open and merged pull requests plus recent history for fixes,
   regressions, duplicates, and conflicting changes.
6. Classify the issue as `valid`, `partially valid`, `fixed`, `duplicate`,
   `superseded`, or `not reproducible`.

Separate confirmed facts from hypotheses. A code smell in an unreachable path
does not validate an issue. Do not edit by default; end with the smallest
justified next action and current file/symbol references.
