ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.21

FROM ${BUILD_FROM}

# Setup base
ARG KEYCLOAK_VERSION="26.1.4"
ARG OPENJDK_VERSION="21.0.6_p7-r0"

ENV APP_DIR /var/app

RUN apk add --no-cache unzip openjdk21-jdk=${OPENJDK_VERSION} \
    && curl -J -L -o /tmp/keycloak.zip \
        "https://github.com/keycloak/keycloak/releases/download/${KEYCLOAK_VERSION}/keycloak-${KEYCLOAK_VERSION}.zip" \
    && mkdir -p ${APP_DIR}

RUN unzip /tmp/keycloak.zip -d /tmp \
    && mv /tmp/keycloak-${KEYCLOAK_VERSION}/* ${APP_DIR} \
    && cd ${APP_DIR} \
    && rm -rf \
      /tmp/.[!.]* \
      /tmp/*

COPY rootfs /
