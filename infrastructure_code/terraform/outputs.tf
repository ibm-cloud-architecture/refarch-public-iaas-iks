#####################################################################
# If this example was extended to use Terraform Modules, this file
# defines output variables that would be used by modules as input
# to execute the provisioning and post provisioning configuration. 
#####################################################################

output kubecluster_name {
  value = "${ibm_container_cluster.kubecluster.name}"
}
output ingress_hostname {
   value = "${ibm_container_cluster.kubecluster.ingress_hostname}"
}
output worker_count {
   value = "${data.ibm_container_cluster.cluster_env.worker_count}"
}
output kubeconfig {
   value = "${data.ibm_container_cluster_config.cluster_config.config_file_path}"
}

output ibmcld_resource_group {
   value = "${var.resource_group}"
}
output ibmcld_account {
   value = "${var.account_id}"
}

output cloudant_resource_name {
  value =  "${var.cloudant_name}"
}
output cloudant_devopskey_credentials{
  value =  "${ibm_resource_key.resourceKey.*.credentials}"
}
output cloudant_resource_id {
  value =  "${ibm_resource_instance.resourceInstance.*.id}"
}
