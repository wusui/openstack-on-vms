#! /bin/bash -fv
#
# Make sure stack and root can ssh between the undercloud and the physical machine
#
HOME=/home/stack
VMADDR=`arp -an | grep virbr | grep -v incomplete | sed 's/^.*(//' | sed 's/).*//'`
sudo cat /root/.ssh/id_rsa.pub > /tmp/everybody
sudo cat ${HOME}/.ssh/id_rsa.pub >> /tmp/everybody
sudo ssh ${VMADDR} cat /root/.ssh/id_rsa.pub >> /tmp/everybody
sudo ssh ${VMADDR} cat ${HOME}/.ssh/id_rsa.pub >> /tmp/everybody
sudo scp /tmp/everybody ${VMADDR}:/tmp/everybody
sudo cp /tmp/everybody /root/.ssh/authorized_keys
sudo cp /tmp/everybody ${HOME}/.ssh/authorized_keys
sudo ssh ${VMADDR} cp /tmp/everybody /root/.ssh/authorized_keys
sudo ssh ${VMADDR} cp /tmp/everybody ${HOME}/.ssh/authorized_keys
