---
name: typescript-performance
description: Diagnose and optimize TypeScript checker, build, V8, Node, and browser performance.
---

# TypeScript Performance

First identify the slow layer: type checking, emit and bundling, emitted
JavaScript, Node.js, or the browser. Measure one representative workload and
change one demonstrated bottleneck.

## Compiler and editor

Start with phase timing:

```bash
tsc -p tsconfig.json --extendedDiagnostics
tsc -p tsconfig.json --generateTrace trace --incremental false
npx @typescript/analyze-trace trace
```

Use `--generateTrace` only when check time dominates. Its output identifies
expensive files, comparisons, and type instantiations.

Concrete checker fixes, only for traced hot spots:

- Prefer a named interface over a large repeated intersection when callers need
  the composed object type. Interface relations have stable identities the
  checker can cache.
- Extract repeated inline conditional or mapped types to named aliases so
  equivalent instantiations can be reused.
- Add explicit return types to expensive exported functions when declaration
  emit repeatedly infers and names them.
- Reduce very large unions and intersections at their source instead of adding
  assertions that hide the cost.
- Inspect the actual graph with `--listFiles` or `--explainFiles`.
  `exclude` does not remove an imported file.
- Limit `types` to ambient packages the program uses; do not load every
  installed `@types` package by accident.
- Use project references where package ownership is real. Too many tiny
  projects add declaration and orchestration overhead.
- Use `incremental` for repeated builds and invalidate `.tsbuildinfo` when the
  compiler or relevant configuration changes.

`skipLibCheck` saves time by not validating dependency declarations. It can
hide incompatible `.d.ts` files, so treat it as a correctness trade-off rather
than a default optimization. `isolatedDeclarations` enables compatible tools to
emit declarations per file; it does not make ordinary `tsc` checking faster.

## Emit and bundles

Run fast transpilation beside, never instead of, type checking:

```text
tsc --noEmit ─────────────► type errors
source ─► esbuild / SWC ─► JavaScript and source maps
```

Enable `isolatedModules` to detect constructs unsafe for file-isolated
transpilers. Inspect:

- ESM preservation through the compiler and bundler; CommonJS and dynamic
  exports limit static tree shaking.
- `package.json` `sideEffects`. Use `false` only when module evaluation is
  actually pure; list CSS, polyfills, and registration modules explicitly.
- `target` against the deployed runtime. Lower targets inject syntax-lowering
  code; TypeScript does not polyfill missing runtime APIs.
- decorator and metadata output, helper duplication, source-map cost, dynamic
  imports, chunk boundaries, and route-level bytes.
- cache keys for compiler version, config, environment, inputs, and outputs. A
  fast stale build is a correctness failure.

## Emitted JavaScript and V8

Interfaces, type aliases, generics, and type modifiers erase. Regular enums,
namespaces, decorators, and parameter properties emit JavaScript. Inspect the
bundle before making runtime claims.

In measured hot paths:

- Initialize object properties consistently. Conditional property creation can
  make inline caches polymorphic.
- Avoid holes, out-of-bounds reads, and mixed numeric/object values in dense
  numeric arrays. Consider typed arrays when fixed numeric semantics fit.
- Measure closure creation, promise chains, parsing, serialization, and object
  allocation rather than rewriting syntax by taste.
- Warm microbenchmarks through the deployed engine's JIT tiers and include GC.

Reject stale bans on `try`/`catch`, `async`/`await`, classes, or modern syntax.
V8 behavior changes; require a current profile on the deployed Node or browser.

## Node.js

- Remove synchronous filesystem, crypto, compression, and child-process calls
  from concurrent request paths.
- Remember that async `fs`, `dns`, `crypto`, and `zlib` can contend for the
  shared libuv worker pool. Moving work off the event loop does not create
  unlimited capacity.
- Honor stream backpressure: stop after `write()` returns `false`, wait for
  `drain`, and prefer `stream.pipeline` for connected stages and error cleanup.
- Use worker threads only for measured CPU work. Include startup, structured
  clone or transfer, coordination, and memory in the benchmark.
- Use `AsyncLocalStorage` for request context instead of raw `async_hooks`.
- Inspect CPU and heap profiles before adding profiler dependencies:

```bash
node --cpu-prof app.js
node --heap-prof app.js
```

## Browser

Measure bundle delivery, script parse/evaluate/GC, rendering, and field
responsiveness separately. Use the Performance panel to attribute long tasks
before splitting or yielding. Include structured-clone and messaging cost when
moving work to Web Workers; transfer buffers when ownership transfer is valid.
Batch DOM reads and writes to avoid repeated style and layout work.

Lighthouse is lab evidence. Use Core Web Vitals field data for real-user impact;
one local run is not a regression gate.

## Regression guards

Bundle bytes and compiler diagnostic counts can be hard gates when the lockfile,
toolchain, input, and variance are controlled. Keep shared-runner wall time and
browser lab scores advisory until repeated baselines show a stable threshold.

## Related skills

- `code-review` checks a completed diff. When invoked from `code-review`, do not
  invoke it again.
- `code-simplifier` runs after the gain is proven.
- `change-impact-auditor` traces config, cache, module, and consumer changes.
- `runtime-process-debugging` owns event-loop, process, pipe, and shutdown
  failures.

Correctness overrides performance.
