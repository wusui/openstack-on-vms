#! /bin/bash -fv
#
# Perform ironic operationis after introspecition but prior to deploying the overcloud
#
HOME=/home/stack
function doit {
    OIFS=$IFS
    IFS=' '
    rm -rf /tmp/exec
    echo ${1} | sed "s/^/ironic node-update /" | sed "s/$/ ${2} ${3}/" > /tmp/exec
    chmod 0777 /tmp/exec
    /tmp/exec
    IFS=$OIFS
}

cd ${HOME}
source stackrc
ironic node-list | grep -v '\-\-+\-\-' | grep -v "| Provisioning State" | sed 's/^| //' | sed 's/ |.*//'> /tmp/ironic_file

for i in $(cat /tmp/ironic_file | sed -n 1,1p)
do
    doit $i "add" "properties\/capabilities='profile:control,boot_option:local'"
done
for i in $(cat /tmp/ironic_file | sed -n 2,4p)
do
    doit $i "add" "properties\/capabilities='profile:ceph-storage,boot_option:local'"
done
for i in $(cat /tmp/ironic_file | sed -n 5,5p)
do
    doit $i "add" "properties\/capabilities='profile:compute,boot_option:local'"
done

mkdir swift-data
cd swift-data
export IRONIC_DISCOVERD_PASSWORD=`sudo grep admin_password /etc/ironic-inspector/inspector.conf | egrep -v '^#'  | awk '{print $NF}' | awk -F'=' '{print $2}'`
for node in $(ironic node-list | grep -v UUID| awk '{print $2}')
do
    swift -U service:ironic -K $IRONIC_DISCOVERD_PASSWORD download ironic-inspector inspector_data-$node
done
ls -1
for node in $(ironic node-list | awk '!/UUID/ {print $2}')
do
    cat inspector_data-$node | jq '.inventory.disks'
done | grep serial | head -1 | sed 's/^ *//' > /tmp/root_disk1

for i in $(cat /tmp/ironic_file)
do
   doit $i "add" "properties\/root_device='{$(cat /tmp/root_disk1)}'"
done
