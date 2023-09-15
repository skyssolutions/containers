ARG VERSION
FROM registry.samipsolutions.fi/docker/caddy:2-builder AS builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETPLATFORM

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM registry.samipsolutions.fi/docker/caddy:2
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
