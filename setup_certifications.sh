#!/bin/bash -fv
#
# Create the tls/ssl certificates if ceatecertuser is set in secrets file.
# Work around permissions issues.
#
HOME=/home/stack
sudo yum install -y python-tripleoclient
cp /usr/share/instack-undercloud/undercloud.conf.sample ${HOME}/undercloud.conf
source /tmp/vmsetup/secrets
if [ ! -z ${createcertuser+x} ]; then
    /tmp/vmsetup/create_cert_user.sh
fi
