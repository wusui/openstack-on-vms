#! /bin/bash -fv
#
# Make sure that the virtual machine root and stack can passwordlessly ssh
# to the physical remote machine.
#
# Then set up the stack directory on the virtual machines, fix certifications,
# and install the undercloud
#
VM_IP=`cat /tmp/vaddrinfo`
sudo ssh ${VM_IP} sudo /tmp/vmsetup/onvm_mkkeys_wrap.sh
sudo /tmp/vmsetup/everybody_talks.sh
HOST=`hostname -s`
sudo ssh -t stack@${VM_IP} /tmp/vmsetup/setup-vm.sh $HOST
sudo ssh -t stack@${VM_IP} /tmp/vmsetup/setup_certifications.sh
sudo sed -i -e 's,^SELINUX=.*,SELINUX=permissive' /etc/selinux/config
sudo ssh -t stack@${VM_IP} sudo sed -i -e 's,^SELINUX=.*,SELINUX=permissive' /etc/selinux/config
sudo ssh -t stack@${VM_IP} /tmp/vmsetup/get_images_and_nameserver.sh
