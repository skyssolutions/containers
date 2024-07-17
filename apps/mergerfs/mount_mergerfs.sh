#!/bin/bash

# Print the configuration for debugging purposes
echo "Mounting mergerfs with the following configuration:"
echo "Source Paths: $MERGERFS_SRC_PATHS"
echo "Destination Path: $MERGERFS_DEST_PATH"
echo "Options: $MERGERFS_OPTIONS"

# Ensure the destination directory exists
mkdir -p $MERGERFS_DEST_PATH

# Mount the mergerfs filesystem
mergerfs $MERGERFS_SRC_PATHS $MERGERFS_DEST_PATH -o $MERGERFS_OPTIONS
