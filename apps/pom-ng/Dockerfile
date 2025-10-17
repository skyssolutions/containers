FROM public.ecr.aws/docker/library/debian:13

ENV DEBIAN_FRONTEND noninteractive

RUN \
     apt-get install \
             ${EXTRA_PACKAGES} \
             build-essentials \
             bzip2 \
             cmake \
             coreutils \
             curl \
             file \
             findutils \
             g++ \
             gcc \
             gettext-dev \
             git \
             gnu-libiconv-dev \
             gzip \
             jq \
             libcurl \
             libdvbcsa-dev \
             libgcrypt-dev \
             libhdhomerun-dev \
             libtool \
             libvpx-dev \
             libxml2-dev \
             libxslt-dev \
             linux-headers \
             make \
             pkgconf \
             libmicrohttpd \
             libmicrohttpd-dev \
             xmlrpc-c \
             xmlrpc-c-dev \
             lua5.1 \
             lua5.1-dev \
             uthash \
             uthash-dev \
             libpcap \
             libpcap-dev \
             zlib \
             zlib-dev \
             libjpeg \
             sqlite \
             sqlite-dev \
             libexif-dev \
             libexif

WORKDIR /tmp/build
RUN \
    git clone https://github.com/gmsoft-tuxicoman/pom-ng.git . \
    && autoreconf -f -i \
    && ./configure \
    && make -j $(nproc) \
    && make DESTDIR=/tmp/xmltv-build install

