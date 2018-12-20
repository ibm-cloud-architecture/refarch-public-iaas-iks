#!/bin/sh

####################################################################################
# This bash script creates the kube namespace and setups up the pull secret
# for the container registry for the namespace.
#
# See this section of the documentation for setting up Role Binding for the namespace
# to control namespace access
# https://cloud.ibm.com/docs/containers/cs_users.html#role-binding
#####################################################################################

KUBECONFIG=$1
NAMESPACE_NAME=$2
NAMESPACE_LABEL=$3

# Set the Kube context
export KUBECONFIG=${KUBECONFIG}

printf "\n\t${cyn}Creating the Kube namespace [${NAMESPACE_NAME}] for the cluster ${end}\n"

# Create the kubernetes namespace #
sed -e 's/NAMESPACE_NAME/'${NAMESPACE_NAME}'/; s/NAMESPACE_LABEL/'${NAMESPACE_LABEL}'/' < ../configuration/template_namespace.yml | kubectl create -f -

# Create pull image secret for the name sapce
kubectl get secret bluemix-default-secret -o yaml | sed 's/default/'${NAMESPACE_NAME}'/g' | kubectl -n ${NAMESPACE_NAME} create -f -

printf "\t${cyn}and storing the imagePullSecret in the Kubernetes service account [bluemix-${NAMESPACE_NAME}-secret] for the cluster ${end}\n"

## Store the imagePullSecret in the Kubernetes service account for the new namespace
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "bluemix-'${NAMESPACE_NAME}'-secret"}]}' --namespace=${NAMESPACE_NAME}

# Verify the service account is patched with the new namespace secret
kubectl describe serviceaccount default -n ${NAMESPACE_NAME}
