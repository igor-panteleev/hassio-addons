#!/usr/bin/with-contenv bashio

set -e

nginx

exec gunicorn \
  --bind 127.0.0.1:8080 \
  --workers=1 \
  --threads=25 \
  --access-logfile '-' \
  --error-logfile '-' \
  --chdir /usr/local/lib/python3.13/site-packages/pgadmin4 \
  pgAdmin4:app
