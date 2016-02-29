#!/bin/sh

echo "=> Starting StatsD ..."
bash -c "cd /opt/statsd && /usr/bin/nodejs stats.js config.js 1>/var/log/statsd.log 2>&1 & echo \$! > /var/run/statsd.pid"

exit 0