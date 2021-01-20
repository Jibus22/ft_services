FROM alpine:3.12
#SQL
RUN apk update \
	&& apk add \
	mariadb \
	mariadb-client

RUN mkdir -p /run/mysqld \
	&& mkdir -p /var/lib/mysql

COPY my.cnf /etc/
#Without my.cnf saying "user=root", we have to set --user=root on each
#next mariadb command (especially on the mariadbd-safe, because the mariadb
#server can only be ran as root). Then it's better to copy it before.

#"root" is the only option and doesn't refers to any mariadb user who could be
#created nor to OS system user, but is a super-user account for mysql/mariadb.

#Initially this root account doesn't have password & have all privileges on all
#databases of the server. On the other hand, it can only connect locally
#(on the server himself), & not remotely via a mysql client (php-mysqli).

RUN mariadb-install-db --datadir=/var/lib/mysql

#Below, mariadbd must be ran as root. In background (&), in order to execute the
#followings mariadb commands, on the same container layer

RUN mariadbd-safe --datadir=/var/lib/mysql & sleep 1 \
	&& mariadb -e "CREATE DATABASE wpdb; CREATE USER \
'admin'@'%' IDENTIFIED BY 'pwd'; GRANT ALL PRIVILEGES ON *.* \
TO 'admin'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"
#mariadb-safe won't run the mariadbd server if anything goes wrong.

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



#Below is shell form ENTRYPOINT : It will ignore any CMD or docker run command
#https://docs.docker.com/engine/reference/builder/#entrypoint

ENTRYPOINT exec mariadbd-safe --datadir=/var/lib/mysql
#This run mariadb server in foreground, will keep the container alive
#'exec' command is used to be sure that the processus will be ran as PID root #1
#Docker likes this.

#Below forms would work also :

#ENTRYPOINT ["/bin/sh", "-c", "mariadbd-safe --datadir=/var/lib/mysql"]
#CMD ["/bin/sh", "-c", "mariadbd-safe --datadir=/var/lib/mysql"]
#CMD mariadbd-safe --datadir=/var/lib/mysql 
