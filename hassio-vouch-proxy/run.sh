#!/usr/bin/with-contenv bashio

set -e

CONFIG_DIR="${APP_DIR}/config"
CONFIG="${CONFIG_DIR}/config.yml"


# Ensure config dir exists
mkdir -p "${CONFIG_DIR}"

# Create config
LOG_LEVEL=$(bashio::config 'log_level')
DOMAIN=$(bashio::config 'domain')
HASSIO_SUBDOMAIN=$(bashio::config 'hassio_subdomain')
VOUCH_SUBDOMAIN=$(bashio::config 'vouch_subdomain')
HASSIO_URL="https://${HASSIO_SUBDOMAIN}.${DOMAIN}"
VOUCH_URL="https://${VOUCH_SUBDOMAIN}.${DOMAIN}"

{
    echo "vouch:"
    echo "  logLevel: ${LOG_LEVEL}"
    echo "  domains:"
    echo "    - ${DOMAIN}"
    echo "  whiteList:"
    echo "    - homeassistant"
    echo "oauth:"
    echo "  provider: homeassistant"
    echo "  client_id: ${VOUCH_URL}"
    echo "  callback_url: ${VOUCH_URL}/auth"
    echo "  auth_url: ${HASSIO_URL}/auth/authorize"
    echo "  token_url: ${HASSIO_URL}/auth/token"
} > "${CONFIG}"

# Start vouch proxy
bashio::log.info "Starting vouch proxy..."
exec "${APP_DIR}/vouch-proxy"
