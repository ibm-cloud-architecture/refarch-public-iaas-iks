#
# Creates the resource group that will be used by the remaining code and services
# The output of this block "ibm_resource_group.Kub_resourceGroup.id" will be used
# in place of variable "resource_group" current used by the infrastructure code.
# that would mean you change the reference to this variable from "var.resource_group"
# to, if you use "persistent_svcs" as the module "persistent_svcs.resource_group.id"
# this module would then require an input variable for kub_quota (defined in
# the documentation for the provider.

#
# Creates the resource group using the Resource quota provided
#
resource "ibm_resource_group" "Kub_resourceGroup" {
  name     = "prod"
  quota_id = "${var.kub_quota.id}"
}

#
# Only used when this is run in a module
#
output resource_group {
   value = "${ibm_resource_group.Kub_resourceGroup.id}"
}
