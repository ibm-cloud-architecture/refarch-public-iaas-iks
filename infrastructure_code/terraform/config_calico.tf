####################################################################################
# This terraform script executes the configuration/configure-calico.sh
# feeding it the terraform generated data and input variables to
# configure the Calico Public and Private Network Policies.
#
# Also, this terraform scripts creates the private network policy
# calico/private/privatehostendpoint.yaml file that is used by
# configuration/configure-calico.sh to configure the Calico Private Network policies.
#####################################################################################

########################################################################
# Create the private network hostendpoint yaml file.
#   1. Setup the Terraform Template for the hostendpoint yaml file
#   2. Render the privatehostendpoint.yaml using the terraform template
#   3. configure-calico.sh will apply the privatehostendpoint.yaml file
########################################################################
# Setup the Terraform Template
data "template_file" "data_json" {
  template = "${file("../calico/private/template_privatehostendpoint.yaml")}"
  count    = "${length(ibm_container_cluster.kubecluster.workers_info)}"

  vars {
    id         = "${element(data.ibm_container_cluster.cluster_env.workers,count.index)}"
    private_ip = "${element(data.ibm_container_cluster_worker.cluster_worker.*.private_ip,count.index)}"
  }
  depends_on = ["ibm_container_cluster.kubecluster"]
  # This assumes that the "ibm_container_worker_pool_zone_attachment.worker_zone2" and "ibm_container_worker_pool_zone_attachment.worker_zone3" have been created first
}

# Render the privatehostendpoint.yaml using the terraform template
resource "null_resource" "render-hostendpoints" {
  provisioner "local-exec" {
     command = "rm -rf ../calico/private/privatehostendpoint.yaml;echo \"${join("\n", data.template_file.data_json.*.rendered)}\" >> ../calico/private/privatehostendpoint.yaml"
  }
  depends_on = ["ibm_container_cluster.kubecluster"]
}

######################################################
# Apply the Calico Policies
######################################################
resource "null_resource" "configure-calico" {
  provisioner "local-exec" {
    command                   = <<EOT
../configuration/configure-calico.sh "${data.ibm_container_cluster_config.cluster_config.config_file_path}" "${ibm_container_cluster.kubecluster.name}" "${ibm_container_cluster.kubecluster.ingress_hostname}" "${var.glb_ip}" "${var.devops_ip}"
EOT
  }
  depends_on   = ["ibm_container_cluster.kubecluster","null_resource.render-hostendpoints"]
}
