#! /bin/bash -fv
#
# Run this script, passing it the name of the machine that you want to install on.
#
# This should bring up a machine with 1 controller, 1 compute node, and 3 ceph nodes running
# as vms on that machine.
#
# This whole procedure takes about 2 hours.
#
# install_start.sh subscribes to the rhel, openstack, and ceph repos, updates, and then
#     installs the virtual machine modules
# install_vms.sh brings up the vms.
# install_run_undercloud_cmds.sh installs the undercloud
# rem_introspection.sh performs baremetal introspection inside the vm, and then brings up
# the overcloud
#
./install_start.sh $1
sleep 300
./install_vms.sh $1
sleep 180
ssh $1 sudo /tmp/vmsetup/install_run_undercloud_cmds.sh $1
sleep 180
ssh $1 sudo /tmp/vmsetup/rem_introspection.sh
