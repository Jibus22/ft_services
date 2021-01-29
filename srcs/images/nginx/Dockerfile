FROM alpine:3.12
#NGINX
RUN echo $'https://dl-cdn.alpinelinux.org/alpine/v3.13/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.13/community' > etc/apk/repositories

RUN apk update && apk add telegraf
COPY telegraf.conf /etc/telegraf.conf

COPY index.html /var/www/homepage/

RUN apk update && apk add nginx \
	openssl \
	&& mkdir /run/nginx \
	&& openssl req -x509 -out /root/localhost.crt -keyout /root/localhost.key \
	-newkey rsa:2048 -nodes -sha256 \
	-subj '/CN=localhost'

#The nginx virtual server configuration file is mounted from a k8s configmap

COPY setup.sh /
ENTRYPOINT ["/setup.sh"]
CMD ["nginx", "-g", "daemon off;"]
#daemon off option is used to run nginx in the foreground, in order to keep
#the docker container alive. (nginx is ran as a main process & not as a daemon)
