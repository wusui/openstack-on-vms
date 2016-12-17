#! /bin/bash -fv
HOME=/home/stack
mkdir /root/cloud-init ; cd /root/cloud-init
cat << EOF > meta-data
instance-id: 2016031801
local-hostname: ${1}.aardvark.lab
EOF
STACKID=`cat ${HOME}/.ssh/id_rsa.pub`
ROOTID=`cat /root/.ssh/id_rsa.pub`
cat << EOF > user-data
#cloud-config
users:
  - default
  - name: stack
    gecos: RedHat Openstack User
    ssh-authorized-keys:
      - ${STACKID}
    sudo:
      - ALL=(root) NOPASSWD:ALL
  - name: root
    ssh-authorized-keys:
      - ${ROOTID}

write_files:
  - path: /etc/sysconfig/network-scripts/ifcfg-eth0
    content: |
      DEVICE=eth0
      TYPE=Ethernet
      BOOTPROTO=dhcp
      ONBOOT=yes
  - path: /etc/sysconfig/network-scripts/ifcfg-eth2
    content: |
      DEVICE=eth2
      TYPE=Ethernet
      BOOTPROTO=none
      ONBOOT=yes
  - path: /etc/sysconfig/network-scripts/ifcfg-eth2.10
    content: |
      DEVICE=eth2.10
      TYPE=vlan
      BOOTPROTO=none
      ONBOOT=yes
      IPADDR=10.0.0.1
      NETMASK=255.255.255.0
  - path: /etc/sysctl.conf
    content: |
      net.ipv4.ip_forward = 1

runcmd:
  - /usr/bin/systemctl restart network
  - /usr/sbin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
  - /usr/sbin/service iptables save
EOF
genisoimage -output /root/ansible/playbooks/virt-env-ospd/files/cloud-init-aardvark.iso -volid cidata -joliet -rock user-data meta-data
