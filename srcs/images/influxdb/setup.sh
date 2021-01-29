#!/bin/sh

#In each cases, binaries has to be ran with config file as parameter

influxd run -config etc/influxdb.conf &

#When the influxdb database server starts, the default "telegraf" database
#is created

telegraf --config etc/telegraf.conf
