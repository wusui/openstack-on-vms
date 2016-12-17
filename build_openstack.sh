#! /bin/bash -fv
./install_start.sh $1
sleep 300
./install_vms.sh $1
sleep 180
ssh $1 sudo /tmp/vmsetup/install_run_undercloud_cmds.sh $1
ssh $1 sudo /tmp/vmsetup/rem_introspection.sh
