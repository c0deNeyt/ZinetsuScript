#!/usr/bin/sh

sudo nohup tar -cpzf /home/carana/systemBackup$(date +%F).tar.gz /etc /var /home /root /usr/local /opt /boot /lib /lib64 /bin /sbin/usr/bin /usr/sbin/  /var/lib /dev &>/dev/null &
