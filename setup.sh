#!/bin/bash

#minikube is a sort of OS disk image who has to run thanks to a hypervisor.
#Driver option sets which one will run minikube. It could be docker, hyperkit,
#podman (linux), vmware...
#Tip : on macosx, external-ip delivered by metallb are working only with
#virtualbox driver.

#Safety clean up
minikube delete

#Configuration depends on OS type. Mostly about the minikube driver & its associated ip

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	echo $'\n\t###### you\'re using linux ######\n'
	#Add user account 'user42' to group 'docker'. It permits to use docker in the 42 VM
	#sudo usermod -aG docker user42
	newgrp docker
	minikube start --driver='docker' --cpus=3 --memory=4096 
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/metallb.yaml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	sed -i.bak "s/"192.168.99.100"/"172.17.0.10"/g" $(grep -lr "192.168.99.100" srcs/*)
elif [[ "$OSTYPE" == "darwin"* ]]; then
	echo $'\n\t###### you\'re using mac osx ######\n'
	minikube start --driver='virtualbox' --cpus=4 --memory=4096 --disk-size=20g --addons=metallb
	sed -i.bak "s/172.17.0.10/192.168.99.100/g" $(grep -lr "172.17.0.10" srcs/*)
else
	echo "pouet";
fi

kubectl apply -f srcs/manifests/metallb-configmap.yaml

#The command below sets the docker environnment of the host to minikube.
#All the docker commands on host will be relative to the docker deamon of
#minikube. It permits to build image in minikube from dockerfile on the host.

eval $(minikube docker-env)

#Building docker images
docker build -t my_nginx srcs/images/nginx/
docker build -t my_wp srcs/images/wordpress/
docker build -t my_pma srcs/images/phpmyadmin/
docker build -t my_mysql srcs/images/sql/
docker build -t my_ftps srcs/images/ftps/
docker build -t my_grafana srcs/images/grafana/
docker build -t my_influxdb srcs/images/influxdb/

#Applying all kubernetes manifests from this folder
kubectl apply -f srcs/manifests/influxdb-deployment.yaml
kubectl apply -f srcs/manifests/mysql-deployment.yaml
kubectl apply -f srcs/manifests/pma-deployment.yaml
kubectl apply -f srcs/manifests/wp-deployment.yaml
kubectl apply -f srcs/manifests/ftps-deployment.yaml
kubectl apply -f srcs/manifests/nginx-deployment.yaml
kubectl apply -f srcs/manifests/grafana-deployment.yaml


echo "\tPODS" && kubectl get po -o wide && echo "---\n\n\tDEPLOYMENTS" && kubectl get deploy -o wide && echo "---\n\n\tSERVICES" && kubectl get svc -o wide

minikube dashboard
