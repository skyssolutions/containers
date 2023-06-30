ARG DEBIAN_VERSION=10

FROM debian:${DEBIAN_VERSION} as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y  \
        build-essential \
        procps \
        curl  \
        file \
        git \
        libcurl4-openssl-dev \
        liblzma-dev \
        libffi-dev \
        libssl-dev \
        python3-pip \
    && rm -rf /var/lib/apt/lists/*



RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

ARG CHANNEL=5.0.18
ENV MONGO_VERSION=$CHANNEL
ENV PATH=$PATH:$HOME/.cargo/bin

#COPY ./apps/mongo-without-avx/get-source.sh /get-source.sh

RUN mkdir /src && ./get-source.sh

WORKDIR /src

#COPY ./apps/mongo-without-avx/o3_patch.diff /o3_patch.diff
RUN patch -p1 < /o3_patch.diff

ARG NUM_JOBS=

RUN export GIT_PYTHON_REFRESH=quiet && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install requirements_parser && \
    python3 -m pip install -r etc/pip/compile-requirements.txt && \
    if [ "${NUM_JOBS}" -gt 0 ]; then export JOBS_ARG="-j ${NUM_JOBS}"; fi && \
    python3 buildscripts/scons.py install-servers MONGO_VERSION="${MONGO_VERSION}" --release --disable-warnings-as-errors ${JOBS_ARG} && \
    mv build/install /install && \
    strip --strip-debug /install/bin/mongod && \
    strip --strip-debug /install/bin/mongos && \
    rm -rf build

FROM debian:${DEBIAN_VERSION}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y libcurl4 && \
    apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /install/bin/mongo* /usr/local/bin/

RUN mkdir -p /data/db && \
    chmod -R 750 /data && \
    chown -R 568:568 /data

USER 568

ENTRYPOINT [ "/usr/local/bin/mongod" ]
