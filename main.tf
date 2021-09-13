# load provider
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

# prepare network config file
module "libvirt-network-config-module" {
  source = "./modules/libvirt_generate"
  config_file_path = "${var.config_file_path}"
  network_name = "${var.network_name}"
  bridge_name = "${var.bridge_name}"
  bridge_mac_address = "${var.bridge_mac_address}"
  ip_range = "${var.ip_range}"
  hosts = "${var.hosts}"
}

# define network
module "libvirt-network-module" {
  source = "./modules/libvirt_network"
  network_name = "${var.network_name}"
  config_path = module.libvirt-network-config-module.config_filename
}

# define servers
module "libvirt-server-module" {
  for_each = var.nodes
  # load module
  source = "./modules/libvirt_vm/"
  # set common variables
  network_name = "${var.network_name}"
  root_path = "${path.module}"
  image_name = "focal-server-cloudimg-amd64"
  user_data_path = "${path.module}/cloud_init.cfg"
  # set nodes variables
  machine_name = each.value.name
  machine_memory = each.value.memory
  machine_vcpu = each.value.vcpu
  machine_mac_address = each.value.mac_address
}

