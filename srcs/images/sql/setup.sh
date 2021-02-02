#!/bin/sh

#allows one to use built-ins such as fg and bg, which would be disabled under
#set +m (the default for non-interactive shells)
#set -m

#I have to install the database and configure it from this script and not in
#a container layer, because the data directory will be created (mounted) by
#k8s at runtime (persistent volume).

#Below, mariadbd must be ran as root. In background (&), in order to execute the
#followings mariadb commands, on the same startup script

mariadb-install-db
(mariadbd-safe) &
PID="$!"
until mysql
	do
	echo "NO_UP"
done
mariadb -e "CREATE DATABASE wpdb; CREATE USER \
'admin'@'%' IDENTIFIED BY 'pwd'; GRANT ALL PRIVILEGES ON *.* \
TO 'admin'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
mariadb wpdb < wpdb.sql

#mariadb-safe won't run the mariadbd server if anything goes wrong.

telegraf --config etc/telegraf.conf &
#A database wpdb is created, then an admin user with pwd password, with
#all privileges on all tables & databases.
#And the database dump wpdb.sql is loaded is the database wpdb, to recover
#database settings asked in the project (many users).
wait $PID

#Saying 'admin'@'%' rather than 'admin'@'localhost' gave me "access denied"
#pma error on a monolithic docker image (with all applications together).
#It could be because of '%' uses TCP/IP while localhost uses unix socket.
#The percent symbol means: any host, including remote and local connections

#But in microservice k8s architecture (pods in minikube - ft_service project),
#only 'admin'@'%' works. Server connects to "User: admin@172.17.0.1" -- I don't
#figure out why this private IP is choosen. It's a very close IP from the pods
#& it must come from kube-proxy which proxies everything, no more clues for now.

#https://dev.mysql.com/doc/refman/8.0/en/connection-access.html

#Format below ->
#"GRANT type_of_permission ON database_name.table_name TO
#'your_mysql_username'@'The_client_host_from_which_you_connect';"
