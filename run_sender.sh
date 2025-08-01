#!/bin/bash

# Docker audio sender script
# Builds and runs the JACK audio streaming container

set -ex

echo "Building Docker image..."
docker build --tag jack-repro .

echo "Running Docker container with audio streaming..."
docker run --rm \
  --privileged \
  --cap-add=IPC_LOCK \
  --ulimit memlock=-1 \
  --shm-size=256m \
  -v $(pwd):/audio \
  jack-repro