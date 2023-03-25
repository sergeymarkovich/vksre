#!/bin/bash

# создание логического тома
sudo lvcreate -L 30G -n var vgKVM

# создание файловой системы для логического тома
sudo mkfs.ext4 /dev/vgKVM/var

# создание точки монтирования и сохранение при перезагрузке в файле /etc/fstab
sudo echo '/dev/vgKVM/var /var ext4 defaults 0 0' >> /etc/fstab
#defaults - опции монтирования
# 0 0 - параметры дампа и проверки файловой системы

# монтирование точки
sudo mount /var
