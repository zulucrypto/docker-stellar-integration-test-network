FROM stellar/base:latest

# 5432 - postgres
# 8000 - horizon https://github.com/stellar/go/tree/master/services/horizon
# 8006 - bridge server https://github.com/stellar/bridge-server
# 11625 - stellar core peer port
# 11626 - stellar core command port
EXPOSE 5432 8000 8006 11625 11626

RUN echo "[start: dependencies]" \
    && apt-get update \
    && apt-get install -y \
        curl git libpq-dev libsqlite3-dev libsasl2-dev postgresql-client postgresql postgresql-contrib sudo vim zlib1g-dev supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "[end: dependencies]"


ENV STELLAR_CORE_VERSION 9.1.0-494-a278e959
ENV HORIZON_VERSION 0.11.1
ENV BRIDGE_VERSION 0.0.30

RUN echo "[start: stellar install]" \
    && wget -O stellar-core.deb https://s3.amazonaws.com/stellar.org/releases/stellar-core/stellar-core-${STELLAR_CORE_VERSION}_amd64.deb \
    && dpkg -i stellar-core.deb \
    && rm stellar-core.deb \
    && wget -O horizon.tar.gz https://github.com/stellar/horizon/releases/download/v${HORIZON_VERSION}/horizon-v${HORIZON_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf horizon.tar.gz \
    && mv /horizon-v${HORIZON_VERSION}-linux-amd64/horizon /usr/local/bin \
    && chmod +x /usr/local/bin/horizon \
    && rm -rf horizon.tar.gz /horizon-v${HORIZON_VERSION}-linux-amd64 \
    && echo "[end: stellar install]"

# Install stellar bridge server
RUN echo "[start: installing stellar bridge]" \
    && mkdir -p /opt/stellar/bridge \
    && curl -L https://github.com/stellar/bridge-server/releases/download/v${BRIDGE_VERSION}/bridge-v${BRIDGE_VERSION}-linux-amd64.tar.gz \
        | tar -xz -C /opt/stellar/bridge --strip-components=1 \
    && echo "[end: installing stellar bridge"

ADD common          /opt/stellar-default/common
# Public network
ADD pubnet          /opt/stellar-default/pubnet
# Test network
ADD testnet         /opt/stellar-default/testnet
# Private integration testing network with a single node and fixtures
ADD integrationnet  /opt/stellar-default/integrationnet

ADD start /

RUN echo "[start: configuring paths and users]" \
    && useradd --uid 10011001 --home-dir /home/stellar --no-log-init stellar \
    && mkdir -p /home/stellar \
    && chown -R stellar:stellar /home/stellar \
    && mkdir -p /opt/stellar \
    && touch /opt/stellar/.docker-ephemeral \
    && ln -s /opt/stellar /stellar \
    && ln -s /opt/stellar/core/etc/stellar-core.cfg /stellar-core.cfg \
    && ln -s /opt/stellar/horizon/etc/horizon.env /horizon.env \
    && chmod +x /start \
    && echo "[end: configuring paths and users]"

ENTRYPOINT ["/init", "--", "/start" ]
CMD ["--integrationnet"]
