#!/usr/bin/env python3
import json
import sys

app = sys.argv[1]
channel = sys.argv[2]

# Check if debian_version is provided
try:
    debian_version = sys.argv[3]
except IndexError:
    debian_version = None

data = {
    'app': app,
    'channel': channel
}

# Add debian_version to data only if it's neither empty nor "null"
if debian_version and debian_version.lower() != "null":
    data['debian_version'] = debian_version

print(json.dumps(data, separators=(',', ':')))
