FROM ghcr.io/phusion/baseimage:jammy-1.0.1

# renovate: datasource=npm depName=renovate versioning=npm
ARG RENOVATE_VERSION=37.89.3

ENV CRON_SCHEDULE="0 * * * *"

# Update it first
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" && apt-get install -y ca-certificates curl gnupg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && apt-get update && apt install nodejs -y
RUN npm install -g renovate@${RENOVATE_VERSION}

RUN mkdir -p /etc/my_init.d && mkdir -p /etc/custom
COPY ./apps/renovate/setup_cron.sh /etc/my_init.d/setup_cron.sh
COPY ./apps/renovate/run_renovate.sh /etc/custom/run_renovate.sh

CMD ["/sbin/my_init"]