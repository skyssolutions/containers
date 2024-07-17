FROM registry.skysolutions.fi/docker.io/alpine:3.20

ARG TARGETPLATFORM
ARG VERSION
ARG CHANNEL

RUN apk add --no-cache --update \
    mergerfs --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
    btrfs-progs \
    xfsprogs \
    e2fsprogs \
    e2fsprogs-extra \
    tini

ENV MERGERFS_SRC_PATHS="/var/mnt/disk*"
ENV MERGERFS_DEST_PATH="/var/mnt/merged"
ENV MERGERFS_OPTIONS="defaults,allow_other,nonempty,minfreespace=50G,category.create=mfs,moveonenospc=true,fsname=mergerFS"

RUN mkdir -p /var/mnt/
COPY ./apps/mergerfs/mount_mergerfs.sh /usr/local/bin/mount_mergerfs.sh
RUN chmod +x /usr/local/bin/mount_mergerfs.sh


ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/local/bin/mount_mergerfs.sh"]
