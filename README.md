# k8s-on-packet

We try different methods and tools to install a k8s cluster on packet.net.

## Terraform and Rancher/RKE

1. Setup a master and a node as most simple scenario as bare metal servers on packet via:

```bash
terraform apply
```
This will take ~5min, after that the ip addresses of the new servers will be in `terraform.tfstate`.
Put the matching ips into cluster.yml and install k8s with:


```bash
rke up
```

After this a `kube_config_cluster.yml` configuration is written, copy this to ~/.kube/config.
The you can use your cluster with:

```bash
kubctl get nodes
```

Enjoy.
