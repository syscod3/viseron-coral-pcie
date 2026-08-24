#!/usr/bin/env bash
# Build script for Viseron PCIe Coral EdgeTPU image

set -euo pipefail

# Configuration
REGISTRY="${REGISTRY:-ghcr.io}"
REPO="${REPO:-$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^/]*\/[^/]*\).git/\1/')}"
VERSION="${VERSION:-$(git describe --tags --always --dirty 2>/dev/null || date +%Y%m%d)}"
VISERON_VERSION="${VISERON_VERSION:-latest-amd64}"

IMAGE="${REGISTRY}/${REPO}"
TAG="${IMAGE}:${VERSION}"
LATEST_TAG="${IMAGE}:latest"

# Build arguments
BUILD_ARGS=(
    --build-arg "VISERON_VERSION=${VISERON_VERSION}"
)

echo "Building ${TAG}"
echo "Viseron base: ${VISERON_VERSION}"

# Build
docker build \
    "${BUILD_ARGS[@]}" \
    -t "${TAG}" \
    -t "${LATEST_TAG}" \
    -f Dockerfile \
    .

echo "Built: ${TAG}"
echo "Tagged: ${LATEST_TAG}"

# Optional: push
if [[ "${PUSH:-false}" == "true" ]]; then
    echo "Pushing..."
    docker push "${TAG}"
    docker push "${LATEST_TAG}"
    echo "Pushed successfully"
fi