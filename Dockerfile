ARG CNPG="16.13-system-bullseye"
FROM ghcr.io/cloudnative-pg/postgresql:${CNPG}

ARG CNPG
ENV CNPG=${CNPG}

USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
SHELL ["/bin/bash", "-l", "-c"]

ARG TS="2.26.2"
ARG DEB="11-1613"

RUN apt update && apt install -y --no-install-recommends curl
RUN curl -s https://packagecloud.io/install/repositories/timescale/timescaledb/script.deb.sh | bash

RUN PG="${CNPG:0:2}" && PKG="$PG=$TS~debian$DEB" && \
    apt install -y --no-install-recommends \
        timescaledb-tools timescaledb-toolkit-postgresql-$PG \
        timescaledb-2-loader-postgresql-$PKG \
        timescaledb-2-postgresql-$PKG

RUN apt purge -y curl
RUN rm -rf /var/cache/apt/* /etc/apt/sources.list.d/timescaledb.list /etc/apt/trusted.gpg.d/timescale.gpg

USER 26
