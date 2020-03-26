# Docker Image with Telegraf (StatsD), InfluxDB and Grafana

:facepunch: Battle-tested

[![CircleCI](https://circleci.com/gh/samuelebistoletti/docker-statsd-influxdb-grafana.svg?style=svg)](https://circleci.com/gh/samuelebistoletti/docker-statsd-influxdb-grafana)

## Versions

### Warning, breaking change: upgrade from version 1.0.x of this image is not supported, all persisted data in volumes will be lost if you delete the container.

* Docker Image:      2.3.0
* Ubuntu:            18.04
* InfluxDB:          1.7.10
* Telegraf (StatsD): 1.13.4-1
* Grafana:           6.7.1

## Quick Start

To start the container the first time launch:

```sh
docker run --ulimit nofile=66000:66000 \
  -d \
  --name docker-statsd-influxdb-grafana \
  -p 3003:3003 \
  -p 3004:8888 \
  -p 8086:8086 \
  -p 8125:8125/udp \
  samuelebistoletti/docker-statsd-influxdb-grafana:latest
```

You can replace `latest` with the desired version listed in changelog file.

To stop the container launch:

```sh
docker stop docker-statsd-influxdb-grafana
```

To start the container again launch:

```sh
docker start docker-statsd-influxdb-grafana
```

## Mapped Ports

```
Host		Container		Service

3003		3003			grafana
3004		8888			influxdb-admin (chronograf)
8086		8086			influxdb
8125		8125			statsd
```

## Grafana

Open <http://localhost:3003>

```
Username: root
Password: root
```

### Add data source on Grafana

1. Using the wizard click on `Add data source`
2. Choose a `name` for the source and flag it as `Default`
3. Choose `InfluxDB` as `type`
4. Choose `direct` as `access`
5. Fill remaining fields as follows and click on `Add` without altering other fields

```
Url: http://localhost:8086
Database:	telegraf
User: telegraf
Password:	telegraf
```

Basic auth and credentials must be left unflagged. Proxy is not required.

Now you are ready to add your first dashboard and launch some query on database.

## InfluxDB

### Web Interface

Open <http://localhost:3004>

```
Username: root
Password: root
Port: 8086
```

### InfluxDB Shell (CLI)

1. Attach to docker container, run shell `/bin/bash`
2. Launch `influx` to open InfluxDB Shell (CLI)
