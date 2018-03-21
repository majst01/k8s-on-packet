# Configure the Packet Provider
provider "packet" {
  #  auth_token = "${var.auth_token}"
}

# Create a project
resource "packet_project" "rke_test" {
  name = "Kubernetes with Rancher RKE"
}

resource "packet_ssh_key" "key1" {
  name       = "terraform-1"
  public_key = "${file("$HOME/.ssh/id_rsa.pub")}"
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
