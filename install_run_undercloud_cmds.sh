#! /bin/bash -fv
VM_IP=`cat /tmp/vaddrinfo`
sudo ssh ${VM_IP} sudo /tmp/vmsetup/onvm_mkkeys_wrap.sh
sudo /tmp/vmsetup/everybody_talks.sh
HOST=`hostname -s`
sudo ssh stack@${VM_IP} /tmp/vmsetup/setup-vm.sh $HOST
sudo ssh stack@${VM_IP} /tmp/vmsetup/setup_certifications.sh
sudo ssh stack@${VM_IP} /tmp/vmsetup/get_images_and_nameserver.sh
