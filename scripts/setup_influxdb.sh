#!/bin/bash

set -m

CONFIG_FILE="/etc/influxdb/influxdb.conf"

API_URL="http://localhost:8086"

echo "=> About to create the following database: ${PRE_CREATE_DB}"
if [ -f "/.influxdb_configured" ]; then
    echo "=> Database had been created before, skipping ..."
else
    echo "=> Starting InfluxDB ..."
    exec /usr/bin/influxd -config=${CONFIG_FILE} &
    arr=$(echo ${PRE_CREATE_DB} | tr ";" "\n")

    #wait for the startup of influxdb
    RET=1
    while [[ RET -ne 0 ]]; do
        echo "=> Waiting for confirmation of InfluxDB service startup ..."
        sleep 3
        curl -k ${API_URL}/ping 2> /dev/null
        RET=$?
    done
    echo ""

    for x in $arr
    do
        echo "=> Creating database: ${x}"
	curl -G $(echo ${API_URL}'/query') --data-urlencode "u=root" --data-urlencode "p=root" --data-urlencode "q=CREATE DATABASE ${x}"
    done
    echo ""

    echo "=> Creating User for database: data"
    curl -G $(echo ${API_URL}'/query') --data-urlencode "u=root" --data-urlencode "p=root" --data-urlencode "q=CREATE USER ${INFLUXDB_DATA_USER} WITH PASSWORD '${INFLUXDB_DATA_PW}'"
    curl -G $(echo ${API_URL}'/query') --data-urlencode "u=root" --data-urlencode "p=root" --data-urlencode "q=GRANT ALL ON data TO ${INFLUXDB_DATA_USER}"
    echo ""

    touch "/.influxdb_configured"
    exit 0
fi

exit 0
