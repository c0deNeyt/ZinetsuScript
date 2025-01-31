#!/bin/bash

# Import the Object
source object1.sh

# Csv File
file="file/bancsServers.txt"

#Condition to check if the file exist
if [[ ! -f "$file" ]]; then
	echo "CSV File not found!!!"
	exit 1
fi

# Loop through the list of server
for ip in $(cat file/bancsServers.txt); do
	# Remove carriage returns (for files created on Windows)
	serverIp=$(echo "$ip" | tr -d '\r')  

	#Initialize the object
	Server "$serverIp" "carana" 
	
	#Method instance with and spinner for loading animation
	gen_users_rep & spinner "$ip"
done 

: ' 
Information:
This script addapting object oriented pattern,
where in the actual script is sourcing a object file
which contains functions/instruction.

This Script is used to retrive a users and roles from 
the list of server 
'
