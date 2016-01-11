#!/bin/bash

set -m

CONFIG_FILE="/etc/influxdb/influxdb.conf"

echo "=> Starting InfluxDB ..."
exec /usr/bin/influxd -config=${CONFIG_FILE}
