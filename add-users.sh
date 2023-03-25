#!/bin/bash

# add users
sudo adduser d.alexeev --force-badname --disabled-password --gecos ""
sudo adduser s.ivannikov --force-badname --disabled-password --gecos ""

# add pass
echo "d.alexeev:d.alexeev" | sudo chpasswd
echo "s.ivannikov:s.ivannikov" | sudo chpasswd

sudo passwd $(PASSWORD_D) d.alexeev
sudo passwd $(PASSWORD_S) s.ivannikov

# generate ssh keys
sudo -u d.alexeev ssh-keygen -t rsa -b 4096 -C "d.alexeev@myserver.com" -f /home/d.alexeev/.ssh/id_rsa -N ""
sudo -u s.ivannikov ssh-keygen -t rsa -b 4096 -C "s.ivannikov@myserver.com" -f /home/s.ivannikov/.ssh/id_rsa -N ""

# add users in sudo group
sudo usermod -aG sudo d.alexeev
sudo usermod -aG sudo s.ivannikov
