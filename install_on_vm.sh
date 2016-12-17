#! /bin/bash -fv
#
# Install the scripts on a vm and make sure that all repos are updated
#
sed -i 's/requiretty/!requiretty/' /etc/sudoers
mkdir /tmp/vmsetup
cd /tmp/vmsetup
tar xvf /tmp/quick.tar
/tmp/vmsetup/script1.sh
