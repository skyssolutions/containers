#!/usr/bin/env bash

# Fetch all -slim tags, sorted by version
tags=$(curl -s "https://registry.hub.docker.com/v2/repositories/renovate/renovate/tags?ordering=last_updated" | jq --raw-output '.results[] | select(.name | endswith("-slim")) | .name')

# Extract the latest major.minor version
latest_major_minor=$(echo "$tags" | grep -oE '^[0-9]+\.[0-9]+(\.[0-9]+)?-slim' | sed 's/-slim//' | sort -Vr | cut -d. -f1,2 | uniq | head -n1)

# Try to find the latest patch version for the latest major.minor version
latest_patch_version=$(echo "$tags" | grep -E "^${latest_major_minor}(\.[0-9]+)?-slim" | sort -Vr | head -n1)

# If no patch version is found, use the major.minor version
version=${latest_patch_version:-$latest_major_minor}

# Output the version (stripping off any '-slim' suffix)
version="${version%-slim}"

# Output the version
printf "%s\n" "${version}"
