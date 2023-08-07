#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 TAG"
    exit 1
fi

podman build \
    --pull \
    --no-cache \
    --build-arg USER="$(id -un)" \
    --build-arg USER_ID="$(id -u)" \
    --build-arg GROUP="$(id -gn)" \
    --build-arg GROUP_ID="$(id -g)" \
    -t "$1" \
    .
