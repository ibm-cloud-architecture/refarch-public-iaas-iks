#####################################################################################
# This file has the additional resources to make the cluster a multi-zone cluster
# to support an HA (High Availability) Environments.
# The resources in this file use a count attribute that must be set
# to either 1 (create multizone) or 0 (single zone)
#####################################################################################

###################################################################
#  Create the Zone 2 workers and attach to the default worker pool
###################################################################
resource ibm_container_worker_pool_zone_attachment worker_zone2 {
  count             = "${var.is_ha_multizone}"   # does not create resource if 0

  cluster           = "${ibm_container_cluster.kubecluster.id}"
  resource_group_id = "${data.ibm_resource_group.group.id}"
  worker_pool       = "default"

  zone              = "${var.zone2}"
  public_vlan_id    = "${var.zone2_public_vlan_id}"
  private_vlan_id   = "${var.zone2_private_vlan_id}"

  depends_on = ["ibm_container_cluster.kubecluster"]
}

###################################################################
#  Create the Zone 3 workers and attach to the default worker pool
###################################################################
resource ibm_container_worker_pool_zone_attachment worker_zone3 {
  count             = "${var.is_ha_multizone}"   # does not create resource if 0

  cluster           = "${ibm_container_cluster.kubecluster.id}"
  resource_group_id = "${data.ibm_resource_group.group.id}"
  worker_pool       = "default"

  zone              = "${var.zone3}"
  public_vlan_id    = "${var.zone3_public_vlan_id}"
  private_vlan_id   = "${var.zone3_private_vlan_id}"

  depends_on = ["ibm_container_cluster.kubecluster"]
}
