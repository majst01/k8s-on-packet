# k8s-on-packet

We try different methods and tools to install a k8s cluster on packet.net.

## Terraform and Rancher/RKE

### install terraform and rancher/rke und kubectl

```bash
sudo wget https://github.com/rancher/rke/releases/download/v0.1.3-rc4/rke_linux-amd64 -o /usr/local/bin/rke


wget https://releases.hashicorp.com/terraform/0.11.5/terraform_0.11.5_linux_amd64.zip
  && unzip terraform_0.11.5_linux_amd64.zip
  && sudo mv terraform /usr/local/bin/terraform

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
 && chmod +x kubectl
 && sudo mv kubectl /usr/local/bin/kubectl
```

### create a new ssh private key pair

```
mkdir .ssh 
chmod 700 .ssh
ssh-keygen -f .ssh/id_rsa
```

### set your Packet API token

```
export PACKET_AUTH_TOKEN=<your api token>
```

### initiallize terraform plugins

```bash
terraform init
```

### Setup a master and a node as most simple scenario as bare metal servers on packet via:

```bash
terraform validate
terraform apply
```

After this a `kube_config_cluster.yml` configuration is written, copy this to ~/.kube/config.
The you can use your cluster with:

```bash
cp kube_config_cluster.yml ~/.kube/config
kubectl get nodes
kubectl get pod --all-namespaces
```

Enjoy.
