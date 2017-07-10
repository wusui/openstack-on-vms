#! /bin/bash -fv
#
# Create the yaml and ssh files needed, and  bring up the overcloud
#
HOME=/home/stack
cd ${HOME}
source stackrc
export HEAT_INCLUDE_PASSWORD=1
sleep 301
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

