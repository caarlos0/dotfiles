---
name: code-simplifier
description: Simplify recently-changed code without changing behavior. Use only when explicitly invoked (e.g. "simplify", "clean up", "refactor").
---

Scope: only files changed in the current session or `git diff` against the base branch. Do not wander into unrelated code. The one exception: code your changes leave unused may be deleted even when it lives outside the diff (see "Unused code").

Before:

- Run the test suite. If it's red before you start, stop and report.
- Read AGENTS.md / CONTRIBUTING.md / nearby code. Match existing conventions, don't import outside ones.
- For each language present in the changed files, read the matching guide in `languages/` and apply it on top of the rules below. Map by extension:
  - `.ts`, `.tsx`, `.mts`, `.cts` → `languages/typescript.md`
  - `.js`, `.jsx`, `.mjs`, `.cjs` → `languages/javascript.md`
  - `.go` → `languages/go.md`
  - `.rs` → `languages/rust.md`
  - `.py`, `.pyi` → `languages/python.md`
  - `.css`, `.scss`, `.sass` → `languages/css.md`
  - Any other language: apply the general rules below only.
  - The guide is loaded relative to this SKILL.md. If a guide is missing, proceed with the general rules.

Rules:

- Preserve behavior exactly. No API, signature, or output changes.
- One concern per pass (rename OR extract OR flatten — not all three).
- Don't touch tests unless the user asked.
- Don't reorder imports.
- Don't add abstractions. Remove them when they have one caller.
- Delete code your changes leave unused (see "Unused code" below).
- Prefer statements over nested expressions (no nested ternaries, no clever chains).
- Delete comments that restate the code. Comments should explain _why_, not _what_. This includes comments that just paraphrase the signature or make tautological claims.
- Stdlib over a dependency. Don't add a `require`/`import` of a new package to save three lines.
- Don't expose things that don't need to be exposed, default should be private.
- Clear up repeated code if possible.
- Use DRY when it makes sense, even if it means touch code that was already there

Unused code:

Simplifying orphans code — inlining a one-call helper, dropping an abstraction, or DRYing duplication leaves the old definition with no callers. After the edits, hunt it down and delete it.

- Look for now-unreferenced functions, methods, types, constants, variables, imports, and whole files.
- Confirm it's dead before deleting. Search the whole repo, not just the diff: references, tests, and indirect uses (reflection, string-keyed dispatch, DI, plugin/config registration, templates). Lean on the compiler or a linter — they beat eyeballing.
- Deleting newly-dead code is in scope even when it lives outside the changed files, as long as your change is what orphaned it. Follow the chain.
- Leave pre-existing dead code that was already unused before your change — that's a separate concern.
- Never delete anything reachable through the public/exported API a consumer could call; that's an API change, forbidden above. When you can't tell, leave it and say so.
- Loop: deleting code orphans its own callees and imports. Repeat until nothing new is dead.

After:

- Run the tests again. They must still pass.
- If the diff grew past ~50 lines or crossed unrelated files, stop and surface it before continuing.
- Never commit. Leave staging and the commit message to the human.
- Make sure any repository linters pass — including no new unused-code warnings.
