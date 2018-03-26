# How many masters do you want
variable "controlplane_count" {
  description = "Describes the amount of controlplanes for the cluster"
  default     = 1
}

# How many nodes
variable "worker_count" {
  description = "Describes the amount of worker for the cluster"
  default     = 1
}

variable "facility" {
  description = "The desired location where to start the servers"
  default     = "ams1"
}

variable "plan" {
  description = "The size of the servers to install"
  default     = "baremetal_0"
}

variable "operating_system" {
  description = "The operating system to install"
  default     = "coreos_stable"
}

variable "kubernetes_version" {
  description = "The version of kubernetes to install, see https://hub.docker.com/r/rancher/k8s/tags/"
  default     = "v1.9.5-rancher1-1"
}

variable "etcd_version" {
  description = "The version of etcd to install, see https://quay.io/repository/coreos/etcd?tab=tags"
  default     = "v3.3"
}
