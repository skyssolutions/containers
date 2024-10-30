FROM alpine:3.20

ARG WIREPROXY_VERSION=1.0.9
ARG WGCF_VERSION=2.2.23

RUN apk add --no-cache curl \
  && ARCH=$(uname -m) \
  && if [ "${ARCH}" = "i386" ]; then ARCH="386"; fi \
  && if [ "${ARCH}" = "i686" ]; then ARCH="386"; fi \
  && if [ "${ARCH}" = "x86_64" ]; then ARCH="amd64"; fi \
  && if [ "${ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
  && WGCF_URL="https://github.com/ViRb3/wgcf/releases/download/v${WGCF_VERSION}/wgcf_${WGCF_VERSION}_linux_${ARCH}" \
  && curl -fsSL "${WGCF_URL}" -o ./wgcf \
  && chmod +x ./wgcf \
  && mv ./wgcf /usr/bin \
  && WIREPROXY_URL="https://github.com/pufferffish/wireproxy/releases/download/v${WIREPROXY_VERSION}/wireproxy_${WIREPROXY_VERSION}_linux_${ARCH}.tar.gz" \
  && curl -fsSL "${WIREPROXY_URL}" -o ./wireproxy.tar.gz \
  && tar -xzf wireproxy.tar.gz \
  && rm wireproxy.tar.gz \
  && chmod +x ./wireproxy \
  && mv ./wireproxy /usr/bin

# Add custom scripts and set up entrypoint
ADD apps/warp-sock5/entrypoint.sh /usr/local/bin/entrypoint.sh
ADD apps/warp-sock5/warp-health-check.sh /usr/local/bin/warp-health-check.sh
EXPOSE 40000/tcp
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD []
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "/usr/local/bin/warp-health-check.sh" ]
