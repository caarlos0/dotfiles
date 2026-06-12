# TypeScript simplification

Behavior-preserving simplifications idiomatic to TypeScript. Apply only what fits the surrounding code.

## Types

- Let inference work. Drop annotations the compiler already infers (`const n = 1`, not `const n: number = 1`). Keep annotations on exported/public APIs and function parameters.
- Replace `any` with `unknown` plus narrowing, or a precise type — but only if behavior is unchanged. Don't invent types under a deadline.
- Prefer union literals over `enum` when the values are only used as values. Don't rewrite an `enum` that's part of a public API.
- Use `interface` vs `type` consistently with the file. Don't churn one into the other.
- Collapse redundant generics: if a type parameter is used once, it's probably not needed.

## Control flow

- Replace `if/else` chains that assign one variable with early returns or a lookup object.
- Use optional chaining `a?.b?.c` and nullish coalescing `?? fallback` instead of nested `&&` guards or `||` that misfires on `0`/`""`.
- Prefer `Array.prototype` methods (`map`/`filter`/`find`/`some`) over manual index loops when there are no side effects — but a plain `for...of` is clearer than a chained `reduce` doing five things.
- Avoid nested ternaries; use statements.

## Idioms

- Object/array destructuring with defaults instead of manual property reads.
- Spread/rest over `Object.assign` and `.apply`.
- Template literals over string concatenation.
- Remove redundant `async`/`await` (e.g. `return await x` where no try/catch — but keep it inside try blocks where it changes stack traces/catch behavior).
- Drop non-null assertions `!` when a guard or optional chaining expresses intent more safely.

## Cleanup

- Hunt for code the change orphaned: `tsc` with `noUnusedLocals`/`noUnusedParameters` flags unused locals and params; `knip`/`ts-prune` find unused exports and files. Delete what's truly dead.

## Avoid

- Don't add a runtime dependency (lodash, ramda) to save a few lines stdlib/`Array` already covers.
- Don't introduce decorators, classes, or DI to replace a plain function.
- Don't widen or change exported types — that's an API change.
