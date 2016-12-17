#! /bin/bash -fv
VM_IP=`cat /tmp/vaddrinfo`
sudo ssh stack@${VM_IP} /tmp/vmsetup/onvm_pre_introspection.sh
sudo ssh stack@${VM_IP} /tmp/vmsetup/onvm_post_introspection.sh
sudo ssh stack@${VM_IP} /tmp/vmsetup/onvm_create_overcloud.sh
