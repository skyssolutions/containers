#!/bin/bash
set -e

if [ $CONTAINER_TIMEZONE ] &&  [ "$SET_CONTAINER_TIMEZONE" = "false" ]; then
    echo ${CONTAINER_TIMEZONE} >/etc/timezone
    export TZ=${CONTAINER_TIMEZONE}
    echo "Container timezone set to: $CONTAINER_TIMEZONE"
    export SET_CONTAINER_TIMEZONE=true
else
    echo "Container timezone not modified"
fi

if [ "$1" = 'app' ]; then
    /bin/run-parts "/usr/share/docker-entrypoint.pre"
    #cp /theme/Nginx-Fancyindex-Theme/mdl/color/$COLOR.min.css /theme/Nginx-Fancyindex-Theme/mdl/material.min.css
    nginx -g "daemon off;"
    /bin/run-parts "/usr/share/docker-entrypoint.post"
fi

exec "$@"
