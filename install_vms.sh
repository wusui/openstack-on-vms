#! /bin/bash -fv
#
# Run scripts on the remote site so that the vms get created
#
ssh $1 sudo /tmp/vmsetup/make_vms.sh
ssh $1 sudo /tmp/vmsetup/make_iso.sh $1
ssh $1 sudo /tmp/vmsetup/ansible_run.sh $1
ssh $1 sudo /tmp/vmsetup/just_before_we_run_vm.sh
