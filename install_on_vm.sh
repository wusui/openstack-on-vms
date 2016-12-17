#! /bin/bash -fv
sed -i 's/requiretty/!requiretty/' /etc/sudoers
mkdir /tmp/vmsetup
cd /tmp/vmsetup
tar xvf /tmp/quick.tar
/tmp/vmsetup/script1.sh
