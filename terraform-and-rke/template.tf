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
    controlplane       = "${join("\n",data.template_file.controlplane.*.rendered)}"
    worker             = "${join("\n",data.template_file.worker.*.rendered)}"
    etcd_version       = "${var.etcd_version}"
    kubernetes_version = "${var.kubernetes_version}"
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
