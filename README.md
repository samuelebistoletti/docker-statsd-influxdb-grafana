# Docker Image with StatsD, InfluxDB and Grafana

## Versions

StatsD:   0.7.2

InfluxDB: 0.9.0

Grafana:  2.0.2

## Quick Start

To start the container the first time you run it launch:

```sh
docker run -d \
  --name docker-statsd-influxdb-grafana \
  -p 3003:9000 \
  -p 3004:8083 \
  -p 8086:8086 \
  -p 22022:22 \
  -p 8125:8125/udp \
  samuelebistoletti/docker-statsd-influxdb-grafana
```

To stop the container then launch:

```sh
docker stop docker-statsd-influxdb-grafana
```

To start the container again launch:

```sh
docker start docker-statsd-influxdb-grafana
```

### Mapped Ports

```sh

Host		Container		Service

3003		9000			grafana
8086		8086			influxdb
3004		8083			influxdb-admin
8125		8125			statsd
22022		22				sshd
```
### SSH

```sh
ssh root@localhost -p 22022
```
Password: root

### Grafana

Admin interface: http://localhost:3003

Username: root
Password: root

Add datasource and point it to:

localhost:8082

Database: data
Username: data
Password: data

### Databases

DB1: data
Username: data
Password: data

DB2: grafana
Username: grafana
Password: grafana

Admin interface: http://localhost:3004

Username: root
Password: root
Port:     8082
