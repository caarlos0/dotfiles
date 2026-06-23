---
name: code-simplifier
description: Simplify recently-changed code without changing behavior. Use by default whenever implementing anything, and when explicitly invoked (e.g. "simplify", "clean up", "refactor").
---

Scope: only files changed in the current session or `git diff` against the base branch. Do not wander into unrelated code. The exceptions, both tied to your change: code it leaves unused (see "Unused code") and stale references to behavior it removed (see "Stale references") may be cleaned up even when they live outside the diff.

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
- Apply YAGNI: don't build for hypothetical future needs. Solve the problem in front of you, nothing more.
- Prefer a clear one-liner over multiple lines when it stays readable. Don't sacrifice clarity for brevity.
- One concern per pass (rename OR extract OR flatten — not all three).
- Don't touch tests unless the user asked.
- Don't reorder imports.
- Don't add abstractions. Remove them when they have one caller.
- Delete code your changes leave unused (see "Unused code" below).
- Prefer statements over nested expressions (no nested ternaries, no clever chains).
- Delete comments that restate the code. Comments should explain _why_, not _what_. This includes comments that just paraphrase the signature or make tautological claims.
- Update or delete comments, docs, and names that describe behavior the change removed (see "Stale references" below).
- Stdlib over a dependency. Don't add a `require`/`import` of a new package to save three lines.
- Don't expose things that don't need to be exposed, default should be private.
- Clear up repeated code if possible.
- Use DRY when it makes sense, even if it means touch code that was already there

Unused code:

Simplifying orphans code — inlining a one-call helper, dropping an abstraction, or DRYing duplication leaves the old definition with no callers. Stale code also accumulates on its own: something added and used once, then left behind by an earlier refactor. After the edits, hunt both down and delete them.

- Look for now-unreferenced functions, methods, types, constants, variables, imports, and whole files.
- Two sources are in scope:
  - Code your change orphaned — follow the chain, even when it leads outside the changed files.
  - Code already stale in the files you're touching — delete it regardless of when it went unused.
- Stay surgical: don't audit the whole repo for unrelated dead code. Stick to the files you're editing and the chain your change reaches.
- Confirm it's dead before deleting. Search the whole repo, not just the diff: references, tests, and indirect uses (reflection, string-keyed dispatch, DI, plugin/config registration, templates). Lean on the compiler or a linter — they beat eyeballing.
- Never delete anything reachable through the public/exported API a consumer could call; that's an API change, forbidden above. When you can't tell, leave it and say so.
- Loop: deleting code orphans its own callees and imports. Repeat until nothing new is dead.

Stale references:

A change outdates more than code. Comments, docstrings, and names that explain a reason, workaround, or behavior the change removed now lie — and a wrong comment is worse than none.

- In the files you touch, update or delete comments, docstrings, and local names that describe the removed reason, the old workaround, or the gone behavior ("we do X because Y" when Y no longer holds).
- When the change retires a specific named reason, workaround, or concept, grep the repo for lingering mentions and fix the ones that are now false — target that one thing, don't audit all prose.
- Don't rename exported/public identifiers to chase this; that's an API change, forbidden above.
- Don't invent a new rationale. Delete what's false; only rewrite a comment when you're sure of the new "why."

After:

- Run the tests again. They must still pass.
- If the diff grew past ~50 lines or crossed unrelated files, stop and surface it before continuing.
- Never commit. Leave staging and the commit message to the human.
- Make sure any repository linters pass — including no new unused-code warnings.
