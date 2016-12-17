#! /bin/bash -fv
cd ~
mkdir .ssh
chmod 0700 .ssh
cd .ssh
ssh-keygen -t rsa
cp id_rsa.pub authorized_keys
