FROM alpine:3.12
#INFLUXDB

#with v3.13 : last influxdb version
RUN echo $'https://dl-cdn.alpinelinux.org/alpine/v3.13/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.13/community' > etc/apk/repositories

RUN apk update && apk add telegraf
COPY telegraf.conf /etc/telegraf.conf

RUN apk update && apk add influxdb
COPY influxdb.conf /etc/influxdb.conf

COPY setup.sh /
ENTRYPOINT ["/setup.sh"]
