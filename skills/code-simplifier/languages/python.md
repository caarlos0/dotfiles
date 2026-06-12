# Python simplification

Behavior-preserving simplifications idiomatic to Python (3.9+). Apply only what fits the surrounding code. Follow PEP 8 / PEP 20 — readability counts.

## Control flow

- Early returns / guard clauses over nested `if`.
- Truthiness: `if items:` not `if len(items) > 0:`; `if x is None:` for None checks.
- Comprehensions (list/dict/set/generator) over manual `for` + `append` when there are no side effects — but don't nest comprehensions three deep; a loop is clearer.
- `any()` / `all()` over a loop that flips a boolean flag.
- Replace `if/elif` ladders that map a value with a dict lookup, or `match` (3.10+) where it reads better.

## Idioms

- Unpacking and starred assignment over manual indexing: `first, *rest = xs`.
- `enumerate` over `range(len(...))`; `zip` over parallel indexing.
- `with` for resource management instead of manual open/close try/finally.
- `dict.get(k, default)` / `collections.defaultdict` over `if k in d` dances.
- f-strings over `%` and `.format()`.
- `pathlib.Path` over `os.path` string juggling when the file already leans that way.
- Use `dataclass` instead of a class that's only `__init__` storing fields — but don't restructure a working class under a deadline.

## Cleanup

- Remove unused imports, variables, and debug `print`s.
- Hunt for dead code (orphaned by the change, or already stale in these files): `ruff`/`pyflakes` flag unused imports and locals; `vulture` finds dead functions and classes. Delete what's truly dead.
- Collapse `x = x` style no-ops and redundant `else` after `return`.
- Delete comments that restate code; keep the *why*.
- Use `enumerate`/`items()` instead of indexing into the thing you're iterating.

## Avoid

- Don't add a dependency (e.g. `more-itertools`, `toolz`) for what `itertools`/`functools`/comprehensions cover.
- Don't add type hints to untyped code as part of a "simplify" pass unless asked — that's a separate concern.
- Don't change public function signatures, default args, or kwargs behavior.
- Respect the project's formatter (`black`/`ruff`); never reorder imports by hand if `isort`/`ruff` owns that.
