#! /bin/bash -fv
#
# Update repos so that openstack can be installed.  Install virtual machine packages
#
scriptloc='/tmp/vmsetup'
source ${scriptloc}/secrets
#sudo sed -i -e 's,^hostname *=.*,hostname = subscription.rhn.stage.redhat.com,;s,baseurl *=.*,baseurl = http://cdn.stage.redhat.com,' /etc/rhsm/rhsm.conf
if [ ${subscrname} ]; then
    userclause="--username=${subscrname}"
fi
if [ ${subscrpassword} ]; then
    passclause="--password=${subscrpassword}"
fi
echo 'userclause '+${userclause}
sudo subscription-manager register ${userclause} ${passclause} --force 
sudo subscription-manager attach --pool=8a85f9823e3d5e43013e3ddd4e2a0977
sudo subscription-manager repos --disable=*
sudo subscription-manager repos --enable=rhel-7-server-rpms --enable=rhel-7-server-extras-rpms --enable=rhel-7-server-openstack-9-rpms --enable=rhel-7-server-openstack-9-director-rpms --enable=rhel-7-server-rh-common-rpms
sudo yum update -y
sudo yum -y install qemu-kvm qemu-img virt-manager libvirt libvirt-python python-virtinst libvirt-client virt-install virt-viewer
sudo reboot
