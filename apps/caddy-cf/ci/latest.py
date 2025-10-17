#!/usr/bin/env python3

import requests
import re
from packaging import version

def get_all_tags():
    tags = []
    url = "https://registry.hub.docker.com/v2/repositories/library/caddy/tags?ordering=last_updated&page_size=100"
    while url:
        response = requests.get(url)
        data = response.json()
        tags.extend(data['results'])
        url = data.get('next')  # Get the next page URL
    return tags

def get_latest(channel_name):
    tags = get_all_tags()
    # Modify regex to exclude beta versions
    version_tags = [re.search(r'\d+\.\d+\.\d+', tag['name']).group(0)
                    for tag in tags if re.search(r'\d+\.\d+\.\d+', tag['name']) and '-beta' not in tag['name']]
    sorted_versions = sorted(version_tags, key=lambda x: version.parse(x), reverse=True)
    # print(sorted_versions)  # Print sorted versions for debugging

    # Return the latest version
    return sorted_versions[0] if sorted_versions else None

# latest_version = get_latest("stable")
# print(latest_version)
