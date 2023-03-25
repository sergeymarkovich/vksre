#!/bin/bash

# очищаем все правила 
sudo iptables -F

# запрещаем все входящие и исходящие соединения
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# разрешаем входящий трафик из подсети 192.168.0.0/16
sudo iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT

# отклоняем входящий трафик ICMP
sudo iptables -A INPUT -p icmp -j REJECT --reject-with icmp-port-unreachable

# сохранение правил
sudo iptables-save > /etc/iptables/rules.v4

# запуск iptables-persistent тобы сохранить правила после перезагрузки
sudo systemctl start iptables-persistent.service
