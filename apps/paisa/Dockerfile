FROM registry.samipsolutions.fi/docker/node:18-alpine3.18 as web
RUN wget https://github.com/ananthakumaran/paisa/archive/refs/tags/v0.6.2.tar.gz && mkdir -p /usr/src/paisa && tar xzvf v0.6.2.tar.gz -C /usr/src/paisa
WORKDIR /usr/src/paisa
RUN npm install && npm run build

FROM registry.samipsolutions.fi/docker/golang:1.20-alpine3.18 as go
RUN wget https://github.com/ananthakumaran/paisa/archive/refs/tags/v0.6.2.tar.gz && mkdir -p /usr/src/paisa && tar xzvf v0.6.2.tar.gz -C /usr/src/paisa
WORKDIR /usr/src/paisa
RUN apk --no-cache add sqlite gcc g++
RUN go mod download && go mod verify
COPY --from=web /usr/src/paisa/web/static ./web/static
RUN CGO_ENABLED=1 go build

FROM registry.samipsolutions.fi/docker/alpine:3.18
RUN mkdir /app && apk --no-cache add ca-certificates ledger hledger
WORKDIR /app
COPY --from=go /usr/src/paisa/paisa /usr/bin
EXPOSE 7500
CMD ["paisa", "serve"]
