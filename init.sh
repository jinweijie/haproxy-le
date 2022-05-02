#!/usr/bin/env bash

set -o errexit

touch .env
source .env

if [ -z "$LE_DOMAIN" ]; then
  read -rp "Please enter your domain name: " LE_DOMAIN

  if [ -z "$LE_DOMAIN" ]; then
    echo "You must provide a domain name, now exit..."
    exit 1
  fi

  echo "LE_DOMAIN=$LE_DOMAIN" >> .env
fi

if [ -z "$LE_EMAIL" ]; then
  read -rp "Please enter your email: " LE_EMAIL

  if [ -z "$LE_EMAIL" ]; then
    echo "You must provide an email, now exit..."
    exit 1
  fi

  echo "LE_EMAIL=$LE_EMAIL" >> .env
fi

if ! [ -f ./haproxy/haproxy.cfg ]; then
  echo "Generating example haproxy config file..."
  sed "s/<LE_DOMAIN>/$LE_DOMAIN/" ./haproxy/haproxy_sample.cfg > ./haproxy/haproxy.cfg
fi

echo "Start initializing..."

sudo docker compose -f ./docker-compose-init.yml up --build -d 

echo "Waiting 60 seconds to let the initialization finish..."

sleep 60

echo "Starting to finish the initialization..."

sudo docker compose -f ./docker-compose-init.yml down

echo "Done."