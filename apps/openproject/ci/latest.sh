#!/usr/bin/env bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/opf/openproject/releases/latest | jq -r .tag_name)

echo $LATEST_VERSION