FROM alpine:3.12
#WORDPRESS
RUN echo $'https://dl-cdn.alpinelinux.org/alpine/v3.13/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.13/community' > etc/apk/repositories

RUN apk update && apk add telegraf
COPY telegraf.conf /etc/telegraf.conf

#php7 mbstring, json & session are required modules to work with phpmyadmin &
#wordpress also
RUN apk update \
	&& apk add \
	nginx \
	php-fpm \
	php7-mysqli \
	php7-mbstring \
	php7-json \
	php7-session \
	&& mkdir /run/nginx \
	&& mkdir -p /var/www/homepage

RUN wget http://wordpress.org/latest.tar.gz \
	&& tar -xf latest.tar.gz -C var/www/homepage/ \
	&& rm latest.tar.gz

COPY wp-config.php /var/www/homepage/wordpress/
#the wordpress config must match with a mariadb database and user, otherwise
#a database connection error will appear. DB_HOST must match with the remote
#mysql server, so the mysql service is given (& IP resolved by k8s dns) instead
#of localhost.

COPY setup.sh /
ENTRYPOINT ["/setup.sh"]
CMD ["nginx", "-g", "daemon off;"]

#   ID -----[WP]------- pwd
# admin --------------- pwd
# utilisateur1 -------- donaldtrump
# utilisateur2 -------- joebiden
# utilisateur3 -------- stevejobs

#Wordpress database is loaded in the runtime script of
#mysql container (srs/images/mysql/setup.sh)
