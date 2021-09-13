variable "machine_name" {
  description = "name of the VM to create"
  type = string
}

variable "machine_memory" {
  description = "memory to affect to the vm"
  type = string
}

variable "machine_vcpu" {
  description = "nb of vpcu to affect to the vm"
  type = number
}

variable "machine_mac_address" {
  description = "unique mac address for the vm, must correlate with the network definition in order to affect a static IP"
  type = string
}

variable "user_data_path" {
  description = "path for the cloudinit configuration file to run at the VM creation"
  type = string
}

variable "network_name" {
  description = "name of the network where this VM belong to"
  type = string
}

variable "root_path" {
  description = "root path for downloads and libvirt_images directories"
  type = string
}

variable "image_name" {
  description = "base image name of the VM to create"
  type = string
  default = "focal-server-cloudimg-amd64"
}

