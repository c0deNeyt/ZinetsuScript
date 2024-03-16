#!/usr/bin/sh

echo "Script Executed...."
echo " "
sudo nmcli connection modify ens32 ipv4.addresses $1/24 ipv4.gateway 192.168.168.1 ipv4.dns 8.8.8.8 ipv4.method manual
sleep 1
echo "Disconnecting..."
echo " "
sleep 1
sudo nmcli dev  disconnect ens32
echo " "
sleep 1
echo "Network disconected.. "
sleep 1
echo "Connecting..."
echo " "
sudo nmcli con up ens32
sleep 1 
echo " "
echo "Sctipt Ended."
echo " "
