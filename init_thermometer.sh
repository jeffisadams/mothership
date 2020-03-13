#!/bin/bash

# This basically follows the instructions on this blog
# https://medium.com/hepsiburadatech/setup-elasticsearch-7-x-cluster-on-raspberry-pi-asus-tinker-board-6a307851c801

USER=$1
HOST=$2
LOCATION=$3
ES_HOST=$4

if [ "$#" -ne 2 ]; then
    echo "Usage: ./init.sh {user} {rpi hostname} {room} {ES host}"
    exit 1;
fi
echo $#

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
mkdir /home/$USER
chown $USER:$USER /home/$USER

sudo su $HOST

sed -i s/{location}/$LOCATION/ ./getTemp.py
sed -i s/{es_host}/$ES_HOST/ ./getTemp.py

cp ./getTemp.py /home/$USER/

# This part isn't done yet.
echo "*/5 * * * * /home/$USER/getTemp.py 11 4"