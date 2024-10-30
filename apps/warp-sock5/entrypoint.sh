#!/bin/sh
mkdir -p /config/wgcf
wgcf register --accept-tos --config /config/wgcf/wgcf-account.toml
wgcf generate --config /config/wgcf/wgcf-account.toml
mv wgcf-profile.conf /config/wireproxy.conf

echo -e "\n[Socks5]\nBindAddress = 0.0.0.0:40000" >>/config/wireproxy.conf

if [ -n "$SOCKS5_USERNAME" ]; then
	echo -e "\nUsername = $SOCKS5_USERNAME\nPassword = $SOCKS5_PASSWORD" >>/config/wireproxy.conf
fi

wireproxy -c /config/wireproxy.conf