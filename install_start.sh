#! /bin/bash -fv
#
# copy scripts onto the remote machine
# execute install_do.sh on the remote machine
#
source ./secrets
machine=${1:-'magna199'}
tar cvf /tmp/quick.tar .
scp /tmp/quick.tar ${octoname}@${machine}:/tmp/quick.tar
scp install_do.sh ${octoname}@${machine}:/tmp/install_do.sh
ssh ${octoname}@${machine} /tmp/install_do.sh
