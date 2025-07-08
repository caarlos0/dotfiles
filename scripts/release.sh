#!/bin/bash
set -euo pipefail
tag="$(date +%Y).$(expr $(date +%m) + 0).$(expr $(date +%d) + 0)"
git tag -m "$tag" "$tag"
git push --tags
goreleaser release --clean
docker buildx build --platform linux/arm64,linux/amd64 -t caarlos0/debug .
docker push caarlos0/debug
