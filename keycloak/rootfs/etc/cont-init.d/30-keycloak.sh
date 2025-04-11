#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

declare http_enabled=true

if bashio::config.true 'ssl'; then
  bashio::config.require.ssl
  http_enabled=false
  sed -i '4 i https-certificate-file /ssl/{{ .certfile }}' /var/app/conf/keycloak.gtpl
  sed -i '4 i https-certificate-key-file /ssl/{{ .keyfile }}' /var/app/conf/keycloak.gtpl
  bashio::log.info "Ssl enabled, please use https for connection"
else
  sed -i "4 i proxy-headers=xforwarded" /var/app/conf/keycloak.gtpl
fi

bashio::var.json \
    http_enabled "${http_enabled}" \
    hostname_debug "$(bashio::config 'hostname_debug')" \
    db "$(bashio::config 'db_type')" \
    db_username "$(bashio::config 'db_username')" \
    db_password "$(bashio::config 'db_password')" \
    db_url "$(bashio::config 'db_url')" \
    certfile "$(bashio::config 'certfile')" \
    keyfile "$(bashio::config 'keyfile')" |
tempio \
    -template /var/app/conf/keycloak.gtpl \
    -out /var/app/conf/keycloak.conf
