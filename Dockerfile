FROM debian:latest
MAINTAINER Samuele Bistoletti <samuele.bistoletti@gmail.com>

# Default versions
ENV STATSD_VERSION 0.7.2
ENV INFLUXDB_VERSION 0.9.4.1
ENV GRAFANA_VERSION 2.1.3

# Database Defaults
ENV PRE_CREATE_DB data
ENV INFLUXDB_DATA_USER data
ENV INFLUXDB_DATA_PW data
ENV MYSQL_GRAFANA_USER grafana
ENV MYSQL_GRAFANA_PW grafana

# Environment variables
ENV DEBIAN_FRONTEND noninteractive

# Update system repositories
RUN apt-get -y update

# Install apt-utils
RUN apt-get -y --force-yes install apt-utils

# Upgrade system
RUN apt-get -y dist-upgrade

# Base dependencies
RUN apt-get -y --force-yes install\
 adduser\
 curl\
 git\
 htop\
 libfontconfig\
 mysql-client\
 mysql-server\
 net-tools\
 openssh-server\
 sudo\
 supervisor\
 vim\
 wget

# Set root password and configure SSH Daemon
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Configure Supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor

# Create support directories
RUN mkdir -p /var/run/sshd

# Configure MySql
ADD mysql/run.sh /usr/local/bin/run_mysql
ADD scripts/setup_mysql.sh /tmp/setup_mysql.sh
RUN /tmp/setup_mysql.sh

# Add Nodejs repository and install it
ADD scripts/setup_nodejs.sh /tmp/setup_nodejs.sh
RUN /tmp/setup_nodejs.sh
RUN apt-get -y --force-yes install nodejs

# Install InfluxDB
RUN wget http://s3.amazonaws.com/influxdb/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
	dpkg -i influxdb_${INFLUXDB_VERSION}_amd64.deb && rm influxdb_${INFLUXDB_VERSION}_amd64.deb

# Configure InfluxDB
ADD influxdb/influxdb.conf /etc/opt/influxdb/influxdb.conf
ADD influxdb/run.sh /usr/local/bin/run_influxdb
ADD scripts/setup_influxdb.sh /tmp/setup_influxdb.sh
RUN /tmp/setup_influxdb.sh

# Install StatsD
RUN git clone -b v${STATSD_VERSION} https://github.com/etsy/statsd.git /opt/statsd

# Configure StatsD
ADD statsd/config.js /opt/statsd/config.js
ADD statsd/run.sh /usr/local/bin/run_statsd

# Install StatsD InfluxDb Backend
RUN cd /opt/statsd && npm install git+https://github.com/bernd/statsd-influxdb-backend.git

# Install Grafana
RUN wget https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb && \
	dpkg -i grafana_${GRAFANA_VERSION}_amd64.deb && rm grafana_${GRAFANA_VERSION}_amd64.deb

# Configure Grafana
ADD grafana/grafana.ini /etc/grafana/grafana.ini
ADD grafana/run.sh /usr/local/bin/run_grafana

# Copy .bashrc
ADD system/bashrc /root/.bashrc

# Cleanup
RUN apt-get clean\
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create volumes
VOLUME /var/log
VOLUME /var/lib/mysql
VOLUME /var/opt/influxdb
VOLUME /opt/influxdb
VOLUME /opt/statsd
VOLUME /root

# Start Supervisor
CMD ["/usr/bin/supervisord"]
