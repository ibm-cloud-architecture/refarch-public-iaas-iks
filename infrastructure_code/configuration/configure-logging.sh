#!/bin/sh

###################################################################################
# This bash script configures the logging service for the cluster.
#
# Assumes that an IBM Log Analysis with LogDNA instance has been provisioned
# User ID/Service ID must have assigned IAM policies:
#  - Resource Group:Viewer
#  - IBM Log Analysis with LogDNA Service:Editor
#  - IBM Kubernetes Instance:Editor
#
# NOTE:  The current service only supports us-south
#
# Reference - Configure IKS Cluster with Log Analysis with DNA arguments
# https://console.bluemix.net/docs/services/Log-Analysis-with-LogDNA/tutorials/kube.html#step2
###################################################################################

# Order of arguments passed in
KUBECONFIG=$1
SECRET_NAME=$2
LOGDNA_INGESTION_KEY=$3

# Set the Kube context
export KUBECONFIG=${KUBECONFIG}

# Create a Kubernetes secret to store your logDNA ingestion key for your service instance.
kubectl create secret generic ${SECRET_NAME} --from-literal=logdna-agent-key=${LOGDNA_INGESTION_KEY}

# Create a Kubernetes daemon set to deploy the LogDNA agent on every worker node of your Kubernetes cluster.
kubectl create -f https://repo.logdna.com/ibm/prod/logdna-agent-ds-us-south.yaml
