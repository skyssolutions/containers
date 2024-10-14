ARG VERSION
FROM registry.skysolutions.fi/docker.io/caddy:${VERSION}-builder AS builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETPLATFORM

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM registry.skysolutions.fi/docker.io/caddy:${VERSION}
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
