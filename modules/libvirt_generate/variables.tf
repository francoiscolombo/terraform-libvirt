variable "config_file_path" {
  type = string
}

variable "network_name" {
  type = string
}

variable "bridge_name" {
  type = string
}

variable "bridge_mac_address" {
  type = string
}

variable "ip_range" {
}

variable "hosts" {
  type = list(object({
    mac  = string
    name = string
    ip   = string
  }))
}
