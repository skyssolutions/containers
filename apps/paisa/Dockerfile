FROM registry.samipsolutions.fi/docker/ananthakumaran/paisa:v0.6.2
RUN mkdir /app && apk --no-cache add ca-certificates ledger hledger
WORKDIR /app
EXPOSE 7500
CMD ["paisa", "serve"]
