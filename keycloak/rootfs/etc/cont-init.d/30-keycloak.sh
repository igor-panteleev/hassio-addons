#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::var.json \
    hostname "$(bashio::config 'hostname')" \
    db "$(bashio::config 'db_type')" \
    db_username "$(bashio::config 'db_username')" \
    db_password "$(bashio::config 'db_password')" \
    db_url "$(bashio::config 'db_url')" |
tempio \
    -template /var/app/conf/keycloak.gtpl \
    -out /var/app/conf/keycloak.conf
