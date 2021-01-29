FROM alpine:3.12
#PHPMYADMIN
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
	&& mkdir -p /var/www/homepage/

RUN wget \
https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz \
	&& tar xf \
phpMyAdmin-5.0.4-english.tar.gz --strip-components=1 -C /var/www/homepage/ \
	&& rm phpMyAdmin-5.0.4-english.tar.gz

COPY config.inc.php /var/www/homepage/
#We need the phpmyadmin config to say that the mysql server isn't on localhost
#(default) but on an other machine (mysql pod). So we give the name of the
#service (clusterip) which expose the pod internally in the cluster : I named it
#mysql-service. Minikube set up a kubernetes core DNS, this is why we can use
#the name of service instead of it's IP. (Then, no need to hardcode the service
#IP)
COPY setup.sh /
ENTRYPOINT ["/setup.sh"]
CMD ["nginx", "-g", "daemon off;"]
