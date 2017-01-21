#! /bin/bash -fv
#
# Run the pieces to put together the overcloud
#
VM_IP=`cat /tmp/vaddrinfo`
sudo -t ssh stack@${VM_IP} /tmp/vmsetup/onvm_pre_introspection.sh
sudo -t ssh stack@${VM_IP} /tmp/vmsetup/onvm_post_introspection.sh
y=`sudo virsh list --all | awk '{print $2}' | grep aardvark | paste -d -s`
for x in $y; do
    /tmp/vmsetup/edit_virsh.sh $x
done
sleep 180
sudo -t ssh stack@${VM_IP} /tmp/vmsetup/onvm_create_overcloud.sh
