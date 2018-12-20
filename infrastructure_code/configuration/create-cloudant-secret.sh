#!/bin/sh

####################################################################################
# This bash script creates the cloudant instance secret in the namespace with the
# service key created at provision time.
#####################################################################################

KUBECONFIG=$1
NAMESPACE_NAME=$2
SECRET_NAME=$3
KEY_NAME=$4
CLOUDANT_SERVICEKEY_HOST=$5
CLOUDANT_SERVICEKEY_UNAME=$6
CLOUDANT_SERVICEKEY_PWD=$7
CLOUDANT_SERVICEKEY_PORT=$8
CLOUDANT_SERVICEKEY_URL=$9

CLOUDANT_SERVICEKEY="{
\""username"\": \""${CLOUDANT_SERVICEKEY_UNAME}"\",
\""password"\": \""${CLOUDANT_SERVICEKEY_PWD}"\",
\""host"\": \""${CLOUDANT_SERVICEKEY_HOST}"\",
\""port"\": "${CLOUDANT_SERVICEKEY_PORT}",
\""url"\": \""${CLOUDANT_SERVICEKEY_URL}"\"
}"

# Set the Kube context
export KUBECONFIG=${KUBECONFIG}

printf "\n\t${cyn}Creating the Kube Secret [${SECRET_NAME}] for the cluster with the service key: [${CLOUDANT_SERVICEKEY_HOST}] ${end}\n"

# Create Cloudant kube secret
kubectl create secret generic ${SECRET_NAME} --from-literal=${KEY_NAME}="${CLOUDANT_SERVICEKEY}" --namespace=${NAMESPACE_NAME}
