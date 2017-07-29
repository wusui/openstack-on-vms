#!/bin/bash -fv
#
# Create the tls/ssl certificates.  Work around permissions issues.
#
HOME=/home/stack
export SECOND_IPADDR=192.0.2.2
openssl genrsa -out ca.key.pem 4096
openssl req  -key ca.key.pem -new -x509 -days 7300 -extensions v3_ca -out ca.crt.pem <<EOF
US
California
Los Angeles
Red Hat
Red Hat
${SECOND_IPADDR}
wusui@redhat.com
EOF
sudo cp ca.crt.pem /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust extract
openssl genrsa -out server.key.pem 2048
cp /etc/pki/tls/openssl.cnf .
ed openssl.cnf<<EOF
/# req_extensions =
s/.*/req_extensions = v3_req/
.
/countryName_default
s/.*/countryName_default = US/
.
/stateOrProvinceName_default
s/.*/stateOrProvinceName_default = California/
.
/localityName_default
s/.*/localityName_default = Los Angeles/
.
/0.organizationName_default
s/.*/0.organizationName_default = Red Hat/
.
/organizationalUnitName_default
s/.*/organizationalUnitName_default = Red Hat/
.
/commonName.*Common Name
a
commonName_default = ${SECOND_IPADDR}
.
/^keyUsage = 
a
subjectAltName = @alt_names

[alt_names]
IP.1 = ${SECOND_IPADDR}
DNS.1 = ${SECOND_IPADDR}
DNS.2 = instack.localdomain
DNS.3 = vip.localdomain
.
w
q
EOF
openssl req -config openssl.cnf -key server.key.pem -new -out server.csr.pem <<EOF











EOF
sudo chmod 0777 /etc/pki/CA/private
sudo cp ca.key.pem /etc/pki/CA/private/cakey.pem
sudo chmod 0777 /etc/pki/CA/newcerts
sudo touch /etc/pki/CA/index.txt
sudo chmod 0777 /etc/pki/CA
echo '14' > /etc/pki/CA/serial
openssl ca -config openssl.cnf -extensions v3_req -days 3650 -in server.csr.pem -out server.crt.pem -cert ca.crt.pem <<EOF
y
y
EOF
cat server.crt.pem server.key.pem > undercloud.pem
sudo mkdir /etc/pki/instack-certs
sudo cp ${HOME}/undercloud.pem /etc/pki/instack-certs/.
sudo semanage fcontext -a -t etc_t "/etc/pki/instack-certs(/.*)?"
sudo restorecon -R /etc/pki/instack-certs
ed undercloud.conf <<EOF
/#undercloud_service_certificate =
a
undercloud_service_certificate = /etc/pki/instack-certs/undercloud.pem
.
w
q
EOF
sudo cp ca.crt.pem /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust extract
sudo chmod 0700 /etc/pki/CA/private
sudo chmod 0755 /etc/pki/CA/newcerts
sudo chmod 0755 /etc/pki/CA
