#!/usr/bin/env bash
latest_branch=$(curl -sX GET "https://api.github.com/repos/odoo/odoo/branches" | jq -r '.[].name' | grep -E '^[0-9]+(\.[0-9]+)*$' | sort -t. -k1,1n -k2,2n -k3,3n | tail -n1)
printf "%s" "${latest_branch}"