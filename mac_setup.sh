#!/bin/bash

echo "Setting up Mac host dependencies..."

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew not found. Please install Homebrew first:"
    echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    exit 1
fi

echo "Installing sox and socat via Homebrew..."
brew install sox socat

echo "Verifying installations..."
if command -v sox &> /dev/null && command -v socat &> /dev/null; then
    echo "✓ sox and socat installed successfully"
    echo "✓ Mac setup complete"
else
    echo "✗ Installation failed"
    exit 1
fi