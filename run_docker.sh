#!/bin/bash

# Docker runner
# Usage: 
#   ./run_docker.sh              # Opens interactive shell
#   ./run_docker.sh ls -la       # Runs command and exits

set -e

# Source the centralized configuration
source ./docker_config.sh

# Build the Docker image (no-op if layers are cached)
echo "Building Docker image..."
docker build --tag "$DOCKER_IMAGE" .

# If no arguments, open interactive shell
if [ $# -eq 0 ]; then
    echo "Running Docker container with interactive shell..."
    docker run -it "${DOCKER_FLAGS[@]}" "$DOCKER_IMAGE" /bin/bash
else
    # Run the command passed as arguments
    echo "Running command in Docker container: $@"
    docker run "${DOCKER_FLAGS[@]}" "$DOCKER_IMAGE" "$@"
fi