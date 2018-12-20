#!/bin/sh

###################################################################################
# This bash script configures the monitoring service for the cluster.
#
# Assumes that an IBM Cloud Monitoring with Sysdig instance has been provisioned
# User ID/Service ID must have assigned IAM policies:
#  - Resource Group:Viewer
#  - IBM Cloud Monitoring with Sysdig Service:Editor
#  - IBM Kubernetes Instance:Editor
#
# NOTE:  The current service only supports us-south
#
# Reference - Configure IKS Cluster with IBM Cloud Monitoring with Sysdig
# https://console.bluemix.net/docs/services/Monitoring-with-Sysdig/tutorials/kubernetes_cluster.html#kubernetes_cluster
###################################################################################

# Order of arguments passed in
KUBECONFIG=$1
CLUSTER_NAME=$2
SYSDIG_ACCESS_KEY=$3
MON_COLLECTOR_ENDPOINT=$4

TAG_DATA="cluster:${CLUSTER_NAME}"

# Set the Kube context
export KUBECONFIG=${KUBECONFIG}

# Deploy the Sysdig agent to the cluster nodes as a Daemonset
curl -sL https://raw.githubusercontent.com/draios/sysdig-cloud-scripts/master/agent_deploy/IBMCloud-Kubernetes-Service/install-agent-k8s.sh | bash -s -- -a ${SYSDIG_ACCESS_KEY} -c ${MON_COLLECTOR_ENDPOINT} -t ${TAG_DATA} -ac 'sysdig_capture_enabled: false'
