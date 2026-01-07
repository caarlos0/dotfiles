---
name: go-doc
description: Get documentation for any Go library using `go doc`. Use when asked about Go package documentation, API reference, function signatures, or how to use a specific Go library/package.
---

# Go Documentation

Retrieve Go package documentation using `go doc`.

## Workflow

1. **Check go.mod** for the package version if in a Go project
2. **Get the package** if not already available
3. **Run go doc** to retrieve documentation

## Getting the Package

If the package isn't available locally, fetch it first:

```bash
# Use version from go.mod if available
go get package/path@version

# Otherwise use @latest
go get package/path@latest
```

To find the version in go.mod:
```bash
grep 'package/path' go.mod
```

## Using go doc

```bash
# Package overview
go doc package/path

# Specific symbol (function, type, method)
go doc package/path.Symbol

# Show unexported symbols
go doc -u package/path

# Show source code
go doc -src package/path.Symbol

# Show all symbols in package
go doc -all package/path
```

## Examples

```bash
# Get charmbracelet/log documentation
go get github.com/charmbracelet/log@latest
go doc github.com/charmbracelet/log

# Get specific function docs
go doc github.com/charmbracelet/log.New

# Get method on a type
go doc github.com/charmbracelet/log.Logger.Info
```

## Version Resolution

1. If in a Go project with go.mod containing the package → use that version
2. If user specifies a version → use that version
3. Otherwise → use `@latest`
