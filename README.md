# k8s-on-packet

We try different methods and tools to install a k8s cluster on packet.net.

## Terraform and Rancher/RKE

1. create a new ssh private key pair

```
mkdir .ssh 
chmod 700 .ssh
ssh-keygen -f .ssh/id_rsa
```

1. set your Packet API token

```
export PACKET_AUTH_TOKEN=<your api token>
```

1. initiallize terraform plugins

```bash
terraform init
```

1. Setup a master and a node as most simple scenario as bare metal servers on packet via:

```bash
terraform validate
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
kubectl get nodes
kubectl get pod --all-namespaces
```

Enjoy.
