terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

# create pool
resource "libvirt_pool" "pool" {
  name = "${var.machine_name}_pool"
  type = "dir"
  path = "${var.root_path}/libvirt_images/${var.machine_name}_pool/"
}

# create image
resource "libvirt_volume" "image-qcow2" {
  name = "${var.machine_name}_image.qcow2"
  pool = libvirt_pool.pool.name
  source = "${var.root_path}/downloads/${var.image_name}.img"
  format = "qcow2"
}

# define KVM domain to create
resource "libvirt_domain" "domain" {
  # name must be unique!
  name = "${var.machine_name}_domain"
  memory = "${var.machine_memory}"
  vcpu = "${var.machine_vcpu}"
  # add cloud init disk to share user data
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  # set to default libvirt network
  network_interface {
    network_name = "${var.network_name}"
    mac = "${var.machine_mac_address}"
  }
  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
  disk {
    volume_id = libvirt_volume.image-qcow2.id
  }
  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

# add cloudinit disk to pool
resource "libvirt_cloudinit_disk" "commoninit" {
  name = "${var.machine_name}_commoninit.iso"
  pool = libvirt_pool.pool.name
  user_data = data.template_file.user_data.rendered
}

# read configuration
data "template_file" "user_data" {
  template = file("${var.user_data_path}")
}

