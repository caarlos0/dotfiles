# CSS simplification

Behavior-preserving simplifications for CSS (and preprocessors like SCSS). Apply only what fits the surrounding code. "Behavior" here means the rendered result — verify nothing shifts visually.

## Shorthands

- Collapse longhands into shorthands when *all* sides are set: `margin: 0 auto`, `padding`, `font`, `background`, `border`, `inset`, `flex`, `grid`. Don't introduce a shorthand that silently resets a property the longhand left untouched.
- Use 3-digit hex (`#fff`) and drop units on zero (`0`, not `0px`).
- Combine selectors that share a declaration block instead of repeating rules.

## Modern layout & functions

- Replace absolute-positioning hacks and float clearfix with flexbox/grid where the file already uses them.
- `gap` instead of margins between flex/grid children.
- Logical properties (`margin-inline`, `padding-block`, `inset`) when the codebase uses them.
- `clamp()` / `min()` / `max()` over media-query stacks that only adjust one value.
- Custom properties (`var(--x)`) to remove repeated literal values — only when a value genuinely repeats with shared meaning.

## Cleanup

- Remove redundant/overridden declarations within the same rule.
- Drop vendor prefixes that autoprefixer or current browser targets make unnecessary.
- Delete `!important` that's no longer needed after specificity is sorted — but don't remove one load-bearing `!important` without checking.
- Remove dead selectors and empty rule blocks — including rules orphaned when your change drops or renames a class/selector. Confirm nothing in the markup/components still references them before deleting.
- Reduce over-qualified selectors (`ul li a` → `nav a`) and deep nesting in SCSS (keep ≤3 levels).

## Avoid

- Don't change specificity in a way that alters which rule wins.
- Don't merge rules whose order matters for the cascade.
- Don't introduce a framework/utility library to replace a handful of rules.
