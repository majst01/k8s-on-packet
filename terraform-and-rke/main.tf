# How many masters do you want
variable "controlplane_count" {
  description = "Describes the amount of controlplanes for the clusters"
  default     = 1
}

# How many nodes
variable "worker_count" {
  description = "Describes the amount of worker for the clusters"
  default     = 1
}

# Configure the Packet Provider
provider "packet" {
  #  auth_token = "${var.auth_token}"
}

# Create a project
resource "packet_project" "rke_test" {
  name = "Kubernetes with Rancher RKE"
}

resource "packet_ssh_key" "cluster_key" {
  name       = "terraform-1"
  public_key = "${file(".ssh/id_rsa.pub")}"
}

# Create a device and add it to rke_test project
resource "packet_device" "master" {
  count            = "${var.controlplane_count}"
  hostname         = "k8s-master-${count.index}"
  plan             = "baremetal_0"
  facility         = "ams1"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.rke_test.id}"
}

# Create a device and add it to rke_test project
resource "packet_device" "node" {
  count            = "${var.worker_count}"
  hostname         = "k8s-node-${count.index}"
  plan             = "baremetal_0"
  facility         = "ams1"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.rke_test.id}"
}

# For later reference store master ips
output "master_ips" {
  value = ["${packet_device.master.*.access_public_ipv4}"]
}

# For later reference store node ips
output "node_ips" {
  value = ["${packet_device.master.*.access_public_ipv4}"]
}

data "template_file" "controlplane" {
  template = "${file("${path.module}/templates/controlplane.tpl")}"
  count    = "${var.controlplane_count}"

  vars {
    controlplane_address = "${element(packet_device.master.*.access_public_ipv4,count.index)}"
  }
}

data "template_file" "worker" {
  template = "${file("${path.module}/templates/worker.tpl")}"
  count    = "${var.worker_count}"

  vars {
    worker_address = "${element(packet_device.node.*.access_public_ipv4,count.index)}"
  }
}

data "template_file" "cluster" {
  template = "${file("${path.module}/templates/cluster.tpl")}"

  vars {
    controlplane = "${join("\n",data.template_file.controlplane.*.rendered)}"
    worker       = "${join("\n",data.template_file.worker.*.rendered)}"
  }
}

output "worker_template" {
  value = "${data.template_file.worker.*.rendered}"
}

output "controlplane_template" {
  value = "${data.template_file.controlplane.*.rendered}"
}

output "cluster_template" {
  value = "${data.template_file.cluster.*.rendered}"
}

# Listen on the cluster template rendered to a variable
# Store content in a file and bring the install/modify k8s via rke
resource "null_resource" "local" {
  triggers {
    template = "${data.template_file.cluster.rendered}"
  }

  provisioner "local-exec" {
    command = "echo \"${data.template_file.cluster.rendered}\" > cluster.yml && rke up "
  }
}
