#! /bin/bash -fv
#
# Create the yaml and ssh files needed, and  bring up the overcloud
#
HOME=/home/stack
source /tmp/vmsetup/secrets
testr=${deploytoo:-'yes'}
if ! [ ${testr} = 'yes' ]; then
   exit 0
fi
cd ${HOME}
source stackrc
export HEAT_INCLUDE_PASSWORD=1
# sleep 301
openstack overcloud deploy --verbose -t 90 --templates \
  --control-scale 1 \
  --ceph-storage-scale 3 \
  --compute-scale 1 \
  -e ${HOME}/templates/environments/storage-environment.yaml \
  --compute-flavor compute \
  --ceph-storage-flavor ceph-storage \
  --control-flavor control \
  --ntp-server clock.redhat.com \
  --libvirt-type kvm

