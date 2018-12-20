# DevOps

This aspect describes the necessary steps and ingredients to automate provisioning of this Kubernetes infrastructure environment. Please read through the steps and complete to ensure a successful experience.

---

## Persistent Services

The description of this solution includes all of the services needed to implement the architecture solution. While the infrastructure code is designed to provision the infrastructure for an environment, operationally you may provision some services outside of the environment process. These services are referred to as persistent services that provide the framework, controls and governance for the environment resources.

The [persistent storage folder](../infrastructure_code/terraform/persistent_svcs) contains the infrastructure code you may use to provision these services.

The services include:

- Resource groups: resource groups are centrally configured and may be reused across environments. The resource groups are created to provide a common access control for services in the same group

- User ID: required to perform the provisioning so appropriate permissions for all services are needed within the resource group.

- Logging and monitoring service: these services are reused across environments. The service instances are deployed to regions to collect data from the IKS cluster resources.

- Internet services: WAF, load balancing and DNS services are reused across environments.

- Network VLANs: These services may be reused across resources / environments. They are typically provisioned through a request console.

### Provisioned Persistent Services
In preparation to run the automation, you can provision these services using the UI, API, CLI or run the scripts contained in the persistent services folder. They were created separately because these services may be managed and provisioned separately from a single environment.

1. The ID of a public and a private VLAN that are deployed to the same location.
2. An IBMid with the proper permissions noted below.
3. A resource group created in the correct region.
4. An instance of [Log Analysis with LogDNA](https://console.bluemix.net/docs/services/Log-Analysis-with-LogDNA/index.html#getting-started) and [Monitoring with SysDig](https://console.bluemix.net/docs/services/Monitoring-with-Sysdig/index.html#getting-started) deployed in that resource group.
5. An instance of the [CIS](https://console.bluemix.net/docs/infrastructure/cis/getting-started.html#getting-started-with-ibm-cloud-internet-services-cis-) service deployed.
6. An account with authorization and capacity to deploy an IKS cluster in the selected region.


## Provisioner Permissions

The following permissions are required to execute and successfully provision the environment.  The picture below provides the required set of permissions to successfully provision the reference architecture.  For additional information on IBM Cloud Kubernetes Service access control, see this [section of the IBM Cloud documentation](https://console.bluemix.net/docs/containers/cs_users.html#access-checklist).

![Provisioner Permissions](../imgs/provisioner-permissions.jpg)


## Script execution environment and Cloud preparation

Requirements to run the infrastructure code are as follows:

1. You will need a Terraform runtime environment to execute the scripts.  You can build your own [Dockerfile](../infrastructure_code/DockerFile) based the latest IBM Terraform Docker Container.  If you use this [IBM Terraform runtime image](https://hub.docker.com/r/ibmterraform/terraform-provider-ibm-docker/) as your base runtime, you only need to add in the IBM Cloud CLI, Kubernetes CLI and Calico CLI in the [Dockerfile](../infrastructure_code/DockerFile).

2. To successfully provision and work with clusters, you must ensure that your IBM Cloud account is correctly set up to access the IBM Cloud Infrastructure (SoftLayer) portfolio to create the worker nodes. To set up IBM Cloud Kubernetes Service to access the portfolio, the account owner must set the [Infrastructure] API key for the region and resource group before the provisioner user can use an [IBM Cloud API Key](https://console.bluemix.net/docs/iam/apikeys.html#ibm-cloud-api-keys) to provision a cluster.  See this [section of the IBM Cloud documentation](https://console.bluemix.net/docs/containers/cs_users.html#api_key) for more information.

3. You will need an [IBM Cloud API Key](https://console.bluemix.net/docs/iam/apikeys.html#ibm-cloud-api-keys) for the provisioner user ID with the [proper permissions](#provisioner-permissions) to provision the resources in the Terraform script, (IBM Kubernetes Service, IBM Cloudant) and access the Monitoring and Logging service instances.

---


## Setting up and Executing the Terraform

To prepare to execute the Terraform scripts, you will need to complete the following tasks:

1. Clone a local copy of the reference architecture code with the `git clone` command.

2. Identify your values for input [variables](#infrastructure-code-variables) that are used to replace default values in the infrastructure code. To set the input values, edit the `terraform.tvars` and replace the tokens `@@<token-name>@@` with the required values.

3. Start the docker container you built above as part of the perquisites with the option that mounts the local git repo path `infrastructure_code`.  For example, `docker run --name tf-runtime -it --volume /Users/joe/repos/Kub_IaaS/infrastructure_code:/tf/infrastructure_code terraform-provider-ibm:latest /bin/bash`

4. Once inside the IBM Terraform Docker container, set up the credentials to provision the cluster.  The following variable `paas_apikey` can be set either in the `terraform.tfvars`
or you can export it as environment variables in the running container/pod:
`export TF_VAR_paas_apikey=REPLACE_WTIH_YOUR_IBMCLOUD_API_KEY`

### Executing the Terraform

You are now ready to run the Terraform scripts.  Start with `terraform init` to initialize your working directory.  After, run a `terraform plan`.  If you are satisfied with the execution plan, then run `terraform apply` to provision the Kubernetes cluster for the environment.  Depending if you are provisioning a single zone cluster or a multi-zone cluster, you must specify the `--target` as required for the specific configuration as per the instructions below.

### Execute terraform for IBM Cloud Single Zone Environment
Run the following commands within the Terraform platform container:

1. `terraform init`
2. `terraform plan  --target="ibm_container_cluster.kubecluster"`
3. `terraform apply --target="ibm_container_cluster.kubecluster"`
4. `terraform apply`

### Execute terraform for IBM Cloud Multi-Zone Environment
Run the following commands within the Terraform platform container:

1. `terraform init`
2. `terraform plan --target="ibm_container_cluster.kubecluster" --target="ibm_container_worker_pool_zone_attachment.worker_zone2" --target="ibm_container_worker_pool_zone_attachment.worker_zone3"`
3. `terraform apply --target="ibm_container_cluster.kubecluster" --target="ibm_container_worker_pool_zone_attachment.worker_zone2" --target="ibm_container_worker_pool_zone_attachment.worker_zone3"`
4. `terraform refresh`
5. `terraform apply`

---

## Infrastructure Code Variables

The `terraform.tvars` file was created with the following variables and tokens so that it could be incorporated easily into a DevOps pipeline for automation.


|Name                                 | Tokens          |  Description                       |
|-------------------------------------|-----------------|------------------------------------|
| **Whitelist IPs Variables** |
|devops_ip |TF_DEVOPS_IP | The IP address of DevOps Deploy server.  This will allow the DevOps server to access the environment's cluster.|
|glb_ip |TF_GLB|The IP address of the Global Load Balancer (GLB) when provisioning an HA configuration.  This is used for Calico ingress rules.|
|**DevOps Deploy Variables**   |
|env_name|TF_ENV_NAME|The name of the environment used to create the Kubernetes namespace|
|**IKS Cluster Variables**   |
|is_ha_multizone|IS_MULTI_ZONE| Setting this variable to `0` will cause the code to create a cluster with a single Availability Zone (zone1).   Setting this variable to `1` will cause the code to create a cluster with three Availability Zones (zone1, zone2, and zone 3).  All worker nodes will be attached to the `default` worker pool for the cluster.|
|cluster_name|TF_CLUSTER_NAME|The base name for the cluster|
|num_workers|TF_NUM_WORKERS| The number of worker nodes per Availability Zones to create.|
|machine_type|TF_MACHINE_TYPE| The machine type for the cluster. You can get the list by command `bx cs machine-type <zone>` |
|**Container Cluster Variables for Main (zone1) Availability Zone (AZ)**   |
|zone1|TF_ZONE1_NAME| The main (zone1) Availability Zone (AZ) to deploy the cluster and worker nodes.  You can get the list by running the command `bx cs locations` |
|zone1_public_vlan_id|TF_ZONE1_PUBLIC_VLAN_ID|The public VLAN of the worker nodes for the main AZ. You can run the command `bx cs vlans <location>`.|
|zone1_private_vlan_id|TF_ZONE1_PRIVATE_VLAN_ID|The private VLAN of the worker nodes for the main AZ. You can run the command `bx cs vlans <location>`.|
|**Worker Pool Variables for zone2 Availability Zone (AZ)**   |
|zone2|TF_ZONE2_NAME| The second Availability Zone pool of worker nodes.  You can get the list of zones by running the command `ibmcloud ks zones`. |
|zone2_public_vlan_id|TF_ZONE2_PUBLIC_VLAN_ID|The public VLAN of the worker nodes for the 2nd AZ. You can run the command `bx cs vlans <location>`.|
|zone2_private_vlan_id|TF_ZONE2_PRIVATE_VLAN_ID|The private VLAN of the worker nodes for the 2nd AZ. You can run the command `bx cs vlans <location>`.||
|**Worker Pool Cariables for zone3 Availability Zone (AZ)**   |
|zone3|TF_ZONE3_NAME| The third Availability Zone (AZ) pool of worker nodes.  You can get the list by running the command `ibmcloud ks zones`. |
|zone3_public_vlan_id|TF_ZONE3_PUBLIC_VLAN_ID|The public VLAN of the worker nodes for the 3rd AZ. You can run the command `ibmcloud ks vlans --zone <zone name>`.|
|zone3_private_vlan_id|TF_ZONE3_PRIVATE_VLAND_ID|The private VLAN of the worker nodes for the 3rd AZ. You can run the command `ibmcloud ks vlans --zone <zone name>`.|
|**Monitoring and Logging Variables**   |
|logdna_ingestion_key |TF_LOGDNA_INGEST_KEY| The LogDNA ingestion key is used to open a secure web socket to the logDNA ingestion server and to authenticate the logging agent with the IBM Log Analysis with LogDNA service.|
|sysdig_access_key |TF_SYSDIG_ACCESS_KEY| This variable is the ingestion access key for the Monitoring Service instance. |
|**Cloudant Variables**|
|cloudant_create_instance|TF_CREATE_CLOUDANT| Setting this variable to `0` will cause the code NOT to create a Cloudant instance. Setting this variable to `1` will cause the code to create a Cloudant instance.|
|cloudant_name|TF_CLOUDANT_NAME|The name to give to the Cloudant database to bind to the cluster.|
|cloudant_plan|TF_CLOUDANT_PLAN|The Cloudant plan to provision (lite, standard, dedicated) |
|**IBM Cloud Variables**|
|account_id|TF_ACCOUNT_ID|The IBM Cloud Account GUID.  See the command `ibmcloud account list`|
|paas_apikey|IBM_CLOUD_API_KEY|IBM Cloud API Key with IKS and Cloudant administrative privileges permissions in the account.|
|resource_group|TF_RESOURCE_GROUP|The IBM Cloud resource group name in which the cluster and Cloudant database is to be created.  See the command `ibmcloud resource groups`|
|ibm_region|TF_REGION|The IBM Cloud region where you want to deploy the cluster.  Note that the VLANs IDs must be in the region that you provide. See the list of regions with the command `ibmcloud regions` for example, *us-south*|
