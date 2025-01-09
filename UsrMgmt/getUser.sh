#!/bin/bash

# Import the Object
source object1.sh

# Csv File
file="file/bancsServers"
sandbox="/media/sf_Linux/sandbox/bancsUsers.csv"

if [[ ! -f "$file" ]]; then
	echo "CSV File not found!!!"
	exit 1
fi

# Temporary variable for loop
lineCount=$(cat $file | wc -l)

#Initialize the object
Server "172.16.88.9" "carana"

gen_users_rep

exit 1
# Loop through the list of server
for ((i = 1; i <= $lineCount; i++)); do
	# Get server IP
	serverIp=$(awk -v lnum="$i" 'NR == lnum  { print; exit }' $file)

	#Initialize the object
	Server
done < "$file"
