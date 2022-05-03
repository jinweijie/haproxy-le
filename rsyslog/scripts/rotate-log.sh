#!/bin/sh

logrotate /etc/logrotate.d/haproxy.conf --state /var/log/haproxy.log --verbose