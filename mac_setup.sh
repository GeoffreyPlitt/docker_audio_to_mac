#!/bin/bash

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