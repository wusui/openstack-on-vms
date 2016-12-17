#! /bin/bash -fv
HOME=/home/stack
cd /root
mkdir .ssh
chmod 0700 .ssh
cd .ssh
ssh-keygen -t rsa
cd ${HOME}
mkdir .ssh
chmod 0700 .ssh
chown stack:stack .ssh
cd .ssh
ssh-keygen -f id_rsa -t rsa
chown stack:stack id_rsa
chown stack:stack id_rsa.pub
