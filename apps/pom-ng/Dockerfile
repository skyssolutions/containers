FROM public.ecr.aws/docker/library/alpine:3.20.3

RUN \
     apk add --no-cache \
             ${EXTRA_PACKAGES} \
             bash \
             autoconf \
             automake \
             bsd-compat-headers \
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
             libexif \
             musl-compat

WORKDIR /tmp/build
RUN \
    git clone https://github.com/gmsoft-tuxicoman/pom-ng.git . \
    && autoreconf -f -i \
    && ./configure \
    && make -j $(nproc) \
    && make DESTDIR=/tmp/xmltv-build install

