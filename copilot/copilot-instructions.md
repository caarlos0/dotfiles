# Copilot Instructions

## General Principles

- **Verify before fixing**: Confirm bug is triggerable by user before fixing. No fixes for theoretical issues in unreachable code paths.
- **Understand before changing**: Understand why existing code works before modifying. No redesigning APIs, protocols, or data flows unless asked.
- **Run and verify**: Run scripts/code after modifying to confirm they work. Prove correctness, don't assume.
- **Keep it simple**: Prefer straightforward solutions. No defensive code (retries, timeouts, guards) without evidence problem exists. Less code is better.

## Commit Conventions

- [Conventional Commits](https://www.conventionalcommits.org/) with scope when applicable (e.g., `fix(git): ...`, `feat(fish): ...`).
- One logical change per commit.
- Commits signed off (`-s` flag) — configured in gitconfig.
- **Don't commit speculative or exploratory work unless explicitly asked.** When the user says "yes" to a suggested change, treat it as approval for the change — not for committing or pushing. Wait for an explicit "commit" (or `/caveman-commit`) before creating commits.

## Git Workflow

- **Always merge, never rebase, when integrating an upstream branch (e.g. `main`) into a feature branch.** Use `git merge` or `git pull --no-rebase`. Never run `git pull --rebase`, `git rebase <upstream>`, or a bare `git pull` (the local default may be rebase). Branches preserve merge topology intentionally; rebasing flattens history and forces reflog recovery.
