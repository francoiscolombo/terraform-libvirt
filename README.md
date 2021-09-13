# terraform module for generating VMs from libvirt

## Disclaimer

personal notes on how to use terraform with libvirt

## prerequisites

### Check if virtualization is active

    $ lscpu | grep Virtualization

must have

    Virtualization: VT-x

instruct KVM to enable nested virtualisation:

    $ sudo rmmod kvm-intel && sudo modprobe kvm_intel nested=1
    $ cat /sys.module/kvm_intel/parameters

should output prints 'Y' or '1'

### Download and install KVM, enable libvirt-service

    $ sudo apt update
    $ sudo apt -y install qemu-kvm libvirt-bin virt-top libguestfs-tools virtinst bridge-utils
    $ sudo modprobe vhost_net
    $ sudo lsmod | grep vhost
    $ sudo systemctl enable --now libvirtd
    $ sudo systemctl status libvirtd
    $ sudo apt -y install virt-manager
    $ sudo apt -y install libvirt-dev

### Setup permissions

    $ sudo usermod -aG libvirt,kvm `your user`
    $ groups

must have libvirt and kvm

we must also **turn off SELinux** under `/etc/libvirt/qemu.conf`

- edit this file and search for **security_driver**
- uncomment the line and change `security_driver = "selinux"` to `security_driver = "none"`
- save & exit

### clone this repository and download the source image

under **downloads** subdirectory, launch:

    $ wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

use another image if needed, but using a cloud image is mandatory.

### create a cloud_init.cfg file

this is a sample that you can use. replace *you user* by your user and *your ssh pub key* by your ssh public key.

```
#cloud-config
users:
  - name: <your user>
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: users, admin
    home: /home/<your user>
    shell: /bin/bash
    ssh_authorized_keys:
      - <your ssh pub key here, must starts by ssh-rsa ...>
# install packages
packages:
  - qemu-guest-agent
  - git
  - wget
```

add packages if needed. if we need to run some commands, we can use this:

```
# run command after boot
runcmd:
  - ["cd", "/home/<your user>"]
  - ["git", "clone", "....."]
...
```

### change variables

update *variables.tf* as needed

note regarding the mac address: we have to use unicast mac addresses, which means that the last bit of the least byte must NOT be 1.
(see unicast mac addresses for more details)
basically, this means that the first byte of the address must be pair and not even. 96 is allowed, 97 is not.
so in order to generate random mac addresses, we can use something like this:

    $ openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/:$//'

BUT change the first byte to be pair, otherwise you generate a multicat mac address and not an unicast one.

otherwise, this one seems to generate only proper unicast address, but good luck to understand it.

    $ bash -c "printf '%02x' \$((0x\$(od /dev/urandom -N1 -t x1 -An | cut -c 2-) & 0xFE | 0x02)); od /dev/urandom -N5 -t x1 -An | sed 's/ /:/g'"

### run terraform

    $ terraform init
    $ terraform plan
    $ terraform apply

and to destroy it:

    $ terraform destroy

### check results

use the following commands to check if the domains are created:

    $ virsh list --all

use this command to check the pool

    $ virsh pool-list --all

check the volumes

    $ virsh vol-list < the pool >

check network

    $ virsh net-list --all

check servers ip

    $ virsh net-dhcp-leases < network name >

from here we can ping or ssh under the servers.

during init, we can check the console with something like:

    $ virsh console < id from virsh list --all >

check the config of a network:

    $ virsh net-dumpxml < network name >

manually define a network from a xml file:

    $ virsh net-define < xml file >
    $ virsh net-start < network name >
    $ virsh net-list --all

manually stop a network:

    $ virsh net-destroy < network name >

manually delete a network:

    $ virsh net-undefine < network name >

use same kind of commands for domains and pools (see virsh --help)


