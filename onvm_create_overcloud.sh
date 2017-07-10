#! /bin/bash -fv
#
# Create the yaml and ssh files needed, and  bring up the overcloud
#
HOME=/home/stack
cd ${HOME}
source stackrc
cp /usr/share/openstack-tripleo-heat-templates/environments/storage-environment.yaml ${HOME}/templates/.
ed ${HOME}/templates/storage-environment.yaml <<EOF
g/# CinderEnableNfsBackend/s//CinderEnableNfsBackend/
$
a

  ExtraConfig:
    ceph::profile::params::osds:
        '/dev/sdb': {}
        '/dev/sdc': {}
        '/dev/sdd': {}

resource_registry:
  OS::TripleO::NodeUserData: ${HOME}/templates/firstboot/wipe-disks.yaml
.
w
q
EOF
mkdir ${HOME}/templates/firstboot
cat << EOF1 >> ${HOME}/templates/firstboot/wipe-disks.yaml
heat_template_version: 2014-10-16

description: >
  Wipe and convert all disks to GPT (except the disk containing the root file system)

resources:
  userdata:
    type: OS::Heat::MultipartMime
    properties:
      parts:
      - config: {get_resource: wipe_disk}

  wipe_disk:
    type: OS::Heat::SoftwareConfig
    properties:
      config: {get_file: wipe-disk.sh}

outputs:
  OS::stack_id:
    value: {get_resource: userdata}
EOF1
cp /tmp/vmsetup/wipe-disk.sh ${HOME}/templates/firstboot/wipe-disk.sh
chmod 0775 ${HOME}/templates/firstboot/wipe-disk.sh
sed -i 's/# CephStorageCount: 0/CephStorageCount: 3/' ${HOME}/templates/storage-environment.yaml

sudo iptables -F
/tmp/vmsetup/overcloud_gets_real.sh
if ! [ -e overcloudrc ]; then
    /tmp/vmsetup/overcloud_gets_real.sh
fi
