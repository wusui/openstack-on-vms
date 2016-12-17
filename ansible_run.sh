#! /bin/bash -fv
#
# Create and run the ansible playbook that createis virtual machines
# TO DO: Fix this to just do the vm creations an terminate rather than fail
#        trying to install ospd versions that are not there.
#
#cd ~/ansible
sed ':a;N;$!ba;s/\n/\\n/g' ~/.ssh/id_rsa > /tmp/amiddle
cat <<EOF > /tmp/astart
---
# HYPERVISOR #
- hosts: hypervisor
  remote_user: root

  roles:
    - virt-env-ospd

  vars:
    # NETWORK #
    virt_env_ospd_bridges:
      - aardvark-pxe
      - aardvark-full

    # VM #
    virt_env_ospd_vm_name: aardvark

    # UNDERCLOUD NODE #
    virt_env_ospd_undercloud:
      name: aardvark_${1}
      disk_size: 40g
      cpu: 8
      mem: 16384
      cloud_init_iso: cloud-init-aardvark.iso

      # CEPH VM
    virt_env_ospd_ceph:
      name: ceph
      disk_size: 42g
      cpu: 4
      mem: 4096
      # The last digit is not missing !!
      mac: 52:54:00:aa:e3:8
      vm_count: 3
      extra_disk_count: 3

    # CEPH EXTRA DISKS
    virt_env_ospd_ceph_extra_disk:
      - { name: sdb, size: 42g, format: qcow2, bus: sata }
      - { name: sdc, size: 42g, format: qcow2, bus: sata }
      - { name: sdd, size: 42g, format: qcow2, bus: sata }

    # SWIFT VM
    virt_env_ospd_swift:
      name: swift
      disk_size: 40g
      cpu: 4
      mem: 4096
      # The last digit is not missing !!
      mac: 52:54:00:aa:e3:5
      vm_count: 0
      extra_disk_count: 3

    # SWIFT EXTRA DISKS
    virt_env_ospd_swift_extra_disk:
      - { name: sdb, size: 8g, format: qcow2, bus: sata }
      - { name: sdc, size: 8g, format: qcow2, bus: sata }
      - { name: sdd, size: 8g, format: qcow2, bus: sata }

    # CONTROL VM
    virt_env_ospd_control:
      name: control
      disk_size: 42g
      cpu: 4
      mem: 8192
      # The last digit is not missing !!
      mac: 52:54:00:aa:e3:6
      vm_count: 1

    # COMPUTE VM
    virt_env_ospd_compute:
      name: compute
      disk_size: 42g
      cpu: 4
      mem: 8192
      # The last digit is not missing !!
      mac: 52:54:00:aa:e3:7
      vm_count: 1

# UNDERCLOUD #
- hosts: undercloud
  remote_user: root

  roles:
    - virt-env-ospd

  vars:
    # UNDERCLOUD NODE #
    virt_env_ospd_undercloud_hostname: ${1}.aardvark.lab
    virt_env_ospd_upload_images: false

    virt_env_ospd_undercloud_conf:
      - { section: 'DEFAULT', option: 'enable_tempest', value: 'true' }
      - { section: 'DEFAULT', option: 'inspection_extras', value: 'true' }

    # BAREMETAL NODES #
    # You can use this command to get the SSH key on one line:
    # sed ':a;N;$!ba;s/\n/\\n/g' ~/.ssh/id_rsa
    virt_env_ospd_ssh_prv: 
EOF
cat <<EOF > /tmp/afinish


    # The line number should be equal to the number
    # of virtual machines
    undercloud_nodes:
      - { mac: "52:54:00:aa:e3:61", profile: "control" }
      - { mac: "52:54:00:aa:e3:81", profile: "storage" }
      - { mac: "52:54:00:aa:e3:82", profile: "storage" }
      - { mac: "52:54:00:aa:e3:83", profile: "storage" }
      - { mac: "52:54:00:aa:e3:71", profile: "compute" }

    virt_env_ospd_flavors:
      - { name: "control", ram: "8192", disk: "20", cpu: "2" }
      - { name: "compute", ram: "8192", disk: "20", cpu: "2" }
      - { name: "storage", ram: "4096", disk: "20", cpu: "2" }

EOF
head -c -1 -q /tmp/astart /tmp/amiddle /tmp/afinish  > /root/ansible/playbooks/virt-env-ospd/env1.yml
rm /tmp/afinish /tmp/amiddle /tmp/astart
cd /root/ansible
ansible-playbook -i inventories/virt-env-ospd/hosts playbooks/virt-env-ospd/env1.yml
