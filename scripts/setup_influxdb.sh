#!/bin/bash

set -m

API_URL="http://localhost:8086"

echo "=> About to create the following database: ${INFLUXDB_GRAFANA_DB}"
if [ -f "/.influxdb_configured" ]; then
    echo "=> Database had been created before, skipping ..."
else
    echo "=> Starting InfluxDB ..."
    /etc/init.d/influxdb start

    arr=$(echo ${INFLUXDB_GRAFANA_DB} | tr ";" "\n")

    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of InfluxDB service startup ..."
        sleep 3
        curl -k ${API_URL}/ping 2> /dev/null
        RET=$?
    done

    echo ""
    echo "=> Creating user for Grafana"
    curl -G $(echo ${API_URL}'/query') --data-urlencode "u=root" --data-urlencode "p=root" --data-urlencode "q=CREATE USER ${INFLUXDB_GRAFANA_USER} WITH PASSWORD '${INFLUXDB_GRAFANA_PW}'"

    for x in $arr
    do
        echo "=> Creating database: ${x}"
        curl -G $(echo ${API_URL}'/query') --data-urlencode "u=root" --data-urlencode "p=root" --data-urlencode "q=CREATE DATABASE ${x}"

        echo ""
        echo "=> Granting permission on database for Grafana user"
        curl -G $(echo ${API_URL}'/query') --data-urlencode "u=root" --data-urlencode "p=root" --data-urlencode "q=GRANT ALL ON ${x} TO ${INFLUXDB_GRAFANA_USER}"
        echo ""
    done

    touch "/.influxdb_configured"

    echo "=> Stopping InfluxDB ..."
    /etc/init.d/influxdb stop

    exit 0
fi

exit 0