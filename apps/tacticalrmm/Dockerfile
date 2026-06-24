FROM python:3.14-slim AS builder

ARG TARGETPLATFORM
ARG VERSION
ARG SCRIPTS_VERSION=main

ENV VIRTUAL_ENV=/opt/venv \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /build

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        libc6-dev \
        git \
        libpango-1.0-0 \
        libpangocairo-1.0-0 && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m venv $VIRTUAL_ENV && \
    pip install --no-cache-dir pip==25.1 setuptools wheel

RUN git clone --depth 1 --branch v${VERSION} \
    https://github.com/amidaware/tacticalrmm.git /src

RUN git clone --branch ${SCRIPTS_VERSION} \
    https://github.com/amidaware/community-scripts.git /community-scripts

RUN pip install --no-cache-dir -r /src/api/tacticalrmm/requirements.txt


FROM python:3.14-slim

ARG TARGETPLATFORM
ARG VERSION

ENV VIRTUAL_ENV=/opt/venv \
    TACTICAL_DIR=/opt/tactical \
    PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=tacticalrmm.settings

LABEL org.opencontainers.image.title="TacticalRMM" \
      org.opencontainers.image.description="Remote monitoring and management tool" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/skyssolutions/containers/tree/main/apps/tacticalrmm"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        weasyprint \
        libpango-1.0-0 \
        libpangocairo-1.0-0 && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 1000 tactical && \
    useradd -u 1000 -g 1000 -M -d ${TACTICAL_DIR} -s /bin/bash tactical

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY --from=builder --chown=tactical:tactical /src/api/tacticalrmm ${TACTICAL_DIR}/api
COPY --from=builder --chown=tactical:tactical /community-scripts ${TACTICAL_DIR}/community-scripts

RUN mkdir -p \
        ${TACTICAL_DIR}/api/tacticalrmm/private/exe \
        ${TACTICAL_DIR}/api/tacticalrmm/private/log \
        ${TACTICAL_DIR}/certs \
        ${TACTICAL_DIR}/tmp \
        ${TACTICAL_DIR}/reporting/assets && \
    chown -R tactical:tactical ${TACTICAL_DIR}

COPY ./apps/tacticalrmm/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR ${TACTICAL_DIR}/api

USER tactical

EXPOSE 8080 8383

ENTRYPOINT ["/entrypoint.sh"]
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "8080", "tacticalrmm.asgi:application"]
