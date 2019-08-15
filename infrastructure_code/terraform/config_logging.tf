#################################################################################
# This terraform script executes the configuration/configure-logging.sh
# feeding it the terraform generated data and input variables to
# configure the log service for this cluster.
#################################################################################

######################################################
# configure the Log Services for this cluster
######################################################
resource "null_resource" "configure-logging" {
  provisioner "local-exec" {
    command                   = <<EOT
../configuration/configure-logging.sh "${data.ibm_container_cluster_config.cluster_config.config_file_path}" "logdna-agent-key" "${ibm_resource_key.logging_secret.credentials.ingestion_key}"
EOT
  }
  depends_on   = ["ibm_container_cluster.kubecluster"]
}
