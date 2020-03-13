#!/bin/bash

# This basically follows the instructions on this blog
# https://medium.com/hepsiburadatech/setup-elasticsearch-7-x-cluster-on-raspberry-pi-asus-tinker-board-6a307851c801

USER=$1
HOST=$2

if [ "$#" -ne 2 ]; then
    echo "Usage: ./init.sh {user} {rpi hostname}"
    exit 1;
fi
echo $#

echo "$USER $HOST"

################################
# Harden the Root User
################################
sudo su
echo "Set sudo password for root\n"
passwd

################################
# Get latest
################################
apt-get -y update
apt-get -y upgrade

################################
# Reset Hostname
################################
echo "$HOST\n" > /etc/hostname

################################
# User Creation
################################

useradd $USER
echo "Set password for your user\n"
passwd $USER
usermod -aG sudo $USER

# ################################
# # Java Install / config
# ################################
apt-get install -y openjdk-11-jdk
apt-get install -y vim
echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf' > /etc/environment

# ################################
# # ES Install / config
# ################################
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.3.2-no-jdk-amd64.deb
dpkg -i --force-all --ignore-depends=libc6 elasticsearch-7.3.2-no-jdk-amd64.deb

sed -i 's/ half-configured/ installed/g' /var/lib/dpkg/status
sed -i 's/ libc6, adduser/ adduser/' /var/lib/dpkg/status

apt-get upgrade

# echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf' >> /etc/default/elasticsearch
cp elasticsearch/etc_default_elasticsearch /etc/default/elasticsearch
cp elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

chmod -R g+w /etc/elasticsearch
chmod -R g+w /var/log/elasticsearch

systemctl enable elasticsearch
systemctl start elasticsearch
