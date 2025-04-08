ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base-python:3.13-alpine3.21

FROM ${BUILD_FROM}

# Setup base
ARG PGADMIN_VERSION="9.2"
ARG GUNICORN_VERSION="23.0.0"

RUN apk add --no-cache nginx openssl \
    && pip install --no-cache pgadmin4==${PGADMIN_VERSION} gunicorn==${GUNICORN_VERSION}

COPY rootfs /
