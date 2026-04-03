---
name: go-performance
description: Analyze and optimize Go program performance. Use when asked to profile Go code, find performance bottlenecks, analyze memory allocations, detect memory leaks, write benchmarks, or optimize CPU/memory usage.
---

# Go Performance

## Workflow

1. Identify profile source (file, URL, or generate from tests/server)
2. Analyze with `go tool pprof`
3. Report findings with actionable recommendations

## Quick Reference

| Profile   | Test Flag     | HTTP Endpoint            |
| --------- | ------------- | ------------------------ |
| CPU       | `-cpuprofile` | `/debug/pprof/profile`   |
| Heap      | `-memprofile` | `/debug/pprof/heap`      |
| Goroutine | -             | `/debug/pprof/goroutine` |

## Key Commands

```bash
# Generate from benchmarks
go test -bench=. -cpuprofile cpu.prof -memprofile mem.prof

# Analyze (interactive or one-liner)
go tool pprof -top -cum cpu.prof
go tool pprof -http=:8080 cpu.prof  # web UI with flame graphs

# Memory analysis
go tool pprof -alloc_space -top mem.prof   # bytes allocated
go tool pprof -alloc_objects -top mem.prof # allocation count (GC pressure)

# Compare profiles (find leaks/regressions)
go tool pprof -base old.prof new.prof

# Filter results
go tool pprof -focus='mypackage.*' cpu.prof
```

## Tips

- Write a benchmark first to reproduce/confirm/measure the issue
- Focus on quick wins first: easy fixes with high impact
- If hotspots are in external libraries, still analyze - source is in `$GOPATH`
- CPU profiles need 30+ seconds for meaningful data
- For memory leaks: compare heap profiles at two points in time
- Use `-base` flag to find regressions between profiles

## Writing benchmarks

Every time we work on some performance issue, we should:

- make sure there is a benchmark
- if there isn't one, we create it, calling the function that we aim to improve

Then, we create a second benchmark, and a new production function with the
changes we want.

This way we can quickly run and compare both benchmarks.

Once we're happy with the changes, we replace the old function and old benchmark
with the new ones.

Commit messages should always have the benchmark results in them.
