#!/usr/bin/env python3

import requests
import re
from packaging import version

def get_latest():
    # Fetch tags from Docker Hub
    response = requests.get("https://registry.hub.docker.com/v2/repositories/library/caddy/tags?ordering=last_updated")
    tags = response.json()['results']

    # Filter out tags that follow semantic versioning (major.minor.patch)
    version_tags = [tag['name'] for tag in tags if re.match(r'^\d+\.\d+(\.\d+)?$', tag['name'])]

    # Sort the versions
    sorted_versions = sorted(version_tags, key=lambda x: version.parse(x), reverse=True)

    # Return the latest version
    return sorted_versions[0] if sorted_versions else None

latest_version = get_latest()
print(latest_version)