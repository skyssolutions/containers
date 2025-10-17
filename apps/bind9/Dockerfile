FROM alpine:3.22 as build

RUN apk add --no-cache \
    build-base \
    gcc \
    make \
    git \
    musl-dev

WORKDIR /usr/src/
RUN git clone https://git.skysolutions.fi/kryptonian/nat64health.git && cd nat64health && make
WORKDIR /
RUN mkdir -p /usr/local/sbin/ && cd /usr/src/nat64health && install health-daemon.py update-dns64 /usr/local/sbin

FROM alpine:3.22

RUN apk add --no-cache \
    python3 \
    bind \
    bind-tools

COPY --from=build /usr/local/sbin/* /usr/local/sbin/
RUN adduser -D -h /etc/bind -u 102 -g 109 bind
RUN mkdir -p /etc/bind && chown root:bind /etc/bind/ && chmod 755 /etc/bind
COPY ./apps/bind9/nat64-prefixes /etc/bind/nat64-prefixes
COPY ./apps/bind9/entrypoint.sh /entrypoint.sh
RUN mkdir -p /var/cache/bind && chown bind:bind /var/cache/bind && chmod 755 /var/cache/bind
RUN mkdir -p /var/lib/bind && chown bind:bind /var/lib/bind && chmod 755 /var/lib/bind
RUN mkdir -p /var/log/bind && chown bind:bind /var/log/bind && chmod 755 /var/log/bind
RUN mkdir -p /run/named && chown bind:bind /run/named && chmod 755 /run/named

USER nobody

VOLUME ["/etc/bind", "/var/cache/bind", "/var/lib/bind", "/var/log"]


EXPOSE 53/udp 53/tcp 953/tcp

CMD ["/entrypoint.sh"]
