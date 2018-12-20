################################################################################
# NOTE: All resources in this file use a count attribute that must be set
# to either 1 (create cloudant db) or 0 (do not create the cloudant db)
#
# This terraform script creates a Cloudant database and resource instance
# access key to the cloudant db instance, IF var.cloudant_create_instance
# is set to 1 (create cloudant).
#
# If the cloudant db instance is created, this terraform script will
# also execute configuration/create-cloudant-secret.sh, feeding it the
# terraform generated data and input variable to configure the kubernetes db
# binding secret for application access from the cluster's name space.
################################################################################

# Create the cloudant db instance
resource "ibm_resource_instance" "resourceInstance" {
  count      = "${var.cloudant_create_instance}"   # does not create resource if 0

  name       = "${var.cloudant_name}"
  service    = "cloudantnosqldb"
  plan       = "${var.cloudant_plan}"
  location   = "${var.ibm_region}"
  resource_group_id = "${data.ibm_resource_group.group.id}"
  tags       = ["${var.env_name}", "${var.cluster_name}"]

  // increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }

  depends_on  = ["ibm_container_cluster.kubecluster"]
}

# Create the db instance access key
resource "ibm_resource_key" "resourceKey" {
  count      = "${var.cloudant_create_instance}"   # does not create resource if 0

  name                 = "devopskey"
  role                 = "Manager"
  resource_instance_id = "${ibm_resource_instance.resourceInstance.id}"

  //Increase timeouts
  timeouts {
    create = "15m"
    delete = "15m"
  }

  depends_on  = ["ibm_resource_instance.resourceInstance"]
}

##############################################################################
# Execute the script to create db binding secret in the cluster's namespace
##############################################################################
resource "null_resource" "create-cloudant-secret" {
  count      = "${var.cloudant_create_instance}"   # does not create resource if 0

  provisioner "local-exec" {
    command                   = <<EOT
../configuration/create-cloudant-secret.sh "${data.ibm_container_cluster_config.cluster_config.config_file_path}" \
"${var.env_name}-space" "binding-rates-cloudant-cred1" "binding" \
"${ibm_resource_key.resourceKey.credentials.host}" \
"${ibm_resource_key.resourceKey.credentials.username}" \
"${ibm_resource_key.resourceKey.credentials.password}" \
"${ibm_resource_key.resourceKey.credentials.port}" \
"${ibm_resource_key.resourceKey.credentials.url}"
EOT
  }
  depends_on   = ["ibm_resource_key.resourceKey", "null_resource.configure-namespace"]
}
