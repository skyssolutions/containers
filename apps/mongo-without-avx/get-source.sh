#!/bin/bash

# Read variables from ENV
CHANNEL="$CHANNEL"

if [ -z "$CHANNEL" ]; then
  echo "No channel env variable detected"
  exit 1
else
  curl -o /tmp/mongo.tar.gz -L https://github.com/mongodb/mongo/archive/refs/tags/r${CHANNEL}.tar.gz
  tar xaf /tmp/mongo.tar.gz --strip-components=1 -C /src && rm /tmp/mongo.tar.gz
fi
