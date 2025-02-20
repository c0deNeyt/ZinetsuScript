#!/bin/bash

# Import the Object
source object1.sh

# Check if a username is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

# Csv File
FILE="file/targetServers"

#Condition to check if the file exist
if [[  -f "$FILE" ]]; then
	# Loop through the list of server
	while IFS= read -r ip; do
		# Remove carriage returns (for files created on Windows)
		serverIp=$(echo "$ip" | tr -d '\r')
		# Initialization of object
		Server "$serverIp" "carana" "$1"
		#Method instance with and spinner for loading animation
		remove_account & spinner "$serverIp"

	done < "$FILE"
else
	echo "CSV File not found!!!"
fi


: ' 
TO DO:
	* check the account of the user if exist.
	* If account exist
'
