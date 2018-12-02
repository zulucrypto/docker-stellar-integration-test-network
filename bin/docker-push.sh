#!/usr/bin/env bash
#
# Builds and publishes a the docker container to hub.docker.com
#
# Example usage:
#   $ git tag -a v0.2.1 -m "Tagging 0.2.1"
#   $ bin/docker-push.sh
#
# NOTE: Versions must start with "v"
#
set -e

# Will return the current tag, such as "v0.1.0"
CONTAINER_NAME="zulucrypto/stellar-integration-test-network"
VERSION=$(git describe --exact-match --tags $(git log -n1 --pretty='%h'))

# Verify version looks reasonable
if ! [[ "$VERSION" =~ ^v\d* ]]; then
    echo "Invalid version $VERSION"
    exit 1
fi

# Remove first character ("v")
VERSION="${VERSION:1}"

echo "Building version: ${VERSION}"

docker build --tag "${CONTAINER_NAME}:${VERSION}" .


echo "Pushing version: ${VERSION}"

docker login --username zulucrypto

docker push "${CONTAINER_NAME}:${VERSION}"

docker tag "${CONTAINER_NAME}:${VERSION}" "${CONTAINER_NAME}:latest"
docker push "${CONTAINER_NAME}:latest"
