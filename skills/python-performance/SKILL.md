---
name: python-performance
description: Profile and optimize Python CPU, memory, I/O, concurrency, and numerical performance.
---

# Python Performance

Name the metric first: wall time, CPU time, allocation count, retained heap,
peak RSS, or I/O wait. Pin Python, dependencies, input, and environment; then
change one profiled cause.

## Measurement

- Use `pyperf` for repeatable benchmarks with calibration, worker processes,
  metadata, and statistical comparison.
- Use `timeit` only for small fragments. It disables cyclic GC during timing
  unless explicitly re-enabled, which can make allocation-heavy code look
  unlike production.
- Use `cProfile` for call counts and cumulative development profiles; use a
  sampling profiler such as `py-spy` for lower-overhead process observation.
- Use `tracemalloc` for Python-managed allocations. If RSS grows while its
  traces remain stable, inspect native allocations or fragmentation with
  Memray or an OS profiler.
- `sys.getsizeof` is shallow; it does not measure referenced objects.
- Use `python -X importtime` before changing startup imports.

## Data structures and Python operations

Choose from access patterns:

| Need | Prefer |
|---|---|
| Membership or deduplication | `set` or `dict`, not repeated list scans |
| Queue operations at both ends | `collections.deque`, not `list.pop(0)` |
| Priority queue | `heapq` |
| Search in maintained sorted data | `bisect` |
| Mutable binary accumulation | `bytearray`, then `bytes(buffer)` |
| Many string fragments | collect fragments and `"".join(parts)` |

These choices change semantics and memory. Do not replace a list when callers
need indexing, slicing, or compact iteration.

Generators avoid eager materialization but add iteration overhead and cannot be
reused. Built-ins and comprehensions often move work into optimized C loops,
but they are not automatically faster for every workload.

`lru_cache` trades CPU for retained memory and invalidation. On an instance
method, cache keys retain `self`; avoid it when instances must be collected.
`@dataclass(slots=True)` or `__slots__` can reduce memory for many instances but
affects dynamic attributes, inheritance, weak references, serialization, and
framework integration.

## Memory and GC

CPython uses reference counting plus cyclic GC. Distinguish:

- growing Python allocation traces;
- retained reachable objects;
- native allocations;
- allocator fragmentation;
- peak RSS;
- allocation churn that increases CPU without retaining memory.

High RSS alone is not a leak. Tune GC thresholds, call `gc.freeze()`, or change
allocators only after pause, allocation, or copy-on-write measurements identify
the collector or allocator as the cause. GC defaults differ by Python version
and free-threaded build.

## Threads, asyncio, and processes

- Threads overlap many blocking I/O operations because those calls release the
  GIL. Pure-Python CPU threads do not execute bytecode in parallel under the
  normal GIL; native extensions may release it.
- `asyncio` is cooperative concurrency. Any blocking call or long CPU loop in a
  coroutine stalls the event loop. Use bounded queues when producers can outrun
  consumers, and preserve cancellation and shutdown.
- Processes provide CPU parallelism but add startup, pickling, IPC, memory, and
  failure handling. Include all of those in the benchmark.
- Start methods vary by platform and Python version. Libraries should not force
  a global method without owning application lifecycle.
- Free-threaded CPython enables parallel Python threads but adds evolving
  overhead, synchronization requirements, and extension compatibility. Test the
  exact interpreter and dependency set.

## I/O and services

- Use buffering for repeated small reads and writes. `readinto()` can reuse a
  buffer in measured binary pipelines but adds ownership complexity.
- Batch database and network operations to reduce round trips. Oversized
  batches increase memory, lock duration, tail latency, and retry scope.
- Avoid constructing expensive log messages when the level is disabled. Queue
  handlers move slow output off latency-sensitive threads but require bounded
  capacity, ordering, loss, and shutdown decisions.
- Preserve flush, EOF, error, retry, ordering, cancellation, and protocol
  behavior when optimizing I/O.

## NumPy and native acceleration

- Chained NumPy operations can allocate full-size temporaries. Use `out=`,
  in-place operations, chunking, or fused kernels only after CPU and memory
  profiles show the temporary matters.
- Check contiguity and strides when native kernels copy or traverse arrays
  poorly. Normalize layout once at a boundary, not repeatedly in a loop.
- BLAS, process pools, application threads, and runtimes can each create worker
  pools. Measure oversubscription before limiting them with `threadpoolctl` or
  environment settings.
- Warm Numba before benchmarking. It helps supported Python-loop work, not code
  already dominated by optimized NumPy kernels.
- Cython, PyO3/Rust, GPU code, and alternative runtimes add compilation,
  transfer, ABI, packaging, debugging, and maintenance. Batch enough work per
  boundary crossing to justify them and keep a tested Python path when useful.

## CPython specialization

Use `dis.dis(fn, adaptive=True)` after warm-up as supporting evidence for a hot
loop. Do not redesign APIs to preserve one specialized opcode; specialization
rules change between versions. Re-measure after Python upgrades.

## Regression guards

Use narrow allocation, output-size, startup, or memory guards when the
toolchain and platform are pinned. Wall-time gates require dedicated hardware
or enough margin to avoid flaking; keep shared-runner timing advisory. Never
compare runs with different GC modes, profilers, hooks, or calibration.

## Related skills

- `code-review` checks a completed diff. When invoked from `code-review`, do not
  invoke it again.
- `code-simplifier` runs after the gain is proven.
- `change-impact-auditor` traces environment, serialization, imports, logging,
  and concurrency changes.
- `runtime-process-debugging` owns subprocess, pipe, lifecycle, and shutdown
  failures.

Correctness overrides performance.
