#####################################################################################
# This file is where you place the input values to run the automation.
# You can replace the tokens @XXX@ with your input values.
#####################################################################################

################################################
# IBM Cloud provider vars
################################################
ibm_region = "@TF_REGION@"

################################################
# IBM Cloud account and resource group vars
################################################
account_id  = "@TF_ACCOUNT_ID@"
resource_group = "@TF_RESOURCE_GROUP@"

################################################
# Monitoring and Logging variables
################################################
logdna_ingestion_key = "@TF_LOGDNA_INGEST_KEY@"
sysdig_access_key    = "@TF_SYSDIG_ACCESS_KEY@"

################################################
# Environment Name - used in the Kube Namespace
################################################
env_name = "@TF_ENV_NAME@"

################################################
# Container Cluster variables for main AZ
################################################
cluster_name    = "@TF_CLUSTER_NAME@"
kube_version    = "@TF_KUBE_VERSION@"
num_workers     = "@TF_NUM_WORKERS@"       # number of nodes per zone
is_ha_multizone = "@IS_MULTI_ZONE@"        # 0=single zone, 1=multizone

machine_type    = "@TF_MACHINE_TYPE@"
hardware        = "@TF_HARDWARE@"

zone1 = "@TF_ZONE1_NAME@"
zone1_public_vlan_id  = "@TF_ZONE1_PUBLIC_VLAN_ID@"
zone1_private_vlan_id = "@TF_ZONE1_PRIVATE_VLAN_ID@"

################################################
# Container Cluster variables for Second AZ
################################################
zone2 = "@TF_ZONE2_NAME@"
zone2_public_vlan_id  = "@TF_ZONE2_PUBLIC_VLAN_ID@"
zone2_private_vlan_id = "@TF_ZONE2_PRIVATE_VLAN_ID@"

################################################
# Container Cluster variables for Third AZ
################################################
zone3 = "@TF_ZONE3_NAME@"
zone3_public_vlan_id  = "@TF_ZONE3_PUBLIC_VLAN_ID@"
zone3_private_vlan_id = "@TF_ZONE3_PRIVATE_VLAND_ID@"

################################################
# Cloudant variables
################################################
cloudant_create_instance = "@TF_CREATE_CLOUDANT@"      # 0=do not create db, 1=create db
cloudant_name = "@TF_CLOUDANT_NAME@"
cloudant_plan = "@TF_CLOUDANT_PLAN@"

#######################################################
# Public Net allowed to communicate to Ingress Cluster
#######################################################
devops_ip   = "@TF_DEVOPS_IP@"
glb_ip      = "@TF_GLB@"