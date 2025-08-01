#!/bin/bash

# Docker audio sender script
# Builds and runs the JACK audio streaming container

set -ex

# Use the centralized docker runner to run container_audio.sh
./run_docker.sh ./container_audio.sh