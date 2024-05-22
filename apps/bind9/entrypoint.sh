#!/usr/bin/env sh

exec \
  /usr/local/sbin/health-daemon.py /etc/bind/nat64-prefixes -- /usr/local/sbin/update-dns64 &

 exec \
   /usr/sbin/named \
    -f \
    -c /etc/bind/named.conf \
    "$@"
