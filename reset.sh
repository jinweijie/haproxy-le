#!/usr/bin/env bash

set -o errexit

read -p "Will delete .env, haproxy/certs, and haproxy/haproxy.cfg. Are you sure? (y/n) " -n 1 -r REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo rm -rf ./.env ./haproxy/certs ./haproxy/haproxy.cfg
  echo -e "\nReset done."
else
  echo -e "\nCancelled."
fi
