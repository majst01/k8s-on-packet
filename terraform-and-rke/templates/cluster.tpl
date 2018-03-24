---
ssh_key_path: .ssh/id_rsa
ignore_docker_version: true

nodes:
${controlplane}
${worker}

services:
  etcd:
    image: quay.io/coreos/etcd:${etcd_version}
  kube-api:
    image: rancher/k8s:${kubernetes_version}
  kube-controller:
    image: rancher/k8s:${kubernetes_version}
  scheduler:
    image: rancher/k8s:${kubernetes_version}
  kubelet:
    image: rancher/k8s:${kubernetes_version}
  kubeproxy:
    image: rancher/k8s:${kubernetes_version}
