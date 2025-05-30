ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:3.21

FROM ${BUILD_FROM}

# Setup base
ARG SAMBA_VERSION="4.20.6-r1"
ARG KERBEROS_VERSION="1.21.3-r0"

RUN apk add --no-cache \
    samba-dc=${SAMBA_VERSION} samba-common-tools=${SAMBA_VERSION} \
    krb5=${KERBEROS_VERSION} attr


COPY rootfs /

CMD [ "/run.sh" ]
