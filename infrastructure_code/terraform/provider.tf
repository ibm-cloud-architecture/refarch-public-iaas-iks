
#####################################################################
# This terraform file defines the terraform provider that is used
# to deploy the architecture. In this case, the IBM Cloud provider is
# the only provider that will be used. The two variables provide the
# means to deploy workloads. However, the APIkey and IBMid must have
# the permissions to deploy this architecture's resources.
# For more information on the IBM Provider arguments
# see https://ibm-cloud.github.io/tf-ibm-docs/v0.13.0/
#####################################################################

provider "ibm" {
  bluemix_api_key    = "${var.paas_apikey}"
  region             = "${var.ibm_region}"
}
