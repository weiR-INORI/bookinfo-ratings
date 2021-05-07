#!/bin/sh
kubectl delete namespace student3-bookinfo-dev
kubectl delete namespace student3-bookinfo-uat
kubectl delete namespace student3-bookinfo-prd
gcloud container clusters get-credentials k8s --project zcloud-cicd --zone asia-southeast1-a
kubectl create namespace student3-bookinfo-dev
kubectl create namespace student3-bookinfo-uat
kubectl create namespace student3-bookinfo-prd
kubectl config set-context $(kubectl config current-context) --namespace=student3-bookinfo-uat
kubectl create secret generic registry-bookinfo --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl create configmap bookinfo-uat-ratings-mongodb-initdb --from-file=databases/ratings_data.json --from-file=databases/script.sh
helm install -f k8s/helm-values/values-bookinfo-uat-ratings-mongodb.yaml bookinfo-uat-ratings-mongodb bitnami/mongodb
helm install -f k8s/helm-values/values-bookinfo-uat-ratings.yaml bookinfo-uat-ratings k8s/helm
kubectl config set-context $(kubectl config current-context) --namespace=student3-bookinfo-prd
kubectl create secret generic registry-bookinfo --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl create configmap bookinfo-prd-ratings-mongodb-initdb --from-file=databases/ratings_data.json --from-file=databases/script.sh
helm install -f k8s/helm-values/values-bookinfo-prd-ratings-mongodb.yaml bookinfo-prd-ratings-mongodb bitnami/mongodb
helm install -f k8s/helm-values/values-bookinfo-prd-ratings.yaml bookinfo-prd-ratings k8s/helm
kubectl config set-context $(kubectl config current-context) --namespace=student3-bookinfo-dev
kubectl create secret generic registry-bookinfo --from-file=.dockerconfigjson=$HOME/.docker/config.json --type=kubernetes.io/dockerconfigjson
kubectl create configmap bookinfo-dev-ratings-mongodb-initdb --from-file=databases/ratings_data.json --from-file=databases/script.sh
helm install -f k8s/helm-values/values-bookinfo-dev-ratings-mongodb.yaml bookinfo-dev-ratings-mongodb bitnami/mongodb
helm install -f k8s/helm-values/values-bookinfo-dev-ratings.yaml bookinfo-dev-ratings k8s/helm