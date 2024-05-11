FROM registry.skysolutions.fi/docker.io/node:18-alpine3.19 as web
RUN apk --no-cache add git
RUN mkdir -p /usr/src/paisa && git clone  https://github.com/ananthakumaran/paisa.git /usr/src/paisa && cd /usr/src/paisa && git checkout de8874184db48535c8b24dbc82c309c36b0fdc67
WORKDIR /usr/src/paisa
RUN npm install && npm run build

FROM registry.skysolutions.fi/docker.io/golang:1.21-alpine3.19 as go
RUN apk --no-cache add git
RUN mkdir -p /usr/src/paisa && git clone  https://github.com/ananthakumaran/paisa.git /usr/src/paisa && cd /usr/src/paisa && git checkout de8874184db48535c8b24dbc82c309c36b0fdc67
WORKDIR /usr/src/paisa
RUN apk --no-cache add sqlite gcc g++
RUN go mod download && go mod verify
COPY --from=web /usr/src/paisa/web/static ./web/static
RUN CGO_ENABLED=1 go build

FROM registry.skysolutions.fi/docker.io/alpine:3.19
RUN mkdir /app && apk --no-cache add ca-certificates ledger hledger
USER root
RUN \
    addgroup -S kah --gid 568 \
     && adduser -S kah -G kah --uid 568 \
    && \
    mkdir -p /app \
    && chown -R kah:kah /app \
    && chmod -R 775 /app
USER kah
WORKDIR /app
COPY --from=go /usr/src/paisa/paisa /usr/bin
EXPOSE 7500
CMD ["paisa", "serve"]
