#!/bin/bash

# Centralized Docker configuration
# Used by run_docker.sh for consistent container settings

# Docker run flags
DOCKER_FLAGS=(
  --rm
  --privileged
  --cap-add=IPC_LOCK
  --ulimit memlock=-1
  --shm-size=256m
  -v "$(pwd):/audio"
)

# Docker image name
DOCKER_IMAGE="jack-repro"