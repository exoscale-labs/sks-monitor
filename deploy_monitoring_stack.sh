#!/bin/bash

#helm repo remove Prometheus-community

# Create the Kubernetes namespace
kubectl create namespace kubernetes-monitoring

# Add the Prometheus-community Helm repo
helm repo add Prometheus-community https://prometheus-community.github.io/helm-charts

# Update the Helm repo
helm repo update

# Install Prometheus Monitoring
helm install monitoring Prometheus-community/kube-prometheus-stack --namespace kubernetes-monitoring

#To expose
#kubectl port-forward prometheus-monitoring-kube-prometheus-prometheus-0 -n kubernetes-monitoring 9090
#kubectl edit svc monitoring-grafana -n kubernetes-monitoring

# Get Grafana admin username from the secret and decode it
grafana_user=$(kubectl get secret -n kubernetes-monitoring monitoring-grafana -o jsonpath='{.data.admin-user}' | base64 --decode)

# Get Grafana admin password from the secret and decode it
grafana_password=$(kubectl get secret -n kubernetes-monitoring monitoring-grafana -o jsonpath='{.data.admin-password}' | base64 --decode)

# Print the Grafana admin username
echo "Grafana Admin User: $grafana_user"

# Print the Grafana admin password
echo "Grafana Admin Password: $grafana_password"

