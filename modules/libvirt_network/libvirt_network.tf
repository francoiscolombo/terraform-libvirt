# let terraform manage the lifecycle of the network
resource "null_resource" "libvirt_k8s_network" {
  triggers = {
    network_name = var.network_name
  }
  # run by terraform apply
  provisioner "local-exec" {
    command = "virsh net-define ${var.config_path} && virsh net-autostart ${var.network_name} && virsh net-start ${var.network_name}"
    interpreter = ["/bin/bash", "-c"]
  }
  # run by terraform destroy
  provisioner "local-exec" {
    when = destroy
    command = "virsh net-destroy ${self.triggers.network_name} && virsh net-undefine ${self.triggers.network_name}"
  }
}

