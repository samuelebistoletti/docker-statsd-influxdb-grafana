FROM phusion/baseimage:0.9.18
MAINTAINER Samuele Bistoletti <samuele.bistoletti@gmail.com>

CMD ["/sbin/my_init"]

# Default versions
ENV STATSD_VERSION 0.8.0
ENV INFLUXDB_VERSION 0.13.0
ENV GRAFANA_VERSION 3.0.4-1464167696

# Database Defaults
ENV INFLUXDB_GRAFANA_DB datasource
ENV INFLUXDB_GRAFANA_USER datasource
ENV INFLUXDB_GRAFANA_PW datasource
ENV MYSQL_GRAFANA_USER grafana
ENV MYSQL_GRAFANA_PW grafana

# Environment variables
ENV DEBIAN_FRONTEND noninteractive

# Fix bad proxy issue
ADD system/99fixbadproxy /etc/apt/apt.conf.d/99fixbadproxy

# Clear previous sources
RUN rm /var/lib/apt/lists/* -vf

# Update system repositories
RUN apt-get -y update

# Upgrade system
RUN apt-get -y dist-upgrade

# Base dependencies
RUN apt-get -y --force-yes install\
 curl\
 wget\
 git\
 htop\
 libfontconfig\
 mysql-client\
 mysql-server\
 net-tools

# Create support directories
RUN mkdir -p /etc/my_init.d

# Set root password and configure SSH
RUN echo 'root:root' | chpasswd

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Configure MySql
ADD mysql/run.sh /etc/my_init.d/01_run_mysql.sh
ADD scripts/setup_mysql.sh /tmp/setup_mysql.sh
RUN /tmp/setup_mysql.sh

# Add Nodejs repository and install it
ADD scripts/setup_nodejs.sh /tmp/setup_nodejs.sh
RUN /tmp/setup_nodejs.sh
RUN apt-get -y --force-yes install nodejs

# Install InfluxDB
RUN wget https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && rm influxdb_${INFLUXDB_VERSION}_amd64.deb

# Configure InfluxDB
ADD influxdb/influxdb.conf /etc/influxdb/influxdb.conf
ADD influxdb/run.sh /etc/my_init.d/02_run_influxdb.sh
ADD influxdb/init.sh /etc/init.d/influxdb
ADD scripts/setup_influxdb.sh /tmp/setup_influxdb.sh
RUN /tmp/setup_influxdb.sh

# Install StatsD
RUN git clone -b v${STATSD_VERSION} https://github.com/etsy/statsd.git /opt/statsd

# Configure StatsD
ADD statsd/config.js /opt/statsd/config.js
ADD statsd/run.sh /etc/my_init.d/03_run_statsd.sh

# Install StatsD InfluxDb Backend
RUN cd /opt/statsd && npm install git+https://github.com/gillesdemey/statsd-influxdb-backend.git

# Install Grafana
RUN wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
	dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && rm grafana_${GRAFANA_VERSION}_amd64.deb

# Configure Grafana
ADD grafana/grafana.ini /etc/grafana/grafana.ini
ADD grafana/run.sh /etc/my_init.d/04_run_grafana.sh

# Copy .bashrc
ADD system/bashrc /root/.bashrc

# Cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create volumes
VOLUME /var/log
VOLUME /var/lib/mysql
VOLUME /var/lib/influxdb
VOLUME /opt/statsd
VOLUME /root
