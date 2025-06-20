#!/bin/bash
set -euo pipefail
tag="$(date +%Y).$(expr $(date +%m) + 0).$(expr $(date +%d) + 0)"
git tag -m "$tag" "$tag"
git push --tags
goreleaser release --clean
