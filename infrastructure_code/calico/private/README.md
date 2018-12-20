# Private Network Calico policies

Note that these private network isolation policies were cloned from the [IBM Cloud/kube-samples/calico-policies/private-network-isolation](https://github.com/IBM-Cloud/kube-samples/tree/master/calico-policies/private-network-isolation/calico-v3)

This set of Calico policies and host endpoints isolates the private network traffic of a cluster in IBM Cloud Kubernetes from other resources in the account's private network. The policies target the private interface (eth0) and the pod network of a cluster.

The template file [template_privatehostendpoint.yaml](./template_privatehostendpoint.yaml) is used to generate the host endpoints yaml file `privatehostendpoint.yaml` with the terraform template `data.template_file.data_json` in the terraform script [config_calico.tf](../../terraform/config_calico.tf).  The generated host endpoints yaml file `privatehostendpoint.yaml` is then applied by the script [configure-calico.sh](../../configuration/configure-calico.sh) to the cluster.  It creates Calico [HostEndPoint Resource](https://docs.projectcalico.org/v3.3/reference/calicoctl/resources/hostendpoint) for each worker node with a `worker.private` label that is used as a selector in  calico private network policies in this repo.  Note that each time the cluster is updated with a new worker node, you want to ensure that the host endpoints yaml file with the new entries are updated and the calico policy `privatehostendpoint.yaml` re-applied.


## List of changes made by these Calico private network policies

Worker node summary:
 - Private interface Egress only allowed to pod IPs, workers in this cluster, and udp/tcp port 53 (dns).
 - Private interface Ingress only allowed from workers in the cluster, dns, kubelet, icmp, and vrrp.

Pod specific summary (i.e. pods not on the host network):
 - Allow all ingress to pods. The above worker ingress restrictions limit this to traffic coming from workers in the cluster.
 - Allow egress to public IPs, dns, kubelet, and other pods in the cluster.

## Tests

For reference, here is a list of manual tests that have been run against these policies:

**Before policies are applied**
- Deploy app to a cluster
- Confirm can hit ingress
- Confirm can hit dashboard

**After policies are applied**
- Add deployment.
- Add a worker node.
- Reload worker node.
- Confirm pods can hit one another.
- Confirm can hit LB from external.
- Confirm can hit ingress from external.
- Test dns resolution (port 53) - nslookup.
- SSH into worker node and ping worker node (in cluster). Should succeed.
- SSH into worker node and ping VSI (out of cluster). Should fail.
- Ping external VSI from pods running on eth0 and pod network. Should fail.
- Test worker nodes can't be pinged seen by other VSIs on private network.
  - Note, must remove `allow-icmp-private` to test.
- Test kubectl logs and exec on a pod.
- Add a subnet.
- Confirm all worker nodes are accessible via LB/ingress.
- Confirm cannot hit other external IPs once `allow-egress-pods` are applied.
