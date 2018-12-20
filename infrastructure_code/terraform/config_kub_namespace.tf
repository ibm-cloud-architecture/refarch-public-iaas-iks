
##############################################################################
# This terraform script executes the configuration/configure-namespace.sh
# feeding it the terraform generated data and input variables
# to create and configure the kubernetes namespace .
#################################################################################

resource "null_resource" "configure-namespace" {
  provisioner "local-exec" {
    command                   = <<EOT
../configuration/configure-namespace.sh "${data.ibm_container_cluster_config.cluster_config.config_file_path}" "${var.env_name}-space" "${var.env_name}"
EOT
  }
  depends_on   = ["ibm_container_cluster.kubecluster"]
}
