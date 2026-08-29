---
name: go-performance
description: Profile and optimize Go CPU, allocations, GC, concurrency, and I/O with benchmarks and pprof.
---

# Go Performance

Profile before optimizing. Pin the Go version, `GOMAXPROCS`, input, and
benchmark flags. Change one measured bottleneck and compare with `benchstat`.

## Benchmarks

Benchmark production code with `testing.B`. Report allocations and throughput
where relevant:

```go
func BenchmarkEncode(b *testing.B) {
	b.ReportAllocs()
	b.SetBytes(int64(len(input)))
	for b.Loop() {
		Encode(input)
	}
}
```

Use `b.RunParallel` only when contention or scaling is the behavior under test.
Collect multiple samples:

```bash
go test -run='^$' -bench=BenchmarkEncode -benchmem -count=10 ./pkg > old.txt
go test -run='^$' -bench=BenchmarkEncode -benchmem -count=10 ./pkg > new.txt
benchstat old.txt new.txt
```

Use realistic sizes and distributions. Include `benchstat` output with a
performance change; a single `ns/op` result is not evidence.

## Profiles and trace

From tests:

```bash
go test -bench=BenchmarkEncode \
  -cpuprofile=cpu.prof -memprofile=heap.prof \
  -blockprofile=block.prof -mutexprofile=mutex.prof
go tool pprof -http=:8080 cpu.prof
go tool pprof -top -cum -alloc_objects heap.prof
```

For services, expose `net/http/pprof` only on an authenticated internal
listener. Use:

- CPU profile for sampled on-CPU hot paths.
- `allocs` for allocation sites and `heap` for live objects.
- block and mutex profiles for contention.
- goroutine profiles for growth and stuck stacks.
- `go tool trace` for scheduler latency, goroutine transitions, syscalls, GC,
  and network blocking that sampling profiles do not explain.

## Escapes, inlining, and allocations

```bash
go build -gcflags='-m=2' ./pkg/...
```

Escape and inlining diagnostics are leads. Confirm the allocation or call site
in a benchmark or profile before changing ownership.

- Pre-size slices and maps when the size is known:
  `make([]T, 0, n)` and `make(map[K]V, n)`.
- Reuse slice capacity with `s = s[:0]` only when retained backing arrays do not
  pin excessive memory.
- Use `strings.Builder` for strings and `bytes.Buffer` for bytes when repeated
  appends are measured. Do not copy a non-zero Builder; call `Reset` before
  reuse.
- Prefer `strconv.Append*` or `Format*` over `fmt.Sprintf` in formatting hot
  paths.
- Interface conversions and interface calls can cause escapes or prevent
  inlining and devirtualization. They do not always allocate; verify with
  `-gcflags=-m=2` and `-benchmem`.
- Generics do not guarantee faster code. Compare generated code and benchmarks
  before replacing an interface API.

## Pools and memory

`sync.Pool` is for temporary reusable objects that may be discarded at any
time. It provides no retention guarantee. Reset objects before `Put`, validate
state after `Get`, and benchmark pool contention plus retained capacity.

Use heap profiles to distinguish allocation rate from live heap. A large
`alloc_space` profile with a small `inuse_space` profile indicates churn, not a
leak. A goroutine retaining a reference can pin a large object graph.

Tune `GOGC` or `GOMEMLIMIT` only after allocation and GC profiles identify the
trade-off. `GOMEMLIMIT` is a soft runtime memory limit, not an RSS cap.

## Concurrency

- Use block and mutex profiles before replacing locks with channels, atomics,
  sharding, or lock-free structures.
- Use atomics only for small independent state with documented memory-ordering
  invariants.
- Bound goroutine fan-out and queue capacity. Every goroutine needs an exit
  through context cancellation, channel closure, or owned lifecycle.
- Investigate rising goroutine counts with two goroutine profiles under stable
  load; compare which stacks accumulate.
- Avoid holding locks across I/O or callbacks. Keep critical sections small
  without splitting invariants.
- Treat cache-line padding and false-sharing fixes as hardware-specific
  hypotheses; prove them with contention benchmarks.

Invoke `runtime-process-debugging` for child processes, pipes, shutdown, or
scheduler/lifecycle stalls.

## I/O and serialization

Use `bufio.Reader`/`Writer` for repeated small operations and batch small writes.
Reuse byte buffers where ownership is clear. Preserve partial-write handling,
flush errors, EOF, deadlines, cancellation, and ordering.

`encoding/json`, reflection, and struct-tag processing can be hot in
serialization-heavy programs. Profile before adding generated codecs or a
dependency; include compatibility, escaping, number handling, and error behavior
in comparisons.

## PGO and low-level code

Use a representative CPU profile as `default.pgo` and compare:

```bash
go build -pgo=auto ./...
```

PGO can alter inlining and devirtualization, so re-run benchmarks and binary
size checks on the deployment target.

Before `unsafe`, assembly, or architecture-specific code, confirm bounds checks,
dispatch, cache misses, or instructions are material. The low-level version
must outperform safe Go and document its invariant and portability.

## Regression guards

Pin Go and `GOMAXPROCS`. Use focused benchmarks and allocation assertions for
stable invariants. Keep wall time on shared runners advisory unless variance is
controlled.

## Related skills

- `go-conventions` takes precedence for correctness and API design.
- `code-review` checks a completed diff. When invoked from `code-review`, do not
  invoke it again.
- `code-simplifier` runs after the gain is proven.
- `runtime-process-debugging` owns process and lifecycle stalls.

Correctness overrides performance.
