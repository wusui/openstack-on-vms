#! /bin/bash -fv
mkdir /tmp/vmsetup
cd /tmp/vmsetup
cp /tmp/quick.tar .
tar xvf quick.tar
sudo chmod 0755 /tmp/vmsetup
sudo /tmp/vmsetup/makeuserstack.sh <<EOF
stack
stack
EOF
sudo /tmp/vmsetup/makemyssh.sh <<EOF



EOF
su --command=/tmp/vmsetup/makemyssh.sh stack <<EOF
stack



EOF
sudo /tmp/vmsetup/script1.sh
