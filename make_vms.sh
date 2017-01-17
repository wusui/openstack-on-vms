#! /bin/bash -fv
#
# Install ansible. git and genisoimage.  Create files needed to run ansible script
#
sudo yum-config-manager --enable epel
sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y
sudo yum install python-devel -y
sudo yum install python-pip libffi-devel openssl-devel gcc -y
sudo pip install --upgrade pip
sudo pip install ansible
ansible --version
mkdir -p /root/ansible/{roles,inventories/virt-env-ospd,playbooks/virt-env-ospd/files/{ospd7,ospd8}} ; cd /root/ansible
MYMACHINE=`hostname -s`
MYIP=`hostname -i`
cat << EOF > inventories/virt-env-ospd/hosts
[hypervisor]
${MYMACHINE} ansible_host=${MYIP}

[undercloud]
EOF
cat << EOF > ansible.cfg
[defaults]
host_key_checking = False
roles_path = ./roles
EOF
touch playbooks/virt-env-ospd/env1.yml
sudo yum install git -y
sudo yum install genisoimage -y
source /tmp/vmsetup/secrets
export GIT_SSL_NO_VERIFY=false ; git clone https://${gitid}:${gitpassword}@gitlab.cee.redhat.com/RCIP/virt-env-ospd.git roles/virt-env-ospd
