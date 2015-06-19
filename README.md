# Docker Image with StatsD, InfluxDB and Grafana

## Versions

StatsD:   0.7.2<br>
InfluxDB: 0.9.0<br>
Grafana:  2.0.2<br>

## Quick Start

```sh
docker run -d \
  -p 3003:9000 \
  -p 3004:8083 \
  -p 8086:8086 \
  -p 22022:22 \
  -p 8125:8125/udp \
  samuelebistoletti/docker-statsd-influxdb
```
### Mapped Ports

| Host  | Container | Service          |
| ----- | --------- | ---------------- |
|  3003 |      9000 | grafana          |
|  8086 |      8086 | influxdb         |
|  3004 |      8083 | influxdb-admin   |
|  8125 |      8125 | statsd           |
| 22022 |        22 | sshd             |

### SSH

```sh
ssh root@localhost -p 22022
```
Password: root

### Grafana

Admin interface: http://localhost:3003

Username: root<br>
Password: root<br>

Add datasource and point it to:

localhost:8082

Database: data<br>
Username: data<br>
Password: data<br>

### Databases

DB1: data<br>
Username: data<br>
Password: data<br>

DB2: grafana<br>
Username: grafana<br>
Password: grafana<br>

Admin interface: http://localhost:3004<br>

Username: root<br>
Password: root<br>
Port:     8082
