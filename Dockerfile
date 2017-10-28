FROM stellar/base:latest

EXPOSE 5432 8000 11625 11626

RUN echo "[start: dependencies]" \
    && apt-get update \
    && apt-get install -y \
        curl git libpq-dev libsqlite3-dev libsasl2-dev postgresql-client postgresql postgresql-contrib sudo vim zlib1g-dev supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "[end: dependencies]"


ENV STELLAR_CORE_VERSION 0.6.3-391-708237b0
ENV HORIZON_VERSION 0.11.0

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

ADD common /opt/stellar-default/common
ADD pubnet /opt/stellar-default/pubnet
ADD testnet /opt/stellar-default/testnet
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