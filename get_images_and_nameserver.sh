#! /bin/bash -fv
#
# Install the undercloud and make sure the neutron subnets are set up for the
# overcloud
#
source /tmp/vmsetup/secrets
osversion=${rhelvers:-'9'}
HOME=/home/stack
cd ${HOME}
openstack undercloud install
if ! [ -e stackrc ]; then
    sudo cp /root/stackrc stackrc
    sudo chown stack:stack stackrc
fi
source ${HOME}/stackrc
sudo yum -y install rhosp-director-images rhosp-director-images-ipa
cd ${HOME}/images
for i in /usr/share/rhosp-director-images/overcloud-full-latest-${osversion}.0.tar /usr/share/rhosp-director-images/ironic-python-agent-latest-${osversion}.0.tar; do tar -xvf $i; done
openstack overcloud image upload --image-path ${HOME}/images/
openstack image list
ls -l /httpboot
X=`neutron subnet-list | tail -2 | head -1 | sed 's/^| //' | sed 's/ |.*//'`
neutron subnet-list
ndns=${dnsvalue:-'10.11.5.19'}
neutron subnet-update $X --dns-nameserver $ndns
neutron subnet-show $X
