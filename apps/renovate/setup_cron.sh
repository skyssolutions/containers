#!/bin/bash

echo "${CRON_SCHEDULE} root /etc/custom/run_renovate.sh >> /etc/cron.d/renovate-cron
chmod 0644 /etc/cron.d/renovate-cron