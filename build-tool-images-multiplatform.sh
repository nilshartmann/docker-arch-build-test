#!/bin/bash

set -eo pipefail

if [[ -z "$TAG" ]]; then
    TAG="$1"
fi

if [ -z "${DEBEZIUM_DOCKER_REGISTRY_PRIMARY_NAME}" ]; then
  DEBEZIUM_DOCKER_REGISTRY_PRIMARY_NAME=debezium
fi;

if [ -z "${DEBEZIUM_DOCKER_REGISTRY_SECONDARY_NAME}" ]; then
  DEBEZIUM_DOCKER_REGISTRY_SECONDARY_NAME=quay.io/debezium
fi;

DEBEZIUM_TOOLS="tooling website-builder"

for TOOL in $DEBEZIUM_TOOLS; do
  echo ""
  echo "****************************************************************"
  echo "** Building  ${DEBEZIUM_DOCKER_REGISTRY_PRIMARY_NAME}/$TOOL:$TAG"
  echo "****************************************************************"
  docker buildx build --push --platform linux/amd64,linux/arm64 \
        --build-arg DEBEZIUM_DOCKER_REGISTRY_PRIMARY_NAME="${DEBEZIUM_DOCKER_REGISTRY_PRIMARY_NAME}" \
          -t "${DEBEZIUM_DOCKER_REGISTRY_PRIMARY_NAME}/${TOOL}:$TAG" \
          -t "${DEBEZIUM_DOCKER_REGISTRY_SECONDARY_NAME}/${TOOL}:$TAG" \
          "$TOOL"
done
