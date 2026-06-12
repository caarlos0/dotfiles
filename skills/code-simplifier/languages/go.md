# Go simplification

Behavior-preserving simplifications idiomatic to Go. Apply only what fits the surrounding code. Favor clarity over cleverness — Go rewards boring.

## Errors

- Return early on error; keep the happy path un-indented.
- `if err != nil { return ..., err }` — don't wrap unless you add context with `fmt.Errorf("...: %w", err)`. Remove redundant wrapping that adds no information.
- Don't swallow errors with `_` unless intentional and obvious.

## Control flow

- Collapse `if x { return true } return false` into `return x`.
- Use early returns instead of `else` after a return.
- A `switch` (even `switch {}` with no tag) beats a long `if/else if` ladder.
- Prefer `range` over index loops when the index is unused.

## Idioms

- Drop redundant type declarations: `var xs []int` over `xs := []int{}` when empty; `:=` where the type is obvious.
- Use composite literals directly instead of allocating then assigning fields one by one.
- Zero values are usable — don't initialize a struct field to its zero value, and don't write constructors that only set zero values.
- `strings.Builder` over `+=` in loops only if it's already hot; otherwise leave readable concatenation.
- Remove a one-line helper that's called once and obscures intent; inline it. Conversely, don't add helpers/interfaces with a single caller.
- Accept interfaces, return structs — but don't introduce an interface that has one implementation just to "abstract".

## Cleanup

- Delete comments that restate the code; keep `// why`.
- Remove unused struct fields, params, and named returns that add nothing.
- Hunt for code the change orphaned: the compiler flags unused imports and locals; `staticcheck` and `deadcode` (golang.org/x/tools) catch unused funcs, types, and fields. Delete what's truly dead.

## Avoid

- Don't add a dependency for what `strings`, `slices`, `maps`, `cmp` (Go 1.21+) already do.
- Don't introduce generics to replace a couple of concrete functions unless it genuinely removes duplication.
- Always leave `gofmt`/`goimports` formatting intact; never reorder imports by hand.
