#!/bin/sh

#In each cases, binaries has to be ran with config file as parameter

telegraf --config etc/telegraf.conf &

#When the influxdb database server starts, the default "telegraf" database
#is created

influxd run -config etc/influxdb.conf
