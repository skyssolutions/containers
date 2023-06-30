ARG DEBIAN_VERSION=10

FROM debian:${DEBIAN_VERSION} as build

RUN apt update -y && apt install -y build-essential \
        libcurl4-openssl-dev \
        liblzma-dev \
        libssl-dev \
        python3-pip \
        curl \
    && rm -rf /var/lib/apt/lists/*

COPY get-source.sh /get-source.sh

ARG CHANNEL=5.0.18
ENV MONGO_VERSION=$CHANNEL

RUN mkdir /src && \
    curl -o /tmp/mongo.tar.gz -L https://github.com/mongodb/mongo/archive/refs/tags/r${MONGO_VERSION}.tar.gz && \
    tar xaf /tmp/mongo.tar.gz --strip-components=1 -C /src && \
    rm /tmp/mongo.tar.gz

WORKDIR /src

COPY os_patch.diff /os_patch.diff
RUN patch -p1 < /os_patch.diff

ARG NUM_JOBS=

RUN export GIT_PYTHON_REFRESH=quiet && \
    python3 -m pip install requirements_parser && \
    python3 -m pip install -r etc/pip/compile-requirements.txt && \
    if [ "${NUM_JOBS}" -gt 0 ]; then export JOBS_ARG="-j ${NUM_JOBS}"; fi && \
    python3 buildscripts/scons.py install-servers MONGO_VERSION="${MONGO_VERSION}" --release --disable-warnings-as-errors ${JOBS_ARG} && \
    mv build/install /install && \
    strip --strip-debug /install/bin/mongod && \
    strip --strip-debug /install/bin/mongos && \
    rm -rf build

FROM debian:${DEBIAN_VERSION}

RUN apt update -y && \
    apt install -y libcurl4 && \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /install/bin/mongo* /usr/local/bin/

RUN mkdir -p /data/db && \
    chmod -R 750 /data && \
    chown -R 568:568 /data

USER 568

ENTRYPOINT [ "/usr/local/bin/mongod" ]
