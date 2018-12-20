####################################################################################
# This is an example file.
# This Terraform file will provision an instance of the IBM Cloud Internet service
# and configure it with the domain.
####################################################################################

# Reference DNS registration
data "ibm_dns_domain_registration" "kube_domain" {
  name = "${var.domain}"
}

# Set DNS name servers for CIS
resource "ibm_dns_domain_registration_nameservers" "kub_domain" {
  name_servers        = ["${ibm_cis_domain.kube_domain.name_servers}"]
  dns_registration_id = "${data.ibm_dns_domain_registration.kube_domain.id}"
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
