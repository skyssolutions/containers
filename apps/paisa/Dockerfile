FROM registry.samipsolutions.fi/docker/node:18-alpine3.18 as web
RUN apk --no-cache add git
RUN mkdir -p /usr/src/paisa && git clone  https://github.com/ananthakumaran/paisa.git /usr/src/paisa && cd /usr/src/paisa && git checkout 3c16a53ee0c14acf87c42e07cb82ad18a6356fe1
WORKDIR /usr/src/paisa
RUN npm install && npm run build

FROM registry.samipsolutions.fi/docker/golang:1.21-alpine3.18 as go
RUN apk --no-cache add git
RUN mkdir -p /usr/src/paisa && git clone  https://github.com/ananthakumaran/paisa.git /usr/src/paisa && cd /usr/src/paisa && git checkout 3c16a53ee0c14acf87c42e07cb82ad18a6356fe1
WORKDIR /usr/src/paisa
RUN apk --no-cache add sqlite gcc g++
RUN go mod download && go mod verify
COPY --from=web /usr/src/paisa/web/static ./web/static
RUN CGO_ENABLED=1 go build

FROM registry.samipsolutions.fi/docker/alpine:3.18
RUN mkdir /app && apk --no-cache add ca-certificates ledger hledger
USER root
RUN \
    adduser kah \
        --uid 568 \
        --group \
        --system \
        --disabled-password \
        --no-create-home \
    && \
    mkdir -p /app \
    && chown -R kah:kah /app \
    && chmod -R 775 /app \
USER kah
WORKDIR /app
COPY --from=go /usr/src/paisa/paisa /usr/bin
EXPOSE 7500
CMD ["paisa", "serve"]
