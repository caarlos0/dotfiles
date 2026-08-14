---
name: go-conventions
description: Carlos Becker's Go implementation and review conventions. Use when writing or reviewing Go in caarlos0, GoReleaser, nFPM, env, svu, fang, and related projects.
---

# Go Conventions

Follow repository instructions first. Prefer idiomatic, unsurprising Go with a
small public surface and few dependencies.

- Use the standard library unless a dependency provides clear, necessary value.
  Every new `require` in `go.mod` needs justification.
- Wrap errors with context using `%w`; use `errors.Is` and `errors.As`. Error
  messages are lowercase, have no trailing punctuation, and say what failed.
- Put implementation details in `internal/`. Define interfaces at the consumer
  and add generics or functional options only when concrete callers need them.
- For CLIs, follow existing Cobra and fang patterns rather than introducing a
  second framework.
- Use struct tags for declarative configuration when the repository already
  follows that pattern.
- Write surgical regression tests with `testify/require`. Use per-case `t.Run`;
  use tables only when cases genuinely share a shape. Keep decisive assertions
  at the failing test line rather than hiding them in helpers.
- Discover and use repository `make` targets such as `test`, `lint`, `build`,
  and `ci`; do not assume they exist.
- Keep release and container changes reproducible. Follow existing GoReleaser
  configuration and pin container images to digests when that is the repository
  convention.

Run `gofmt` and the repository's existing targeted tests and lint commands. Do
not add retries, timeouts, abstractions, or compatibility layers without a
demonstrated problem.
