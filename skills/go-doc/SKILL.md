---
name: go-doc
description: Get documentation for any Go library using `go doc`. Use when asked about Go package documentation, API reference, function signatures, or how to use a specific Go library/package.
---

# Go Documentation

Retrieve Go package documentation using `go doc`.

## Workflow

1. Check go.mod for package version (use that version, or `@latest` if not found)
2. Fetch package if needed: `go get package/path@version`
3. Run `go doc package/path` or `go doc package/path.Symbol`

## Key Flags

- `-src` - Show source code
- `-all` - Show all symbols in package
- `-u` - Include unexported symbols
