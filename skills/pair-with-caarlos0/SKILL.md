---
name: pair-with-caarlos0
description: Carlos Becker's (@caarlos0) programming style, conventions, and review habits. Use whenever pairing with Carlos on code, reviewing his PRs/issues, contributing to his projects (GoReleaser, nFPM, env, svu, fang, dotfiles, etc.), writing Go CLIs in his style, or any time the user asks to "pair with caarlos0", "code like caarlos0", or work in a way that matches his preferences.
---

# Pair with @caarlos0

Carlos Becker. Builds CLIs in Go. Maintains GoReleaser, nFPM, env, svu, fang, and a pile of others. Optimizes for **boring reliability over years**, not novelty.

## Five principles

1. **Yes is forever.** Every feature is permanent maintenance. Default answer is no. Burden of proof is on the new code.
2. **Solve a real problem you have.** If there's no concrete user (often: me), don't build it.
3. **Boring beats clever.** Predictable, stable, documented > shiny. Users want it to still work in 3 years.
4. **Small surface, extensible inside.** Tight public API; options/hooks/struct tags for extension.
5. **Ship small, ship often.** One change per commit. One concern per PR. Tag and release frequently.

## How I write Go

- Idiomatic Go. `gofmt` + `golangci-lint`. No fights with the linter.
- **Few dependencies.** New `require` in `go.mod` needs justification in the PR. `pkg/errors` is gone; use `errors.Is/As` and `fmt.Errorf("...: %w", err)`.
- **Cobra + fang** for CLIs (`charmbracelet/fang` for styled help/errors/version). Cobra alone is fine for libraries-with-a-tool.
- **Struct tags for declarative config.** See `env`:
  ```go
  type Config struct {
      Port int    `env:"PORT" envDefault:"8080"`
      Host string `env:"HOST,required"`
  }
  ```
- **Functional options** for extensibility without bloating the API:
  ```go
  func New(opts ...Option) *Thing { /* ... */ }
  ```
- **Tests use `testify/require`** + per-case `t.Run` subtests. Table-driven when cases share shape; one `Test...` function per case when they don't. Unique fake data per case so failures are unambiguous.
  ```go
  require.NoError(t, err)
  require.EqualError(t, err, "exact message")
  require.Len(t, got, 2)
  ```
- **Bug fix = surgical diff + a regression test** named after the bug. No drive-by refactors in a fix PR.
- **`internal/`** for anything not part of the public API. Keep the exported surface small.
- **Errors are messages to humans.** Lowercase, no trailing punctuation, say what failed and why. Wrap with context.
- Generics only when they actually remove duplication. Same for interfaces — define them at the consumer.

## How I run things

- `make` is the entry point: `make test`, `make lint`, `make build`, `make ci`. CI runs the same targets.
- **GoReleaser** for releasing (obviously). Reproducible builds, cross-compilation, signed.
- **Dockerfiles pin to digests** and pull static binaries from upstream images via multi-`FROM`:
  ```dockerfile
  FROM anchore/syft:v1.42.4@sha256:... AS syft
  FROM gcr.io/projectsigstore/cosign:v3.0.6@sha256:... AS cosign
  FROM golang:1.26-alpine@sha256:...
  COPY --from=syft   /syft           /usr/bin/syft
  COPY --from=cosign /ko-app/cosign  /usr/bin/cosign
  ```
- GitHub Actions for CI. Retry external calls on 5xx — flakes are real.

## How I commit and PR

- **[Conventional Commits](https://www.conventionalcommits.org/) with scope.** Examples from real history:
  - `fix(build): allow explicit binary with ellipsis when single main`
  - `feat: add fang support for styled CLI output`
  - `fix(rust): glibc version stripping for gnueabi/gnueabihf targets`
  - `docs: fix image URLs`
- **Sign off every commit** (`git commit -s`).
- **One logical change per commit. One concern per PR.** Include the test. Include the doc update if behavior changed.
- **Issue first** for anything non-trivial: problem, repro, proposed solution. Then PR.

## How I review

- Short, specific, actionable. Suggest the diff inline when it's small.
- Push back hard on:
  - new dependencies without justification
  - new config flags without a real user
  - "while I'm here" refactors mixed into bug fixes
  - breaking changes without a deprecation path
  - tests that don't actually assert behavior
  - `interface{}`/`any` used to dodge a type
- Be positive when deserved. Acknowledge effort. But don't merge to be nice.

## Defaults / Don'ts

**Default to:**
- Less code over more code.
- Stdlib over a dep.
- A function over a new abstraction.
- A struct field over a new package.
- Reading the existing patterns in the repo before inventing new ones.

**Don't:**
- Add retries, timeouts, or guards without evidence the problem exists.
- Rewrite something that works.
- Hide assertions in test helpers — failures should point at the line that matters.
- Submit a PR that touches files unrelated to the title.
- Promise long-term support I can't deliver. If I'm overwhelmed, I open a "looking for co-maintainers" issue (see `caarlos0/env#407`, `caarlos0/svu#283`) — that's healthier than burning out quietly.

## Tooling

Terminal-first. **fish** shell. **neovim**. **ghostty**/**rio**. Dotfiles managed by a `./setup` shell script — no Nix/Ansible, the script is 100 lines and I can read it.
