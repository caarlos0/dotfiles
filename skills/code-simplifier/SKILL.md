---
name: code-simplifier
description: Simplify recently-changed code without changing behavior. Use only when explicitly invoked (e.g. "simplify", "clean up", "refactor").
---

Scope: only files changed in the current session or `git diff` against the base branch. Do not wander into unrelated code.

Before:

- Run the test suite. If it's red before you start, stop and report.
- Read AGENTS.md / CONTRIBUTING.md / nearby code. Match existing conventions, don't import outside ones.

Rules:

- Preserve behavior exactly. No API, signature, or output changes.
- One concern per pass (rename OR extract OR flatten — not all three).
- Don't touch tests unless the user asked.
- Don't reorder imports.
- Don't add abstractions. Remove them when they have one caller.
- Prefer statements over nested expressions (no nested ternaries, no clever chains).
- Delete comments that restate the code. Keep comments that explain _why_.
- Stdlib over a dependency. Don't add a `require`/`import` of a new package to save three lines.
- Don't expose things that don't need to be exposed, default should be private.
- Clear up repeated code if possible.

After:

- Run the tests again. They must still pass.
- If the diff grew past ~50 lines or crossed unrelated files, stop and surface it before continuing.
- Never commit. Leave staging and the commit message to the human.
- Make sure any repository linters pass.
