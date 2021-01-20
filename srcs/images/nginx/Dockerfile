FROM alpine:3.12
#NGINX
COPY index.html /var/www/homepage/

RUN apk update && apk add nginx \
	openssl \
	&& mkdir /run/nginx \
	&& openssl req -x509 -out /root/localhost.crt -keyout /root/localhost.key \
	-newkey rsa:2048 -nodes -sha256 \
	-subj '/CN=localhost'

CMD ["nginx", "-g", "daemon off;"]
#daemon off option is used to run nginx in the foreground, in order to keep
#the docker container alive. (nginx is ran as a main process & not as a daemon)
