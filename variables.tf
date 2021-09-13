variable "nodes" {
  description = "here, we can define attributes for our VMs"
  type = map(object({
    name           = string
    memory         = string
    vcpu           = number
    mac_address    = string
  }))
  default  = {
    "node-1" = {
      name = "node_1",
      memory = "1024",
      vcpu = 1,
      mac_address = "54:38:CE:32:61:79",
    },
    "node-2" = {
      name = "node_2",
      memory = "1024",
      vcpu = 1,
      mac_address = "F6:88:3B:36:38:E1",
    },
    "node-3" = {
      name = "node_3",
      memory = "1024",
      vcpu = 1,
      mac_address = "1A:68:5C:64:CB:8E",
    }
  }
}

variable "config_file_path" {
  default = "./output.xml"
}

variable "network_name" {
  default = "libvirt_network"
}

variable "bridge_name" {
  default = "vibr1"
}

variable "bridge_mac_address" {
  default = "90:D5:78:85:9B:A8"
}

variable "ip_range" {
  default = "192.168.171"
}

variable "hosts" {
  default = [
    {
      mac  = "54:38:CE:32:61:79",
      name = "node1",
      ip   = "192.168.171.11"
    },
    {
      mac  = "F6:88:3B:36:38:E1",
      name = "node2",
      ip   = "192.168.171.12"
    },
    {
      mac  = "1A:68:5C:64:CB:8E",
      name = "node3",
      ip   = "192.168.171.13"
    }
  ]
}

