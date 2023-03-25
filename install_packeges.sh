#!/bin/bash

# mount iso media
sudo mkdir /media/temp
sudo mount -o loop /dev/cdrom /media/temp

# install packages
sudo dpkg -i /media/temp/bird-bgp_168-1_all.deb
sudo dpkg -i /media/temp/bird_168-1_amd64.deb
sudo dpkg -i /media/temp/libsensors5_360-2ubuntu1_a.deb
sudo dpkg -i /media/temp/libsensors-config_360-2ubu.deb
sudo dpkg -i /media/temp/libmysqlclient21_8032-1ubu.deb
sudo dpkg -i /media/temp/libsnmp35_58+dfsg-2ubuntu2.deb
sudo dpkg -i /media/temp/libsnmp-base_58+dfsg-2ubun.deb
sudo dpkg -i /media/temp/libwrap0_76q-30_amd64.deb
sudo dpkg -i /media/temp/lldpd_104-1build2_amd64.deb
sudo dpkg -i /media/temp/mysql-client-80_8019-0ubun.deb
sudo dpkg -i /media/temp/mysql-client-core-80_8019-.deb
sudo dpkg -i /media/temp/mysql-community-client-plu.deb
sudo dpkg -i /media/temp/mysql-common_8032-1ubuntu2.deb
sudo dpkg -i /media/temp/net-tools_160+git20180626a.deb

if [ $? -eq 0 ]; then
  echo "Установка завершена успешно"
  sudo umount /media/temp
else
  echo "Установка завершена с ошибками"
fi
