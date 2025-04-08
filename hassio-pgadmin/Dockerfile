ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base-python:3.12-alpine3.21

FROM ${BUILD_FROM}

# Setup base
ARG PGADMIN_VERSION="9.2"
ARG GUNICORN_VERSION="23.0.0"

RUN apk add --no-cache nginx gcc \
    && pip install --no-cache --upgrade pip setuptools wheel \
    && pip install --no-cache pgadmin4==${PGADMIN_VERSION} gunicorn==${GUNICORN_VERSION}

COPY rootfs /

CMD [ "/run.sh" ]
