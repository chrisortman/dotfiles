#!/bin/bash

# Script to create directories in ~/.config based on underscore directories in config folder

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config/ubuntu-noble"

# Check if config directory exists
if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "Error: Config directory not found at $CONFIG_DIR"
    exit 1
fi

# Create ~/.config if it doesn't exist
mkdir -p ~/.config

# Find all directories that start with underscore in config folder
for underscore_dir in "$CONFIG_DIR"/_*/; do
    if [[ -d "$underscore_dir" ]]; then
        # Get the name without the underscore prefix
        dir_name=$(basename "$underscore_dir")
        echo "Processing $dir_name..."
        
        # Find all subdirectories within the underscore directory
        for subdir in "$underscore_dir"*/; do
            if [[ -d "$subdir" ]]; then
                subdir_name=$(basename "$subdir")
                target_dir="$HOME/.config/$subdir_name"
                
                if [[ ! -d "$target_dir" ]]; then
                    echo "Creating directory: $target_dir"
                    mkdir -p "$target_dir"
                else
                    echo "Directory already exists: $target_dir"
                fi
            fi
        done
    fi
done

echo "Directory creation complete!"
