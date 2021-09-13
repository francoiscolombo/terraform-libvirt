resource "local_file" "network_config_file" {
  filename = "${var.config_file_path}"
  content = templatefile("${path.module}/libvirt_network_config.xml.tpl", {
    network_name = var.network_name,
    bridge_name = var.bridge_name,
    bridge_mac_address = var.bridge_mac_address,
    ip_range = var.ip_range,
    hosts = var.hosts
  })
}

