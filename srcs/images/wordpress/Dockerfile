FROM alpine:3.12
#WORDPRESS
COPY index.html /var/www/homepage/

#php7 mbstring, json & session are required modules to work with phpmyadmin &
#wordpress also
RUN apk update \
	&& apk add \
	nginx \
	php-fpm \
	php7-mysqli \
	php7-mbstring \
	php7-json \
	php7-session

RUN mkdir /run/nginx \
	&& echo '<?php phpinfo(); ?>' > /var/www/homepage/info.php

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
