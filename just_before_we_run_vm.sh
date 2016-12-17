#! /bin/bash -fv
#
# Save address of undercloud node and get the remote machine and scripts onto
# the virtual network that is running on the remote host.
#
virsh list --all
VMADDR=`arp -an | grep virbr | grep -v incomplete |  sed 's/^.*(//' | sed 's/).*//'`
echo "The vm we will be running on is:"
echo ${VMADDR}
echo ${VMADDR} > /tmp/vaddrinfo
if [ -z `ssh-keygen -F ${VMADDR}` ]; then
    ssh-keyscan -H ${VMADDR} >> ~/.ssh/known_hosts
fi
scp /tmp/vmsetup/quick.tar ${VMADDR}:/tmp
scp /tmp/vmsetup/install_on_vm.sh ${VMADDR}:/tmp
hostname -i > /tmp/hostnamei
scp /tmp/hostnamei ${VMADDR}:/tmp/hostnamei
ssh ${VMADDR} /tmp/install_on_vm.sh
