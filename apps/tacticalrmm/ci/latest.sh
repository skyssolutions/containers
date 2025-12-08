#!/usr/bin/env bash
version="$(curl -sX GET "https://api.github.com/repos/amidaware/tacticalrmm/releases/latest" | jq --raw-output '.tag_name')"
version="${version#*v}"
printf "%s" "${version}"