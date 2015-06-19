# Docker Image with StatsD, InfluxDB and Grafana

## Versions

StatsD:   0.7.2<br>
InfluxDB: 0.9.0<br>
Grafana:  2.0.2<br>

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

### Grafana

Admin interface: http://localhost

Username: root<br>
Password: root<br>

### Databases

DB1: data<br>
Username: data<br>
Password: data<br>

DB2: grafana<br>
Username: grafana<br>
Password: grafana<br>

Admin interface: http://localhost:3005
