#!/bin/bash

set -ex

echo "Setting up Mac host dependencies..."

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not found. Please install Homebrew first:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

echo "Checking and installing dependencies..."

# Check if sox is already installed
if command -v sox &> /dev/null; then
    echo "✓ sox already installed"
else
    echo "Installing sox..."
    brew install sox
fi

# Check if socat is already installed
if command -v socat &> /dev/null; then
    echo "✓ socat already installed"
else
    echo "Installing socat..."
    brew install socat
fi

echo "Verifying installations..."
if command -v sox &> /dev/null && command -v socat &> /dev/null; then
    echo "✓ sox and socat installed successfully"
    echo "✓ Mac setup complete"
else
    echo "✗ Installation failed"
    exit 1
fi

echo "Checking for existing socat processes..."
EXISTING_SOCAT=$(pgrep -f "socat.*UDP-LISTEN:8000" || true)
if [ -n "$EXISTING_SOCAT" ]; then
    echo "Found existing socat processes, killing them: $EXISTING_SOCAT"
    pkill -f "socat.*UDP-LISTEN:8000"
    echo "Killed existing socat processes"
else
    echo "No existing socat processes found"
fi

echo "Starting audio receiver..."
set -x
socat -d -d -b 128 UDP-LISTEN:8000,reuseaddr - | play -t raw -r 48000 -e signed -b 16 -c 2 -