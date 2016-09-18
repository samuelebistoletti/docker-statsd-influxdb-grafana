#!/bin/bash -e

function check_grafana_connection {
  while ! nc -z localhost 3000 < /dev/null; do   
        sleep 1;
    done
}

function grafana_check_data_source {
  check_grafana_connection
  curl --silent  'http://admin:admin@localhost:3000/api/datasources' \
    | grep "{\"name\":\"${INFLUXDB_GRAFANA_DB}\"}" --silent
}

function grafana_create_data_source {
  check_grafana_connection
  curl --silent 'http://admin:admin@localhost:3000/api/datasources' \
    -X POST -H "Content-Type: application/json" \
    --data-binary \
      "{
        \"name\":\"influxdb\",
        \"type\":\"influxdb\",
        \"url\":\"http://localhost:8086\",
        \"access\":\"proxy\",
        \"isDefault\":true,
        \"basicAuth\":false,
        \"database\":\"'${INFLUXDB_GRAFANA_DB}'\",
        \"user\":\"\",
        \"password\":\"\",
        \"jsonData\":null
      }" 2>&1 | grep 'Datasource added' --silent
}

function setup_grafana {
  if grafana_check_data_source "${INFLUXDB_GRAFANA_DB}"; then
    echo "Grafana: Data source ${INFLUXDB_GRAFANA_DB} already exists"
    install_plugins
  else
    echo "Grafana: Data source ${INFLUXDB_GRAFANA_DB} is being created"
    echo
    if grafana_create_data_source "${INFLUXDB_GRAFANA_DB}"; then
      echo "Grafana: Data source ${INFLUXDB_GRAFANA_DB} created"
      install_plugins
    else
      echo "Grafana: Data source ${INFLUXDB_GRAFANA_DB} could not be created"
      echo
      install_plugins
    fi
  fi
}

function install_plugins {
  echo "=> Installing some maybe useful plugins..."
grafana-cli plugins install grafana-clock-panel 
grafana-cli plugins install grafana-piechart-panel 
grafana-cli plugins install mtanda-histogram-panel
  
echo "=> Finished installing plugins..."
}

function die {
   /etc/init.d/grafana-server stop
   exit 0
}

function setup {
  /etc/init.d/grafana-server start
  setup_grafana "${INFLUXDB_GRAFANA_DB}"
  #fill_influx_sample_data
  die
}

function fill_influxdb_sample_data {
  for _ in $(seq 3600); do
    curl -X POST \
      "http://localhost:8086/db/${INFLUXDB_GRAFANA_DB}/series?u=${1}&p=${1}" \
      -d "[{\"name\":\"data\",\"columns\":[\"foo\",\"bar\"],\"points\":[[$((RANDOM%200+100)),$((RANDOM%300+50))]]}]";
    sleep 1;
  done
}

  setup