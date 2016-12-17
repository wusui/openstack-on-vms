#! /bin/bash -fv
#
# copy scripts onto the remote machine
# execute install_do.sh on the remote machine
#
machine=${1:-'magna199'}
tar cvf /tmp/quick.tar .
scp /tmp/quick.tar ${machine}:/tmp/quick.tar
scp install_do.sh ${machine}:/tmp/install_do.sh
ssh ${machine} /tmp/install_do.sh
