#! /bin/bash -fv
HOME=/home/stack
openstack undercloud install
source ${HOME}/stackrc
sudo yum -y install rhosp-director-images rhosp-director-images-ipa
cd ${HOME}/images
for i in /usr/share/rhosp-director-images/overcloud-full-latest-9.0.tar /usr/share/rhosp-director-images/ironic-python-agent-latest-9.0.tar; do tar -xvf $i; done
openstack overcloud image upload --image-path ${HOME}/images/
openstack image list
ls -l /httpboot
X=`neutron subnet-list | tail -2 | head -1 | sed 's/^| //' | sed 's/ |.*//'`
neutron subnet-list
neutron subnet-update $X --dns-nameserver 192.0.2.2
neutron subnet-show $X
