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
  hostname         = "tf-master"
  plan             = "baremetal_0"
  facility         = "ams1"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.rke_test.id}"
}

# Create a device and add it to rke_test project
resource "packet_device" "node" {
  hostname         = "tf-node"
  plan             = "baremetal_0"
  facility         = "ams1"
  operating_system = "coreos_stable"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.rke_test.id}"
}

output "master_ips" {
  value = ["${packet_device.master.*.access_public_ipv4}"]
}
output "node_ips" {
  value = ["${packet_device.master.*.access_public_ipv4}"]
}

data "template_file" "cluster" {
  template = "${file("${path.module}/cluster.tpl")}"
  vars {
    controlplane_address = "${packet_device.master.*.access_public_ipv4}"
    worker_address = "${packet_device.node.*.access_public_ipv4}"
  }

}

output "cluster_template" {
    value="${data.template_file.cluster.rendered}"
}
