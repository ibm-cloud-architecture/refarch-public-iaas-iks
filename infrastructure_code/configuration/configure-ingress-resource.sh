#!/bin/sh

###################################################################################
# This bash script creates the Ingress Resource using the template_bmx_ingress.yml
# as the template. 
#
# Note the configuration/template_bmx_ingress.yml needs to be updated with the
# services for the application that is to run in the cluster.
###################################################################################

# Order of arguments passed in
KUBECONFIG=$1
CLUSTER_NAME=$2
ENV_INGRESS_HOSTNAME=$3
INGRESS_SECRET=$4
NAMESPACE_NAME=$5
NAMESPACE_LABEL=$6

# Set the Kube context
export KUBECONFIG=${KUBECONFIG}


## Create the ingress resource ##
# Set up the public ingress resource
sed  -e 's/INGRESS_HOSTNAME/'${ENV_INGRESS_HOSTNAME}'/; s/INGRESS_RESOURCE_NAME/'${NAMESPACE_LABEL}-ingress'/; s/INGRESS_SECRET/'${INGRESS_SECRET}'/' < ../configuration/template_bmx_ingress.yml | kubectl apply -f - --namespace=${NAMESPACE_NAME}
