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
