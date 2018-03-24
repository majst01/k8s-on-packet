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
  plan             = "${var.plan}"
  facility         = "${var.facility}"
  operating_system = "${var.operating_system}"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.rke_test.id}"
}

# Create a device and add it to rke_test project
resource "packet_device" "node" {
  count            = "${var.worker_count}"
  hostname         = "k8s-node-${count.index}"
  plan             = "${var.plan}"
  facility         = "${var.facility}"
  operating_system = "${var.operating_system}"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.rke_test.id}"
}
