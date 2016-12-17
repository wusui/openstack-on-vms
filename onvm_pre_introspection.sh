#! /bin/bash -fv
HOME=/home/stack
cd ${HOME}
source stackrc
export X=`cat /tmp/hostnamei`
OIFS=$IFS
IFS='%'
JSONFILE=`cat /tmp/vmsetup/instackenv.orig.json | sed "s/10.8.128./$X/"`
export wz=`sudo sed ':a;N;$!ba;s/\n/\\\\n/g' /root/.ssh/id_rsa`
rm instackenv.json
for x in $JSONFILE; do
    echo -n $x;
    echo -n $wz;
done > instackenv.json
ed instackenv.json <<EOF
$
d
a
}
.
w
q
EOF
IFS=$OIFS
openstack baremetal import --json ${HOME}/instackenv.json
openstack baremetal configure boot
ironic node-list
openstack baremetal introspection bulk start
