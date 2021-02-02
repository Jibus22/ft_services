FROM alpine:3.12
#SQL
RUN echo $'https://dl-cdn.alpinelinux.org/alpine/v3.13/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.13/community' > etc/apk/repositories

RUN apk update && apk add telegraf
COPY telegraf.conf /etc/telegraf.conf

RUN apk update \
	&& apk add \
	mariadb \
	mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql \
	&& echo $'[mysqld]\n\
user = root\n\
datadir=/var/lib/mysql' > /etc/my.cnf
# No need to setup port=3306 because it's the default port

#Without my.cnf saying "user=root", we have to set --user=root on each
#next mariadb command (especially on the mariadbd-safe, because the mariadb
#server can only be ran as root). Then it's better to copy it before.

#"root" is the only option and doesn't refers to any mariadb user who could be
#created nor to OS system user, but is a super-user account for mysql/mariadb.

#Initially this root account doesn't have password & have all privileges on all
#databases of the server. On the other hand, it can only connect locally
#(on the server himself), & not remotely via a mysql client (php-mysqli).

COPY wpdb.sql /

COPY setup.sh /
ENTRYPOINT ["/setup.sh"]


######## ! Following were commented at a point I was running container #########
######## ! with only mariadbd server as a process. But it still interesting. ###

#Below is shell form ENTRYPOINT : It will ignore any CMD or docker run command
#https://docs.docker.com/engine/reference/builder/#entrypoint

#ENTRYPOINT exec mariadbd-safe --datadir=/var/lib/mysql
#This run mariadb server in foreground, will keep the container alive
#'exec' command is used to be sure that the processus will be ran as PID root #1
#Docker likes this.

#Below forms would work also :

#ENTRYPOINT ["/bin/sh", "-c", "mariadbd-safe --datadir=/var/lib/mysql"]
#CMD ["/bin/sh", "-c", "mariadbd-safe --datadir=/var/lib/mysql"]
#CMD mariadbd-safe --datadir=/var/lib/mysql 
