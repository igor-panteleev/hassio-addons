#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

DATA_DIR="/data/smb"

generate_password() {
    local length group_string pool="" char
    local upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local lower="abcdefghijklmnopqrstuvwxyz"
    local digit="0123456789"
    local special="@#$%&*+="
    local -a required_chars all_chars

    length="${1:-12}"
    group_string="${2:-upper|lower|digit|special}"

    # Split group_string into array
    IFS='|' read -r -a groups <<< "$group_string"

    # Validate length
    if [ "$length" -lt "${#groups[@]}" ]; then
        echo "Error: Length must be at least ${#groups[@]} for selected groups" >&2
        return 1
    fi

    # Select one char from each group and build full character pool
    for group in "${groups[@]}"; do
        case "$group" in
            upper)
                char=$(echo "$upper" | fold -w1 | shuf | head -n1)
                pool+="$upper"
                ;;
            lower)
                char=$(echo "$lower" | fold -w1 | shuf | head -n1)
                pool+="$lower"
                ;;
            digit)
                char=$(echo "$digit" | fold -w1 | shuf | head -n1)
                pool+="$digit"
                ;;
            special)
                char=$(echo "$special" | fold -w1 | shuf | head -n1)
                pool+="$special"
                ;;
            *)
                echo "Unknown group: $group" >&2
                return 1
                ;;
        esac
        required_chars+=("$char")
    done

    # Fill the rest with random chars from combined pool
    all_chars=("${required_chars[@]}")
    while [ "${#all_chars[@]}" -lt "$length" ]; do
        char=$(echo "$pool" | fold -w1 | shuf | head -n1)
        all_chars+=("$char")
    done

    # Shuffle final password
    printf "%s\n" "${all_chars[@]}" | shuf | tr -d '\n '
    echo
}

bashio::log.level bashio::config 'log_level'

if bashio::config.true 'provisioning'; then
  rm -rf "${DATA_DIR}"
  mkdir -p "${DATA_DIR}"

  CONFIG_JSON=$(bashio::var.json \
      hostname "$(bashio::addon.ip_address)" \
      realm "$(bashio::config 'realm')" \
      domain "$(bashio::config 'domain')" \
      dns_forwarder "$(bashio::config 'dns_forwarder')" \
      data_dir "${DATA_DIR}")

  echo "$CONFIG_JSON" | tempio \
      -template /etc/samba/smb.gtpl \
      -out /etc/samba/smb.conf

  echo "$CONFIG_JSON" | tempio \
      -template /etc/resolv.gtpl \
      -out /etc/resolv.conf

  PASSWORD=$(generate_password)
  samba-tool domain provision \
    --use-rfc2307 \
    --realm="$(bashio::config 'realm')" \
    --domain="$(bashio::config 'domain')" \
    --server-role=dc \
    --dns-backend=SAMBA_INTERNAL \
    --adminpass="${PASSWORD}"
  cp "${DATA_DIR}/private/krb5.conf" /etc/krb5.conf
  bashio::log.yellow "Admin password: ${PASSWORD}"

  bashio::config.suggest.false 'provisioning' 'Initial setup is done.'

  exit 0
else
  bashio::log.debug "smb.conf" "$(cat /etc/samba/smb.conf)"
  bashio::log.debug "resolv.conf" "$(cat /etc/resolv.conf)"
  bashio::log.debug "krb5.conf" "$(cat /etc/krb5.conf)"
  exec samba -i -M single
fi
