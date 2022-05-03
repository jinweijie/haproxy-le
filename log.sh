#!/usr/bin/env bash

docker build -f ./haproxy-log/Dockerfile-haproxy ./haproxy-log -t haproxy-rsyslog

docker compose -f ./docker-compose-log.yml down

docker compose -f ./docker-compose-log.yml up -d