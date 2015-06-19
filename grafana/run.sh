#!/bin/bash

set -m

echo "=> Starting Grafana ..."
exec /etc/init.d/grafana-server start
