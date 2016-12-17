 
The scripts here create a 1 controller, 3 ceph node, 1 compute node cluster running as vms
on a single machine.

In order to get this to work, you must first create a file named secrets in this directory that
has the following in it:

subscrname=my_subscription_name@redhat.com
subscrpassword=my_subscription_password
gitid=my_gitlab.cee.redhat.com_id
gitpassword=my_gitlab.cee.redhat.com_password

Run ./build_openstack.sh magna0XX and wait a couple of hours.

After completion, one can ssh to the machine on which this script was run and do:

# sudo virsh list --all

to see the virtual machines.

# arp -an

displays the ip-address of the undercloud node on virbr0.

# sudo ssh stack@192.168.122.200 (or whatever ip address was shown by the arp -an command)

You can verify that you are on an new network with hostname

# hostname
# source stackrc
# nova list
# source overcloudrc 
# ssh heat-admin@192.0.2.12

At this point, you should be on the controller node.  Verify that this is correct by running.

# sudo ceph health
