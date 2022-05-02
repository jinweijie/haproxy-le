#!/bin/sh

set -o errexit

CERTS_DIR="/etc/haproxy/certs"
CERT_PATH="$CERTS_DIR/$LE_DOMAIN.pem"
HAPROXY_CERT="/usr/local/etc/haproxy/certs/$LE_DOMAIN.pem"

if [ -f "$CERT_PATH" ]; then
  echo "Certificate exists, attempting to renew..."
  
  RENEW_RESULT=$(certbot renew --http-01-port 8080)
 
  if echo $RENEW_RESULT | grep -q "not due for renewal"; then
    echo "Certificate is still ok, not yet due for renewal'."
    exit
  fi

else  
  echo "Certificate does not exist, please run init-cert.sh."
  exit
fi

if [ -f "/etc/letsencrypt/live/$LE_DOMAIN/fullchain.pem" ]; then

  echo "Generating haproxy certificate to $CERT_PATH..."
 
  cat /etc/letsencrypt/live/"$LE_DOMAIN"/fullchain.pem /etc/letsencrypt/live/"$LE_DOMAIN"/privkey.pem | \
    # empty lines cause HAProxy to error!
    sed '/^$/d' > "$CERT_PATH"

  echo "Updating HAProxy $HAPROXY_CERT..."

  echo "set ssl cert $HAPROXY_CERT <<\n$(cat $CERT_PATH)\n" | socat tcp-connect:haproxy:9999 -
  echo "set ssl cert done."
  echo "commit ssl cert $HAPROXY_CERT" | socat tcp-connect:haproxy:9999 -
  echo "commit ssl cert done."
  echo "show ssl cert $HAPROXY_CERT" | socat tcp-connect:haproxy:9999 -
  echo "HAProxy ssl cert updated."

else  
  echo "/etc/letsencrypt/live/$LE_DOMAIN/fullchain.pem not exists, skip updating HAProxy."
  exit
fi
