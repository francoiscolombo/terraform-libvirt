<network>
  <name>${network_name}</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='${bridge_name}' stp='on' delay='0'/>
  <mac address='${bridge_mac_address}'/>
  <ip address='${ip_range}.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='${ip_range}.2' end='${ip_range}.254'/>
%{ for h in hosts ~}
      <host mac='${h.mac}' name='${h.name}' ip='${h.ip}'/>
%{ endfor ~}
    </dhcp>
  </ip>
  <dns enable='yes'/>
</network>
