FROM alpine:3.12
#GRAFANA

#I do this tricky trick because unlike v3.12, v.3.13 contains grafana package &
#alpine:v3.13 doesn't works yet into minikube (DNS lookup error). Here I update
#alpine package list to have the new grafana package, with system installation
#included <3.
#This permits also to access a new package : telegraf. No wget anymore
RUN echo $'https://dl-cdn.alpinelinux.org/alpine/v3.13/main\n\
https://dl-cdn.alpinelinux.org/alpine/v3.13/community' > etc/apk/repositories

RUN apk update && apk add telegraf 
COPY telegraf.conf /etc/telegraf.conf


RUN apk update && apk add grafana 

COPY datasource.yaml /var/lib/grafana/provisioning/datasources/
COPY dashboards /var/lib/grafana/provisioning/dashboards

#grafana.ini is mounted by a k8s configmap

COPY setup.sh /
ENTRYPOINT ["/setup.sh"]
CMD ["grafana-server", "-config", "/etc/grafana/grafana.ini", "-homepath", "/usr/share/grafana/"]
#grafana-server needs the location of the application files also, with
#-homepath option
