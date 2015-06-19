# Docker Image with StatsD, InfluxDB and Grafana

## Versions

STATSD: 0.7.2
INFLUXDB: 0.9.0
GRAFANA: 2.0.2

## Quick Start

```sh
docker run -d \
  --name statsd-influxdb-grafana \
  -p 80:9000 \
  -p 3005:8083 \
  -p 22022:22 \
  -p 8125:8125/udp \
  samuelebistoletti/docker-statsd-influxdb
```
### Mapped Ports

| Host  | Container | Service          |
| ----- | --------- | ---------------- |
|   80  |      9000 | grafana          |
| 3005  |      8083 | influxdb-admin   |
| 8125  |      8125 | statsd           |
| 22022 |        22 | sshd             |

### SSH

```sh
ssh root@localhost -p 22022
```
Password: root

### Grafene

Admin interface: http://localhost

Username: root
Password: root

### Databases

DB1: data
Username: data
Password: data

DB2: grafana
Username: grafana
Password: grafana

Admin interface: http://localhost:3005