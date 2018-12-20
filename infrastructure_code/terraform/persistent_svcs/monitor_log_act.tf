#this tf will provision an instance of each service

#Monitoring

resource "ibm_resource_instance" "monitoring" {
  name              = "kub_monitor"
  service           = "sysdig-monitor"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${var.resource_group.id}"
  tags              = ["tag1", "tag2"]

  parameters = {
    "HMAC" = true
  }
  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

# LogDNA

resource "ibm_resource_instance" "logging" {
  name              = "kub_logging"
  service           = "logdna"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${var.resource_group.id}"
  tags              = ["tag1", "tag2"]

  parameters = {
    "HMAC" = true
  }
  //User can increase timeouts 
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}
