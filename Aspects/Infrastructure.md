#  Infrastructure Components

This aspect describes the set of infrastructure services needed to implement the reference architecture.

---

## IBM Cloud Services Used In This Solution

This solution includes the infrastructure components necessary to run and manage an IBM Cloud multi-zone/region Kubernetes cluster. You will deploy your containerized applications in Kubernetes pods hosted on worker nodes. In this solution, the nodes are multi-tenant virtual server instances. The Kubernetes master and the worker nodes communicate with each other through secure TLS certificates (which can be managed by the [IBM Cloud Certificate Manager Service](https://console.bluemix.net/docs/services/certificate-manager/about.html#about-certificate-manager)) and an OpenVPN connection to orchestrate your cluster configurations.

The applications communicate on public and private networks that connect the cluster to on-premises resources via VPN. Worker nodes are controlled by the Kubernetes master node that is managed by the service.

---

## Infrastructure Code

The infrastructure code (i.e. Terraform configuration and Calico) are located in the [infrastructure code](../infrastructure_code) folder.

---



## Component Table



|Component             | Description  |
|----------------|-------------------------------------------------------------------------------|
|Compute|[IBM Kubernetes Service](https://console.bluemix.net/docs/containers/cs_tech.html#kubernetes_basics) (IKS) is used  for the managed Kubernetes environment.  The service provides the end user with an ability to deploy single or multi-zone clusters to a region with the compute, storage, network and security infrastructure services. It enables the user to control access using resource groups and integrate with data, monitoring, activity tracking and logging services.|
|Load Balancing/WAF/DNS|[IBM Cloud Internet Services](https://console.bluemix.net/docs/infrastructure/cis/dns-concepts.html) (CIS) provide network management functions including global load balancing, Web Application Firewall, DNS management and DDOS protection for the public networks in this architecture.|
|Cross-zone load balancing|[Cloudflare multi-zone load balancer](https://console.bluemix.net/docs/containers/cs_clusters_planning.html#multizone) (MZLB) is automatically created and deployed so that 1 MZLB exists for each region. This architecture assumes the cluster will be deployed as a multi-zone. The MZLB puts the IP addresses of your ALBs behind the same hostname and enables health checks on these IP addresses to determine whether they are available or not.|
|Security|[IBM Kubernetes Service](https://console.bluemix.net/docs/containers/cs_secure.html#security) has several built-in security features to protect Docker images, running containers and pods, networks and user access to the resources. This solution leverages these features to help you to protect your Kubernetes cluster infrastructure and network communication, isolate your compute resources, and ensure security compliance across your infrastructure components and container deployments.|
|Resiliency|[IKS Region and multi-zone configuration](https://console.bluemix.net/docs/containers/cs_clusters.html#multizone) support deploying a single cluster and worker pools using multiple availability zones. In this architecture, two IKS clusters are deployed into two regions to serve as a primary and DR environment. Each region is load balanced by a common CIS load balancer for rapid failover.|
|Private Connectivity with remote sites| [StrongSwan VPN](https://console.bluemix.net/docs/containers/cs_vpn.html#vpn) provides a means to securely connect your cluster to another network environment. In this architecture, the StrongSwan VPN service is deployed as a container into your cluster and communicates with resources deployed into your cluster via private networks. The VPN service then routes traffic to/from the distant environment and supports NAT for both directions.|
|Data|There are several ways to implement a [data service](https://www.ibm.com/cloud/data) for your application in IBM Cloud. You can select one or more of IBM Cloud data services, run your own containerized data service in your IKS cluster or in IBM Cloud compute infrastructure, or run your data services remote from IBM Cloud and use of IBM Cloud service such as [Secure Gateway](https://console.bluemix.net/catalog/services/secure-gateway) or [App Connect](https://console.bluemix.net/catalog/services/app-connect) to integrate remote data services with your IBM Cloud-based applications. In this solution, we use the [IBM Cloudant](https://console.bluemix.net/catalog/services/cloudant) service for data.|
|Environment Security|Many teams use one or more tools to scan infrastructure services for vulnerabilities. This architecture assumes the services will be maintained remotely and access public IPs via the internet and private IPs via VPN to IBM Cloud.|
|Service Management|Monitoring of IBM Cloud infrastructure resources is accomplished with IBM Cloud and remote services. [IBM Cloud Monitoring](https://console.bluemix.net/docs/services/Monitoring-with-Sysdig/index.html#getting-started), [Activity Tracking](https://console.bluemix.net/catalog/services/activity-tracker) and [Logging](https://console.bluemix.net/docs/services/Log-Analysis-with-LogDNA/index.html#getting-started) services provide integrated monitoring for resources. In this architecture, monitoring is used to analyze metrics for an app that is deployed in a Kubernetes cluster. This architecture uses the [IBM Log Analysis with the LogDNA service](https://console.bluemix.net/docs/services/Log-Analysis-with-LogDNA/index.html#getting-started) to configure cluster-level logging on the IBM Cloud for Kubernetes clusters.|
|DevOps|[DevOps](https://www.ibm.com/cloud/devops) provide the automated processes for application, test and infrastructure developers to maintain, build, deploy, test and release their code assets. This architecture is supported by a set of scripts, primarily Terraform and YAML-based, to provision this infrastructure architecture.|
|Certificate Management|[IBM Cloud Certificate Manager](https://console.bluemix.net/docs/services/certificate-manager/index.html#gettingstarted) (CMS) enables the user to store and manage SSL certificates for your IBM cloud-based apps. CMS is integrated with IKS Application Load balancer. In this architecture CMS will manage the certificates for each cluster to support SSL communications with applications deployed into the cluster.|
|Backup|Your backup processes may focus on storage, data or repository services that would require an IBM Cloud capability or integration from third-party backup services to manage the content in these services. For this solution, we include a data service and expect the automation scripts would be maintained in a repository for source control similar to application code.  Refer to the documentation for backup practices for [Cloudant](https://console.bluemix.net/docs/services/Cloudant/guides/backup-cookbook.html#ibm-cloudant-backup-and-recovery). For backups to the source code repository, please refer to that repository's capabilities and best practices such a [Github's help documentation](https://help.github.com/articles/backing-up-a-repository/).
