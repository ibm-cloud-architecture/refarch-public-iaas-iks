######################################################################################
# This is an example file and has not yet been tested.
#
# This Terraform file will provision an instance of the IBM Cloud Internet service
# and configure it with the domain
# See the documentation for more information at:
#   IBM Terrform provider: https://ibm-cloud.github.io/tf-ibm-docs/v0.14.0/r/cis.html
#   CIS: https://cloud.ibm.com/docs/infrastructure/cis/getting-started.html#getting-started-with-ibm-cloud-internet-services-cis-
#######################################################################################

# Reference DNS registration
data "ibm_dns_domain_registration" "kube_domain" {
  name = "${var.domain}"
}

# Set DNS name servers for CIS
resource "ibm_dns_domain_registration_nameservers" "kub_domain" {
  dns_registration_id = "${data.ibm_dns_domain_registration.kube_domain.id}"
  name_servers        = ["${ibm_cis_domain.kube_domain.name_servers}"]
}

resource "ibm_cis" "kube_domain" {
  # lifecycle {  #   create_before_destroy = true  # }

  name              = "kube_domain"
  resource_group_id = "${persistent_svcs.resource_group.id}"
  plan              = "standard"
  location          = "global"
}

resource "ibm_cis_domain" "kube_domain" {
  cis_id = "${ibm_cis.kube_domain.id}"
  domain = "${var.domain}"
}
