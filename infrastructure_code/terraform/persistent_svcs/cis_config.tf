####################################################################################
# This is an example file.
# This Terraform file will configures the instance of the IBM Cloud
# Internet service with the primary and dr clusters endpoints.
# In this example, the second cluster is a dr module
####################################################################################

resource "ibm_cis_healthcheck" "swagger_api" {
  cis_id         = "${ibm_cis.kube_domain.id}"
  description    = "Swagger API"
  expected_body  = ""
  expected_codes = "200"
  path           = "/"
}

resource "ibm_cis_origin_pool" "primary" {
  cis_id        = "${ibm_cis.kube_domain.id}"
  name          = "${var.region}"
  check_regions = ["XXX"]

  monitor = "${ibm_cis_healthcheck.swagger_api.id}"

  origins = [{
    name    = "${ibm_container_cluster.kubecluster.name}"
    address = "${ibm_container_cluster.kubecluster.ingress_hostname}"
    enabled = true
  }]

  description = "primary cluster pool"
}

resource "ibm_cis_origin_pool" "dr" {
  cis_id        = "${ibm_cis.kube_domain.id}"
  name          = "${dr_module.region}"
  check_regions = ["WEU"]

  monitor = "${ibm_cis_healthcheck.swagger_api.id}"

  origins = [{
    name    = "${dr_module.kubecluster.name}"
    address = "${dr_module.kubecluster.ingress_hostname}"
    enabled = true
  }]

  description = "dr cluster pool"
}

# GLB name - name advertised by DNS for the website: prefix + domain
resource "ibm_cis_global_load_balancer" "kube_domain" {
  cis_id           = "${ibm_cis.kube_domain.id}"
  domain_id        = "${ibm_cis_domain.kube_domain.id}"
  name             = "${var.dns_name}${var.domain}"
  fallback_pool_id = "${ibm_cis_origin_pool.dr.id}"
  default_pool_ids = ["${ibm_cis_origin_pool.primary.id}"]
  description      = "Load balancer"
  proxied          = true
  session_affinity = "cookie"
}
