#!/bin/sh

# perform the log rotation
logrotate /etc/logrotate.d/haproxy.conf --verbose

# restart the rsyslog service
service rsyslog restart