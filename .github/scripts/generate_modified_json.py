#!/usr/bin/env python3
import json
import sys

app = sys.argv[1]
channel = sys.argv[2]
debian_version = sys.argv[3]

data = {
    'app': app,
    'channel': channel,
    'debian_version': debian_version
}

print(json.dumps(data, separators=(',', ':')))
