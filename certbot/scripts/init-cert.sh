#!/bin/bash -e

set -o errexit

CERTS_DIR="/etc/haproxy/certs"
CERT_PATH="$CERTS_DIR/$LE_DOMAIN.pem"
HAPROXY_CERT="/usr/local/etc/haproxy/certs/$LE_DOMAIN.pem"

if [ -f "$CERT_PATH" ]; then
  echo "Certificate already exists, deleting it and apply for a new one."
  rm $CERT_PATH
fi

echo "Starting to apply for a new certificate..."

certbot certonly \
  --agree-tos \
  -d "$LE_DOMAIN" \
  --email "$LE_EMAIL" \
  --http-01-port 8080 \
  --non-interactive \
  --preferred-challenges http \
  --standalone

echo "Certificate generated."

cat \
  /etc/letsencrypt/live/"$LE_DOMAIN"/fullchain.pem \
  /etc/letsencrypt/live/"$LE_DOMAIN"/privkey.pem |
  # empty lines cause HAProxy to error!
  sed '/^$/d' > "$CERT_PATH"
