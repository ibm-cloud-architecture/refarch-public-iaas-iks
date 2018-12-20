#################################################################################
# This terraform script executes the configuration/configure-ingress-resource.sh
# feeding it the terraform generated data and input variables to create the
# Ingress resource for the cluster.
#
# Note the configuration/template_bmx_ingress.yml needs to be
# updated with the services for the application
# that is to run in the cluster.
#################################################################################

resource "null_resource" "configure-ingress" {
  provisioner "local-exec" {
    command                   = <<EOT
../configuration/configure-ingress-resource.sh "${data.ibm_container_cluster_config.cluster_config.config_file_path}" \
"${ibm_container_cluster.kubecluster.name}" \
"${ibm_container_cluster.kubecluster.ingress_hostname}" \
"${ibm_container_cluster.kubecluster.ingress_secret}" \
"${var.env_name}-space" "${var.env_name}" \
EOT
  }
  depends_on   = ["ibm_container_cluster.kubecluster", "null_resource.configure-namespace"]
}
