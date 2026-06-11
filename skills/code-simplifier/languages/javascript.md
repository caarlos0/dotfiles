# JavaScript simplification

Behavior-preserving simplifications idiomatic to modern JavaScript (ES2020+). Apply only what fits the surrounding code.

## Control flow

- Early returns over nested `if`. Flatten the arrow of doom.
- Optional chaining `a?.b` and nullish coalescing `?? fallback` instead of `a && a.b` or `x || default` (the latter breaks on `0`, `''`, `false`).
- `Array` methods (`map`/`filter`/`find`/`some`/`flatMap`) over manual loops when there are no side effects. A plain `for...of` beats a `reduce` that does too much.
- No nested ternaries — use statements.

## Idioms

- `const`/`let`, never `var`.
- Destructuring with defaults instead of manual reads and `||` fallbacks.
- Spread/rest over `Object.assign`, `.concat`, `.apply`, and `arguments`.
- Template literals over string concatenation.
- Arrow functions for callbacks; keep `function` where `this`/hoisting matters.
- `for...of` / `Object.entries` over `for...in` with `hasOwnProperty` guards.
- Remove redundant `return await` outside try/catch.

## Cleanup

- Delete dead branches, unused variables, and console logging left from debugging.
- Collapse an IIFE that no longer needs its own scope.
- Replace promise `.then` chains with `async`/`await` only when it's clearly shorter and the file already uses async.

## Avoid

- Don't pull in lodash/underscore/ramda for what `Array`/`Object`/`structuredClone` already do.
- Don't convert a working module format (CJS/ESM) — that's not simplification.
- Don't change exported function signatures or argument shapes.
