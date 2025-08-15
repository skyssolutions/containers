# Build arguments from CI
ARG VERSION
ARG REVISION
ARG CHANNEL
ARG PAISA_REPO=https://github.com/ananthakumaran/paisa.git

# Web build stage
FROM registry.skysolutions.fi/docker.io/node:18-alpine3.19 as web
ARG VERSION
ARG REVISION
ARG PAISA_REPO

RUN apk --no-cache add git

# Clone and checkout specific version
RUN mkdir -p /usr/src/paisa && \
    git clone ${PAISA_REPO} /usr/src/paisa

WORKDIR /usr/src/paisa

# Checkout the version tag, not the CI revision
# The VERSION corresponds to the actual Paisa release we want to build
RUN git checkout "v${VERSION}"

# Build web assets
RUN npm install && npm run build

# Go build stage
FROM registry.skysolutions.fi/docker.io/golang:1.21-alpine3.20 as go
ARG VERSION
ARG REVISION
ARG PAISA_REPO

RUN apk --no-cache add git sqlite gcc g++

# Clone and checkout specific version (same as web stage)
RUN mkdir -p /usr/src/paisa && \
    git clone ${PAISA_REPO} /usr/src/paisa

WORKDIR /usr/src/paisa

# Checkout the version tag, not the CI revision
# The VERSION corresponds to the actual Paisa release we want to build
RUN git checkout "v${VERSION}"

# Download dependencies
RUN go mod download && go mod verify

# Copy web assets from previous stage
COPY --from=web /usr/src/paisa/web/static ./web/static

# Build the application with version and revision information
RUN CGO_ENABLED=1 go build \
    -ldflags "-X main.version=${VERSION} -X main.revision=${REVISION}" \
    -o paisa

# Final runtime stage
FROM registry.skysolutions.fi/docker.io/alpine:3.20

# Install runtime dependencies
RUN apk --no-cache add ca-certificates ledger hledger

# Create non-root user
RUN addgroup -S kah --gid 568 && \
    adduser -S kah -G kah --uid 568 && \
    mkdir -p /app && \
    chown -R kah:kah /app && \
    chmod -R 775 /app

# Copy binary from build stage
COPY --from=go /usr/src/paisa/paisa /usr/bin/paisa

# Set up runtime environment
USER kah
WORKDIR /app
EXPOSE 7500

# Labels for metadata (using CI-provided values)
ARG VERSION
ARG REVISION
ARG CHANNEL
LABEL org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${REVISION}" \
      org.opencontainers.image.title="Paisa" \
      org.opencontainers.image.description="Personal finance manager" \
      org.opencontainers.image.source="https://github.com/ananthakumaran/paisa" \
      org.opencontainers.image.vendor="skyssolutions"

CMD ["paisa", "serve"]
