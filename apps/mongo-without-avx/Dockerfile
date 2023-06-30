ARG DEBIAN_VERSION=11

FROM debian:${DEBIAN_VERSION} as build

RUN apt update -y && apt install -y build-essential \
        libcurl4-openssl-dev \
        liblzma-dev \
        libffi-dev \
        libssl-dev \
        python3-pip \
        curl \
    && rm -rf /var/lib/apt/lists/*

ARG CHANNEL=5.0.18
ENV MONGO_VERSION=$CHANNEL

COPY ./apps/mongo-without-avx/get-source.sh /get-source.sh

RUN mkdir /src && ./get-source.sh

WORKDIR /src

COPY ./apps/mongo-without-avx/os_patch.diff /os_patch.diff
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
