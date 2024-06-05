ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.20

FROM ${BUILD_FROM}

# Setup base
ARG VOUCH_PROXY_VERSION="v0.40.0"
ARG GOLANG_VERSION="1.22.3-r0"

ENV GOPATH /go
ENV GOMODCACHE ${GOPATH}/pkg/mod
ENV APP_DIR /var/app

RUN mkdir -p ${GOMODCACHE} \
    && apk add --no-cache go=${GOLANG_VERSION} \
    && curl -J -L -o /tmp/vouch-proxy.tar.gz \
        "https://github.com/vouch/vouch-proxy/archive/refs/tags/${VOUCH_PROXY_VERSION}.tar.gz" \
    && mkdir -p ${APP_DIR} \
    && tar zxvf \
        /tmp/vouch-proxy.tar.gz \
        --strip 1 -C ${APP_DIR} \
    && cd ${APP_DIR} \
    && ./do.sh goget \
    && ./do.sh build \
    && rm -rf \
      /tmp/.[!.]* \
      /tmp/*

COPY run.sh /
CMD [ "/run.sh" ]