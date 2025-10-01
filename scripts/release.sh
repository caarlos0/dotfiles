#!/bin/bash
set -euo pipefail
tag="$(date +%Y.%-m.%-d)"
git tag -m "$tag" "$tag"
git push --tags
goreleaser release --clean
