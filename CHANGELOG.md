Docker StatsD InfluxDB Grafana integrated service
-----------------------------------

### Warning: UPGRADE FROM VERSION 2.3.0 TO VERSION 3.0.0 IS NOT POSSIBLE due internal architecture changes.

## v3.0.0 (2022-03-23)
* Full rewrite with Docker Compose service file
* Upgraded InfluxDB to version 2.1.1
* Upgraded Telegraf to version 1.21
* Upgraded Grafana to version 8.4.4
* Changed Grafana DB to Postgres with dedicated container

## v2.3.0 (2019-03-25)
* Upgraded Telegraf to version 1.9.4-1
* Upgraded InfluxDB to version 1.7.3
* Upgraded Grafana to version 6.0.0
* Upgraded Chronograf to version 1.7.8
* Upgraded NodeJS to version 11
* Updated Docker image to Ubuntu 18.04 LTS
* Removed traces of SSH server and credentials (use docker exec)
* Set provisioned datasource (InfluxDB) as default

## v2.2.0 (2018-11-11)
* Upgraded Telegraf to version 1.8.3-1
* Upgraded InfluxDB to version 1.7.0
* Upgraded Grafana to version 5.3.2
* Upgraded Chronograf to version 1.7.2
* Upgraded NodeJS to version 8
* Configure Grafana Provisioning Feature


## v2.1.0 (2018-06-11)

* Upgraded Grafana 5.1
* Installed Chronograf 1.5

## v2.0.0 (2017-01-28)

### Warning: upgrade from version 1.0.x is not supported, all persisted data in volumes will be lost if you delete the container.

* Ubuntu 16.04 LTS is the new Docker base image
* New init system with Supervisord
* StatsD InfluxDB backend connector removed
* StatsD Etsy removed
* StatsD has been fully replaced with InfluxData Telegraf, that supports StatsD protocol
* Upgraded InfluxDB to version 1.2
* Upgraded Grafana to version 4.1.1

## v1.0.2 (2016-09-15)

* Fix for bad proxy hash sum mismatch

## v1.0.1 (2016-06-27)

* Upgraded StatsD to version 0.8.0
* Upgraded InfluxDB to version 0.13.0
* Upgraded Grafana to version 3.0.4
* Changed StatsD backend connector for InfluxDB new version

## v1.0.0 (2015-07-19)

* Initial release
