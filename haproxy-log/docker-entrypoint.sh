#!/bin/bash
set -o errexit
set -o nounset

# Optional ENV VAR:
#  HAPROXY_CFG_FILE  the absolute path to the HAPRoxy.cfg file you want to use
#    defaults to /usr/local/etc/haproxy/haproxy.cfg if unset

#PID_FILE="/var/run/haproxy.pid"

# readonly RSYSLOG_PID="/var/run/rsyslogd.pid"

# rm -f $RSYSLOG_PID

rsyslogd


# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	shift # "haproxy"
	# if the user wants "haproxy", let's add a couple useful flags
	#   -W  -- "master-worker mode" (similar to the old "haproxy-systemd-wrapper"; allows for reload via "SIGUSR2")
	#   -db -- disables background mode
	set -- haproxy -W -db "$@"
fi

exec "$@"


# # Make sure service is running
# service rsyslog start

# # Touch the log file so we can tail on it
# touch /var/log/haproxy.log

# # Throw the log to output
# tail -f /var/log/haproxy.log &

# # Start haproxy
# exec haproxy -W \
#   -f "${HAPROXY_CFG_FILE:-/usr/local/etc/haproxy/haproxy.cfg}" \
#   #-p $PID_FILE \
#   #-sf $(cat $PID_FILE)