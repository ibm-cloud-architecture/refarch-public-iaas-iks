# Public Network Calico Policies

These sample Calico policies whitelist an IP address to allow only that IP address to access your Ingress or load balancer. To whitelist the IP address, you must apply all three policies.
- [deny-kube-node-port-services](./deny-kube-node-port-services.yaml) blocks all node-ports.
- `deny-ingress` blocks your load balancer or Ingress IP address.
- `allow-src-ip` identifies the IPs to whitelist. Because this policy has a lower `order` it will receive precedence over the other two policies, which allows the specified IPs address access to your cluster while all other IP addresses remain blocked.

Note that policy template files [template_deny-ingress.yaml](./template_deny-ingress.yaml) and [template_allow-src-ip.yaml](./template_allow-src-ip.yaml) are used in the script [configure-calico.sh](../../configuration/configure-calico.sh) to create the `deny-ingress.yaml` and `allow-src-ip.yaml` with the whitelisted IPs [input variables](../../../Aspects/DevOps.md#infrastructure-code-variables) `DEVOPS_IP` and `GLB_IP` public network calico policies and apply them.  To allow successful routing across zones in an [IKS Multizone Cluster](https://console.bluemix.net/docs/containers/cs_clusters_planning.html#multizone), the Multizone Load balancer (MZLB) requires a set of [CloudFlare IPs](https://www.cloudflare.com/ips) whitelisted in the [template_allow-src-ip.yaml](./template_allow-src-ip.yaml) for the region.
