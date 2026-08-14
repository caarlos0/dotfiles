---
name: code-simplifier
description: Final simplification pass over recently changed code without changing behavior. Use after implementation or when explicitly asked to simplify, clean up, or refactor.
---

# Code Simplifier

Run after the behavior is correct. Repository instructions and correctness or
language specialists take precedence; output-style skills affect presentation
only.

## Scope

Inspect only the current change against its base. Follow references outside the
diff only to remove code orphaned by this change or text made false by it.

Read repository instructions and the matching guide under `languages/`:

- TypeScript: `languages/typescript.md`
- JavaScript: `languages/javascript.md`
- Go: `languages/go.md`
- Rust: `languages/rust.md`
- Python: `languages/python.md`
- CSS: `languages/css.md`

## Pass

- Preserve APIs, signatures, outputs, and behavior.
- Remove unnecessary indirection, one-use abstractions, repeated branches, and
  comments that restate code.
- Prefer clear statements over clever expressions.
- Keep small intentional duplication when extraction would obscure behavior.
- Use the standard library instead of adding a dependency.
- Keep visibility private unless callers require otherwise.
- Update comments, docs, errors, and names made false by the change.
- Search the repository before deleting apparently unused code; account for
  tests, registration, reflection, configuration keys, and public consumers.
- Update tests only when needed to preserve coverage after a legitimate
  refactor. Do not weaken assertions or alter expected behavior.

Do not reorder imports, mix unrelated cleanup into the diff, or redesign a
working API. If simplification materially expands the diff, leave the code
alone and explain why.

Use validation already run for the implementation. Run an additional targeted
check only when this pass changes something not covered by it. Never stage or
commit.
