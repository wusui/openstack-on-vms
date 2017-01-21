#!/bin/bash -fv
sudo EDITOR=ed virsh edit ${1} <<EOF
/cpu mode
s/model/passthrough/
.
w
q
EOF
