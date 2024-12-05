FROM alpine:3.21

ENV WIREPROXY_VERSION=1.0.9
ENV WGCF_VERSION=2.2.23

RUN uname -m

RUN apk add --no-cache curl \
  && case "$(uname -m)" in \
       "x86_64") export ARCH="amd64" ;; \
       "aarch64") export ARCH="arm64" ;; \
       *) echo "Unsupported architecture"; exit 1 ;; \
     esac \
  && echo $ARCH \
  && WGCF_URL="https://github.com/ViRb3/wgcf/releases/download/v${WGCF_VERSION}/wgcf_${WGCF_VERSION}_linux_${ARCH}" \
  && curl -fsSL "${WGCF_URL}" -o ./wgcf \
  && chmod +x ./wgcf \
  && mv ./wgcf /usr/bin \
  && WIREPROXY_URL="https://github.com/pufferffish/wireproxy/releases/download/v${WIREPROXY_VERSION}/wireproxy_linux_${ARCH}.tar.gz" \
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
