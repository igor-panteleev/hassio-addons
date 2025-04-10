#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::var.json \
    hostname "$(bashio::config 'hostname')" \
    hostname_admin "$(bashio::config 'hostname-admin')" \
    db "$(bashio::config 'database.type')" \
    db_username "$(bashio::config 'database.username')" \
    db_password "$(bashio::config 'database.password')" \
    db_url "$(bashio::config 'database.url')" |
tempio \
    -template /var/app/conf/keycloak.gtpl \
    -out /var/app/conf/keycloak.conf
