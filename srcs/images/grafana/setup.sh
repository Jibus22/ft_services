#!/bin/sh

#In each cases, binaries has to be ran with config file as parameter

telegraf --config etc/telegraf.conf &

exec "$@"
