#!/bin/bash

# Import the Object
source object.sh
source $HOME/Script/ssh.sh 

# Prompt for the admin username
read -p "Enter the admin username: " srvadm

# Optional: confirm the username or exit if empty
if [[ -z "$srvadm" ]]; then
    echo "No username provided. Exiting."
    exit 1
fi

# Loop through a list of server that is sourced on ssh.sh 
for key in  ${!srvIP[@]}
do
	SERVER_IP=${srvIP[$key]}
	Server "$SERVER_IP" "$srvadm"  
	check_internal_DNS & spinner $SERVER_IP
done

exit 1

: '
TO DO: ✅ 
	* Connect to the servers. 
	* check the  server if it is using Internal DNS 
	*
'
