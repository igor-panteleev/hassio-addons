#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

DATA_PATH="/data/smb"

if bashio::config.true 'provisioning'; then
  rm -rf "${DATA_PATH}"
  CONFIG_JSON=$(bashio::var.json \
      hostname "$(bashio::addon.ip_address)" \
      realm "$(bashio::config 'realm')" \
      domain "$(bashio::config 'domain')" \
      dns_forwarder "$(bashio::config 'dns_forwarder')" \
      data_path "${DATA_PATH}")

  echo "$CONFIG_JSON" | tempio \
      -template /etc/samba/smb.gtpl \
      -out /etc/samba/smb.conf

  echo "$CONFIG_JSON" | tempio \
      -template /etc/resolv.gtpl \
      -out /etc/resolv.conf

  RANDOM_PASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20)
  samba-tool domain provision \
    --use-rfc2307 \
    --realm="$(bashio::config 'realm')" \
    --domain="$(bashio::config 'domain')" \
    --server-role=dc \
    --dns-backend=SAMBA_INTERNAL \
    --adminpass="${RANDOM_PASSWORD}"
  cp "${DATA_PATH}/private/krb5.conf" /etc/krb5.conf
  echo "Admin password: ${RANDOM_PASSWORD}"

  bashio::config.suggest.false 'provisioning' 'Initial setup is done.'

  exit 0
else
  exec samba -i -M single
fi
