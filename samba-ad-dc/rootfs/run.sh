#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

if [ ! -f /data/private/sam.ldb ]; then
  CONFIG_JSON=$(bashio::var.json \
      hostname "$(bashio::addon.ip_address)" \
      realm "$(bashio::config 'realm')" \
      domain "$(bashio::config 'domain')" \
      dns_forwarder "$(bashio::config 'dns_forwarder')")

  echo "$CONFIG_JSON" | tempio \
      -template /etc/samba/smb.gtpl \
      -out /etc/samba/smb.conf

  echo "$CONFIG_JSON" | tempio \
      -template /etc/resolv.gtpl \
      -out /etc/resolv.conf

  RANDOM_PASSWORD=$(bashio::var.random 20)
  samba-tool domain provision \
    --adminpass="${RANDOM_PASSWORD}"
  cp /data/private/krb5.conf /etc/krb5.conf
  echo "Admin password ${RANDOM_PASSWORD}"

  exit 0
else
  exec samba -i -M single
fi
