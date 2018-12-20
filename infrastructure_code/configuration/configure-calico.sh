#!/bin/bash

####################################################################################
# This bash script configures the Calico Public and Private Network Policies.
# Dependencies - it assumes that the privatehostendpoint.yaml has been generated.
#                with the work node private ip addresses for the cluster.
#
#
#####################################################################################


# Order of arguments passed in
KUBECONFIG=$1
CLUSTER_NAME=$2
INGRESS_HOSTNAME=$3
GLB_IP=$4
DEVOPS_IP=$5

# Set the Kube context
export KUBECONFIG=${KUBECONFIG}

# Set up the Calico configuration file location
CERTS=$(dirname ${KUBECONFIG})
CALICOCONFIGFILE="${CERTS}/calicoctl.cfg"

if [ ! -d "/etc/calico" ]; then
  mkdir -p /etc/calico/
fi
cp -f ${CALICOCONFIGFILE} /etc/calico/.

cat $CALICOCONFIGFILE

###############################################################################
# Generate the yaml files (deny-ingress.yaml and allow-src-ip.yaml)
# by replacing the tokens with the Ingress IP addresses in the template files:
#   ../calico/public/template_allow-src-ip.yaml
#   ../calico/public/template_deny-ingress.yaml
###############################################################################
# Get the IP addresses
# For the alpine based Container, we must use getent ahosts
# Notes: The IPs can also be retreived by using the ibmcloud ks albs --cluster <cluster name> | grep public | awk '{print $5}'
#        however in this implementation, we are not configured to use ibmcloud commands.
cp -f ../calico/public/template_deny-ingress.yaml ../calico/public/deny-ingress.yaml
cp -f ../calico/public/template_allow-src-ip.yaml ../calico/public/allow-src-ip.yaml
declare INGRESS_IPS=()
count=0
getent ahosts ${INGRESS_HOSTNAME} | grep STREAM > ../configuration/hosts.${INGRESS_HOSTNAME}
# host ${INGRESS_HOSTNAME} > ../configuration/hosts.${INGRESS_HOSTNAME}
while read line ; do
    ipaddress=$(echo $line | awk '{print $1}')  # for gentent ahosts
#   ipaddress=$(echo $line | awk '{print $4}')  # for hosta
    INGRESS_IPS[$count]="$ipaddress"
    # Replace the Ingress Tokens in the two files
    sed "s/# - INGRESS_IP_$count/- ${INGRESS_IPS[$count]}/" ../calico/public/deny-ingress.yaml > ../configuration/tmp-deny-ingress.yaml
    cp ../configuration/tmp-deny-ingress.yaml ../calico/public/deny-ingress.yaml
    sed "s/# - INGRESS_IP_$count/- ${INGRESS_IPS[$count]}/" ../calico/public/allow-src-ip.yaml > ../configuration/tmp-allow-src-ip.yaml
    cp ../configuration/tmp-allow-src-ip.yaml ../calico/public/allow-src-ip.yaml
    count=$((count+1))
done < ../configuration/hosts.${INGRESS_HOSTNAME}

# Update the allow-src-ip.ymal policy with the e DevOps Deploy tool and GLB IP to access the Ingress C ontroller.
echo "  "
echo "  "
echo "Set Calico policy to allow DevOps IP:[${DEVOPS_IP}] and GLB IP:[${GLB_IP}] access to [${CLUSTER_NAME}] Ingress alb"
sed  "s/- DEVOPS_IP/- ${DEVOPS_IP}/; s/- GLB_IP/- ${GLB_IP}/" ../calico/public/allow-src-ip.yaml > ../configuration/tmp-allow-src-ip.yaml
cp ../configuration/tmp-allow-src-ip.yaml ../calico/public/allow-src-ip.yaml

rm ../configuration/tmp-allow-src-ip.yaml
rm ../configuration/tmp-deny-ingress.yaml

#########################################################################################################################
# Note that the default calico policies are in place when the cluster is created.
# Apply the calico policies for public and private networks on the cluster worker nodes.
# This policy applies rules from https://cloud.ibm.com/docs/containers/cs_firewall.html#firewall_outbound (Step #5)
# The default policies are described at https://cloud.ibm.com/docs/containers/cs_network_policy.html#default_policy
#########################################################################################################################

printf "\n\t${cyn}Applying private net host endpoint terraform generated from template Calico Policy for  ${CLUSTER_NAME} ${end}"
calicoctl apply -f ../calico/private/privatehostendpoint.yaml           --config=${CALICOCONFIGFILE}  # this file is rendered from a template (template_privatehostendpoint.yaml) in postpprovision.tf

printf "\n\t${cyn}Applying the public net worker node level Calico Policies ${CLUSTER_NAME} ${end}"
calicoctl apply -f ../calico/public/allow-src-ip.yaml                   --config=${CALICOCONFIGFILE}  # this file is rendered from a template (template_allow-src-ip.yaml)
calicoctl apply -f ../calico/public/deny-ingress.yaml                   --config=${CALICOCONFIGFILE}  # this file is rendered from a template (template_allow-deny-ingress.yaml)
calicoctl apply -f ../calico/public/deny-kube-node-port-services.yaml   --config=${CALICOCONFIGFILE}

printf "\n\t${cyn}Applying the private net worker node level Calico Policies for ${CLUSTER_NAME} ${end}"
calicoctl apply -f ../calico/private/allow-all-workers-private.yaml     --config=${CALICOCONFIGFILE}
calicoctl apply -f ../calico/private/allow-ibm-ports-private.yaml       --config=${CALICOCONFIGFILE}
calicoctl apply -f ../calico/private/allow-icmp-private.yaml            --config=${CALICOCONFIGFILE}
calicoctl apply -f ../calico/private/allow-vrrp-private.yaml            --config=${CALICOCONFIGFILE}

printf "\n\t${cyn}Applying the private net POD level calico policies for ${CLUSTER_NAME} ${end}"
calicoctl apply -f ../calico/private/allow-egress-pods.yaml             --config=${CALICOCONFIGFILE}
