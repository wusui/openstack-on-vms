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

sleep 301

export HEAT_INCLUDE_PASSWORD=1
openstack overcloud deploy --templates \
  -e ${HOME}/templates/storage-environment.yaml \
  --control-scale 1 \
  --ceph-storage-scale 3 \
  --compute-scale 1 \
  --compute-flavor compute \
  --ceph-storage-flavor ceph-storage \
  --control-flavor control \
  --ntp-server clock.redhat.com \
  --libvirt-type kvm
  
