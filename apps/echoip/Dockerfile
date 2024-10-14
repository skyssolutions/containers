FROM registry.skysolutions.fi/docker.io/golang:1.22-bookworm AS build

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apt-get install -y git --no-install-recommends
RUN git clone https://github.com/mpolden/echoip.git  /go/src/github.com/mpolden/echoip

WORKDIR /go/src/github.com/mpolden/echoip

# Must build without cgo because libc is unavailable in runtime image
ENV GO111MODULE=on CGO_ENABLED=0
RUN make

# Run
FROM registry.skysolutions.fi/docker.io/debian:bookworm
EXPOSE 8080

COPY --from=build /go/bin/echoip /opt/echoip/
COPY --from=build /go/src/github.com/mpolden/echoip/html /opt/echoip/html

WORKDIR /opt/echoip
ENTRYPOINT ["/opt/echoip/echoip"]