#!/usr/bin/env bash

docker build -f ./rsyslog/Dockerfile-rsyslog ./rsyslog/ -t rsyslog-custom

docker compose -f docker-compose-log.yml down

docker compose -f docker-compose-log.yml up -d