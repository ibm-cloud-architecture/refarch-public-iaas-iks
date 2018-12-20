##########################################################################################################################
# This terraform file defines the resources for IBM Kubernetes Service (IKS) clusters.
# For more information on IKS, see https://console.bluemix.net/docs/containers/container_index.html#container_index
# For more information on the Terraform Provider resource for creating the clusters
# see https://ibm-cloud.github.io/tf-ibm-docs/v0.13.0/r/container_cluster.html
#------------------------------------------------------------------------------------------------
# This file creates the "single zone" cluster in the resource group defined by ${var.resource_group}
# It can be used when a multi-zone cluster is not desired, If a multi-zone is desired,
# then set ${var.is_ha_multizone} to '1' and two additional zones will be created by the resources
# in iks_multizone.tf and added to the default worker pool.
##########################################################################################################################

#################################
#  Get the Resource Group ID
##################################
data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

#######################################################
#  Create the kubernetes cluster resource in zone 1.
########################################################
resource "ibm_container_cluster" "kubecluster" {
  name              = "${var.cluster_name}"
  kube_version      = "${var.kube_version}"
  account_guid      = "${var.account_id}"
  resource_group_id = "${data.ibm_resource_group.group.id}"

  default_pool_size = "${var.num_workers}"
  machine_type      = "${var.machine_type}"
  hardware          = "${var.hardware}"

  datacenter        = "${var.zone1}"
  public_vlan_id    = "${var.zone1_public_vlan_id}"
  private_vlan_id   = "${var.zone1_private_vlan_id}"
}

################################################################################
#  Cluster attribute to download the kubernetes config and calico config files.
#  The configuration scripts required these config files to execute the kubectl
#  and calicoctl commands.
################################################################################
data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = "${ibm_container_cluster.kubecluster.id}"
  account_guid      = "${var.account_id}"
  resource_group_id = "${data.ibm_resource_group.group.id}"

  # Required for getting the calico configuration
  admin           = "true"
  network         = "true"
  config_dir      = "/tmp"
}

#################################################################################
#  Cluster attributes required in config_calico.tf to render the
#  privatehostendpoint.yaml that is used in ../configuration/configure-calico.sh
#################################################################################
data "ibm_container_cluster" "cluster_env" {
  cluster_name_id   = "${ibm_container_cluster.kubecluster.id}"
  account_guid      = "${var.account_id}"
  resource_group_id = "${data.ibm_resource_group.group.id}"

  depends_on = ["ibm_container_cluster.kubecluster"]
}

data "ibm_container_cluster_worker" "cluster_worker" {
  count             = "${length(ibm_container_cluster.kubecluster.workers_info)}"
  worker_id         = "${lookup(ibm_container_cluster.kubecluster.workers_info[count.index],"id")}"
  account_guid      = "${var.account_id}"
  resource_group_id = "${data.ibm_resource_group.group.id}"

  depends_on = ["ibm_container_cluster.kubecluster"]
}
