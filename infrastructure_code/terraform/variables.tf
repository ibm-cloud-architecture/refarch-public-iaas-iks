################################################################################################
# This Terraform file defines the variables used in this Terraform
# scripts for this repo.
#
# A Note about API Keys and Access Keys (i.e. paas_apikey, logdna_ingestion_key,
# and sysdig_access_key). For security reasons, the values for these variables should never
# put into GitHub Repo, (i.e terraform.tfvars).  These types of variables values can be hidden
# with DevOps tools such as Jenkins and UrbanCode Deploy.   At provisioning time the values
# can be set in the Terraform run time container as environment variables, using the environment
# variable feature of Terraform (for example for the paas_apikey, see ../Dockerfile line # 8).
#################################################################################################


################################################
# IBM Cloud Provider vars
################################################
variable "ibm_bmx_api_key" {} # IBM Cloud API Credentials
variable "ibm_sl_username" {}
variable "ibm_sl_api_key" {}
variable "ibm_region" {}

################################################
# IBM Cloud account and resource group vars
################################################
variable "account_id" {}
variable "resource_group" {}

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
