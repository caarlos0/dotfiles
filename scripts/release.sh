#!/bin/bash
set -euo pipefail
tag="$(date +%Y.%-m.%-d)"
git tag -m "$tag" "$tag"
git push --tags
goreleaser release --clean
docker buildx build --platform linux/arm64,linux/amd64 -t caarlos0/debug --push .
