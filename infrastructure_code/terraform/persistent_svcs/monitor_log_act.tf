#this tf will provision an instance of each service

#Monitoring

resource "ibm_resource_instance" "monitoring" {
  name              = "kub_monitor"
  service           = "sysdig-monitor"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.group.id}"
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

# Create logAnalysis instance access key
resource "ibm_resource_key" "monitor_secret" {
  name                 = "kub_monitor_secret"
  role                 = "Manager"
  resource_instance_id = "${ibm_resource_instance.monitoring.id}"
}

# LogDNA

resource "ibm_resource_instance" "logging" {
  name              = "kub_logging"
  service           = "logdna"
  plan              = "lite"
  location          = "us-south"
  resource_group_id = "${data.ibm_resource_group.group.id}"
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

# Create logAnalysis instance access key
resource "ibm_resource_key" "logging_secret" {
  name                 = "kub_logging_secret"
  role                 = "Manager"
  resource_instance_id = "${ibm_resource_instance.logging.id}"
}
