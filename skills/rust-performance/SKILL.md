---
name: rust-performance
description: Profile and optimize Rust CPU, memory, I/O, async, and build performance with representative benchmarks.
---

# Rust Performance

Profile first, then change one measured bottleneck. Report the workload, tool,
target, toolchain, build profile, and before/after values.

## Measure Rust, not debug builds

Use optimized code with symbols:

```toml
[profile.profiling]
inherits = "release"
debug = "line-tables-only"
```

Use Criterion for microbenchmarks and `std::hint::black_box` only where the
compiler could fold inputs or remove results. For CPU profiles use the
repository's profiler, `samply`, `perf`, Instruments, or `cargo flamegraph`.
Use DHAT or an allocation profiler when CPU samples point to allocation.

## Allocations and ownership

- Pre-size known growth with `Vec::with_capacity`, `String::with_capacity`, and
  `HashMap::with_capacity`.
- Use `clone_from` when replacing an existing value can reuse its allocation.
- Use `Cow` at boundaries where most callers borrow and few need ownership.
  Do not spread it through APIs without evidence; it adds branching and type
  complexity.
- `SmallVec` and other inline collections help only when the observed length
  distribution usually fits inline. Their inline storage increases value and
  stack size.
- Inspect hot type sizes with `size_of`, `-Zprint-type-sizes`, or a type-size
  tool. Box a rare large enum variant only when shrinking the common value
  improves the workload.
- Reuse buffers across iterations when ownership is clear. Do not pool small
  values whose allocation is not visible in a profile.

For maps, use the entry API to avoid duplicate lookups and reserve capacity
when the size is known. Alternative hashers trade collision resistance,
dependencies, and portability for throughput; use them only for trusted keys
after representative key-distribution benchmarks.

## Iterators, strings, and bytes

- Implement an accurate `size_hint` for custom iterators consumed by `collect`
  or `extend`.
- Avoid `collect` when the result is immediately iterated once; keep the chain
  lazy. Collect when ownership, sorting, indexing, or reuse requires it.
- Prefer iterating slices to repeated indexing in hot loops; this often makes
  bounds-check elimination easier.
- Reuse `String`, `Vec<u8>`, or `bytes::BytesMut` buffers instead of formatting
  or allocating per item. Work with `&[u8]` for genuinely byte-oriented data;
  do not discard Unicode or path semantics for speed.
- Keep `Path`/`OsStr` values native. Avoid string conversion solely for
  comparison or joining.

## I/O

Use `BufReader`/`BufWriter` for repeated small operations and choose capacity
from observed request sizes. Batch writes and reuse read buffers. Preserve
partial-write handling, flush errors, EOF behavior, and output ordering; a
faster path that changes them is incorrect.

## Async and concurrency

- Never perform long CPU work, blocking syscalls, or synchronous sleeps on an
  async executor thread. Use `spawn_blocking` for bounded blocking work and
  Rayon or a dedicated pool for sustained CPU parallelism.
- Prefer `std::sync::Mutex` when the guard never crosses `.await`; use an async
  mutex only when it must. Profile contention before replacing either.
- Use bounded channels when producers can outrun consumers. Select `mpsc`,
  `oneshot`, `watch`, or `broadcast` from message semantics, not benchmark
  folklore.
- Audit cancellation and losing `select!` branches before batching or
  buffering. Work discarded on cancellation is still cost.
- Account for oversubscription when Tokio blocking threads, Rayon, native
  libraries, and application threads share the same CPUs.
- Check task ownership, queue depth, and shutdown. Leaked tasks and unbounded
  queues commonly look like memory or latency regressions.

Invoke `runtime-process-debugging` for process, pipe, EOF, child-lifecycle, or
shutdown stalls.

## Build and low-level tuning

Benchmark `lto`, `codegen-units`, `opt-level`, panic strategy, allocator, PGO,
and linker changes separately. `target-cpu=native` is valid only for fixed
deployment hardware; it makes distributed artifacts non-portable.

Before adding SIMD or `unsafe`, verify the hot instruction sequence and whether
the compiler already removed bounds checks or vectorized it. Prefer safe loop
shapes first. Every `unsafe` optimization needs a precise invariant, tests that
exercise it, and a measured win over the safe version.

## Regression guards

Use a focused Criterion benchmark, allocation guard, or compile-time size
assertion only for the invariant that matters. Keep wall-time on shared CI
advisory unless hardware and variance are controlled. Pin the Rust toolchain
when compiler code generation affects the comparison.

## Related skills

- `rust-specialist` takes precedence for correctness, safety, and API design.
- `code-review` checks a completed diff. When invoked from `code-review`, do not
  invoke it again.
- `code-simplifier` runs after the gain is proven and preserves measured
  behavior.
- `runtime-process-debugging` owns process and lifecycle stalls.

Correctness and safety override performance.
