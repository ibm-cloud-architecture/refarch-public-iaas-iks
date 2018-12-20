#################################################################################
# This terraform script executes the configuration/configure-monitoring.sh
# feeding it the terraform generated data and input variables to
# configure the monitoring service for this cluster.
#################################################################################

######################################################
# configure the Monitoring Services for this cluster
######################################################
resource "null_resource" "configure-monitoring" {
  provisioner "local-exec" {
    command                   = <<EOT
../configuration/configure-monitoring.sh "${data.ibm_container_cluster_config.cluster_config.config_file_path}" "${ibm_container_cluster.kubecluster.name}" "${var.sysdig_access_key}" "ingest.us-south.monitoring.cloud.ibm.com"
EOT
  }
  depends_on   = ["ibm_container_cluster.kubecluster"]
}
