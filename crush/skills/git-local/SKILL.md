---
name: git-local
description: Prefer local git commands over GitHub MCP tools for operations on the current repository. Use when asked about commits, diffs, file history, branches, logs, blame, or viewing file contents at specific revisions in the current repo.
---

# Git Local-First Operations

**Always prefer local git commands over GitHub MCP tools when working in the current repository.**

## When to Use Local Git

Any operation that can be done locally:
- Viewing commits (`git show`, `git log`)
- Viewing files at revisions (`git show <sha>:<path>`)
- Diffs (`git diff`)
- Blame (`git blame`)
- Search (`git grep`)
- Branch operations (`git branch`, `git log main..HEAD`)

## When to Use GitHub MCP

Only for remote-only operations:
- PR metadata, reviews, CI status (`mcp_github_pull_request_read`)
- Issues (`mcp_github_issue_read`)
- Operations on OTHER repositories (not the current working directory)
