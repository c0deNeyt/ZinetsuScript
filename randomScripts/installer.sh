#!/usr/bin/sh

#sudo yum -y udpate
#sudo yum install -y make gcc perl-core pcre-devel wget zlib-devel
wget https://ftp.openssl.org/source/openssl-3.1.1.tar.gz --no-check-certificate
sudo tar -xzvf openssl-3*.tar.gz
cd openssl-3*
.config --prefix=/usr --openssldir=/etc/ssl --libdir=lib no-shared zlib-dynamic
sudo make -j ${nproc}
sudo make test
sudo make install -j ${nproc}
echo "export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64" >> /etc/profile.d/openssl.sh
source /etc/profile.d/openssl.sh
openssl version

