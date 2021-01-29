#!/bin/sh

#In each cases, binaries has to be ran with config file as parameter

telegraf --config etc/telegraf.conf &

#grafana-server needs the location of the application files also, with
#-homepath option
grafana-server -config /etc/grafana/grafana.ini -homepath /usr/share/grafana/
