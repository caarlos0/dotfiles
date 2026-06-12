# Rust simplification

Behavior-preserving simplifications idiomatic to Rust. Apply only what fits the surrounding code. Let the compiler and `clippy` guide you.

## Error & option handling

- Use `?` instead of `match`/`if let` that only forwards the error.
- `map`/`and_then`/`unwrap_or`/`unwrap_or_else`/`ok_or` over verbose `match` on `Option`/`Result`.
- Replace `match x { Some(v) => ..., None => ... }` with `if let` / `let else` when one arm is trivial.
- Don't replace an explicit `match` with `.unwrap()` — that changes panic behavior.

## Iterators & control flow

- Iterator chains (`map`/`filter`/`collect`/`sum`/`any`) over manual `for` + `push` when there are no side effects.
- `let Some(x) = opt else { return }` (let-else) to flatten nesting.
- Early returns over deep nesting.
- Pattern matching / destructuring over field-by-field access.

## Idioms

- Borrow instead of clone: take `&str` over `String`, `&[T]` over `&Vec<T>` in function args. Remove `.clone()` that exists only to dodge the borrow checker when a borrow works.
- `impl Trait` in argument position instead of an unused generic parameter.
- Derive (`Debug`, `Clone`, `Default`, `PartialEq`) instead of hand-written impls that do the obvious thing.
- Use `Default::default()` / struct update syntax `..Default::default()` instead of setting every field.
- `if let` chains and `matches!()` for boolean checks.

## Cleanup

- Remove needless `return`, `;`-then-`return`, and explicit `.into()`/`as` casts the compiler infers.
- Drop lifetimes the compiler can elide.
- Delete `#[allow(...)]` that no longer suppresses anything.
- Hunt for code the change orphaned: the compiler's `dead_code`/`unused` warnings and `cargo clippy` flag unused items. Delete it — don't silence it with `#[allow(dead_code)]`.

## Avoid

- Don't add a crate for what `std` (`std::fmt`, `itertools`-like via `Iterator`) already covers.
- Don't introduce traits/generics with one implementor to "abstract".
- Don't change `pub` API signatures or trait bounds.
- Keep `rustfmt` formatting; run `clippy` and honor its behavior-preserving suggestions.
