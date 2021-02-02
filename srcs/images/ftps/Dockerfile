FROM alpine:3.12
#FTPS
RUN echo $'https://dl-cdn.alpinelinux.org/alpine/v3.13/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.13/community' > etc/apk/repositories

RUN apk update && apk add telegraf
COPY telegraf.conf /etc/telegraf.conf

RUN apk update \
	&& apk add \
	vsftpd \
	openssl

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 -subj "/C=FR/ST=France/L=Paris/O=42/CN=127.0.0.1" \
	-keyout /etc/ssl/private/vsftpd.key \
	-out /etc/ssl/certs/vsftpd.crt

#-subj -> C= Country, ST= State, L= Locality Name, O= Organization Name,
#CN= Common Name (e.g., server FQDN) (fully-qualified domain name)
#https://www.digicert.com/kb/ssl-support/openssl-quick-reference-guide.htm


#Adding user and setting it a password, to use at ftp connection.
#It creates in the file system the 'admin' folder at /home/admin
RUN adduser admin -D \
	&& echo -e "admin\nadmin" | passwd admin \
	&& echo "TESTING FTP HERE" > /home/admin/ftptest.txt

#vsftpd.conf is mounted from a k8s configmap

COPY setup.sh /
ENTRYPOINT ["/setup.sh"]
