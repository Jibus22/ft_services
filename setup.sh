#!/bin/sh

#minikube is a sort of OS disk image who has to run thanks to a hypervisor.
#Driver option sets which one will run minikube. It could be docker, hyperkit,
#podman (linux), vmware...
#Tip : on macosx, external-ip delivered by metallb are working only with
#virtualbox driver.

minikube start --driver='virtualbox' --cpus=2 --memory=2048 --disk-size=20g --addons=metallb

#The command below sets the docker environnment of the host to minikube.
#All the docker commands on host will be relative to the docker deamon of
#minikube. It permits to build image in minikube from dockerfile on the host.

eval $(minikube docker-env)

#Building docker images
docker build -t my_nginx srcs/images/nginx/
docker build -t my_wp srcs/images/wordpress/
docker build -t my_pma srcs/images/phpmyadmin/
docker build -t my_mysql srcs/images/sql/

#Applying all kubernetes manifests from this folder
kubectl apply -f srcs/deployments/
