#!/bin/sh

telegraf --config etc/telegraf.conf &

/usr/sbin/php-fpm7

exec "$@"
