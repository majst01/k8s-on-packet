---

ssh_key_path: .ssh/id_rsa

ignore_docker_version: true

nodes:
  - address: ${controlplane_address}
    user: core
    role: [controlplane,etcd]
  - address: ${worker_address}
    user: core
    role: [worker]


services:
  etcd:
    image: quay.io/coreos/etcd:latest
  kube-api:
    image: rancher/k8s:v1.9.5-rancher1-1
  kube-controller:
    image: rancher/k8s:v1.9.5-rancher1-1
  scheduler:
    image: rancher/k8s:v1.9.5-rancher1-1
  kubelet:
    image: rancher/k8s:v1.9.5-rancher1-1
  kubeproxy:
    image: rancher/k8s:v1.9.5-rancher1-1
