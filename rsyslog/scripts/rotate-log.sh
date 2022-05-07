#!/bin/sh

# perform the log rotation
logrotate /etc/logrotate.d/haproxy.conf --state /var/log/haproxy.log --verbose

# restart the rsyslog service
service rsyslog restart