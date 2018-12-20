#####################################################################
# This Terraform file defines the variables used in this Terraform
# scripts for this repo.
#####################################################################

################################################
# IBM Cloud Provider vars
################################################
variable "paas_apikey" {}   # IBM Cloud API Credentials
variable "ibm_region" {}

################################################
# IBM Cloud account and resource group vars
################################################
variable "account_id" {}
variable "resource_group" {}

################################################
# Monitoring and Logging variables
################################################
variable "logdna_ingestion_key" {}
variable "sysdig_access_key"    {}

################################################
# Environment
################################################
variable "env_name" {}

#################################################
# Container Cluster variables for main AZ (zone1)
#################################################
variable "cluster_name"    {}
variable "kube_version"    {}
variable "num_workers"     {}    # number of workers per zone
variable "is_ha_multizone" {}    # 0=single zone, 1=multizone

variable "machine_type" {}
variable "hardware" {}

variable "zone1" {}
variable "zone1_public_vlan_id" {}
variable "zone1_private_vlan_id" {}

################################################
# Container Cluster variables for Second AZ
################################################
variable "zone2" {}
variable "zone2_public_vlan_id" {}
variable "zone2_private_vlan_id" {}


################################################
# Container Cluster variables for Third AZ
################################################
variable "zone3" {}
variable "zone3_public_vlan_id" {}
variable "zone3_private_vlan_id" {}


##############################################################
# Cloudant Variables
##############################################################
variable "cloudant_create_instance" {}  # 0=do not create db, 1=create db
variable "cloudant_name"            {}
variable "cloudant_plan"            {}

#######################################################
# Public Net allowed to communicate to Ingress Cluster
# IP address only, no CIDRs
#######################################################
variable "devops_ip"   {}
variable "glb_ip"      {}
