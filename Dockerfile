FROM debian:latest
MAINTAINER Samuele Bistoletti <samuele.bistoletti@gmail.com>

# Environment variables
ENV DEBIAN_FRONTEND noninteractive

# InfluxDB Defaults
ENV	PRE_CREATE_DB data grafana
ENV	INFLUXDB_DATA_USER data
ENV	INFLUXDB_DATA_PW data
ENV	INFLUXDB_GRAFANA_USER grafana
ENV	INFLUXDB_GRAFANA_PW grafana

# Update system repositories
RUN apt-get -y update

# Install apt-utils
RUN apt-get -y --force-yes install apt-utils

# Upgrade system
RUN apt-get -y dist-upgrade

# Base dependencies
RUN apt-get -y --force-yes install\
 curl\
 git\
 htop\
 net-tools\
 openssh-server\
 sudo\
 supervisor\
 wget

# Set root password and configure SSH Daemon
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Configure Supervisord
ADD	supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Create support directories
RUN mkdir -p /var/run/sshd

# Add Nodejs repository and install it
ADD scripts/setup_nodejs.sh /tmp/setup_nodejs.sh
RUN /tmp/setup_nodejs.sh
RUN apt-get -y --force-yes install nodejs

# Install InfluxDB
ADD pkg/influxdb.deb /tmp/influxdb.deb
RUN sudo dpkg -i /tmp/influxdb.deb

# InfluxDB Configuration
ADD	influxdb/influxdb.conf /etc/opt/influxdb/influxdb.conf
ADD	influxdb/run.sh /usr/local/bin/run_influxdb
ADD scripts/setup_influxdb.sh /tmp/setup_influxdb.sh
RUN /tmp/setup_influxdb.sh

# Instal StatsD
RUN git clone -b v0.7.2 https://github.com/etsy/statsd.git /opt/statsd

# StatsD configuration
ADD statsd/config.js /opt/statsd/config.js
ADD	statsd/run.sh /usr/local/bin/run_statsd

# Install StatsD InfluxDb Backend
RUN cd /opt/statsd
RUN npm install statsd-influxdb-backend

# Cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start Supervisor
CMD ["/usr/bin/supervisord"]
