#!/bin/bash

# Import the Object
source object.sh

# Csv File
file="$HOME/Script/UsrMgmt/usrs/adduser.csv"
file1="$HOME/trans/recieved/adduser.csv" 

if [[ ! -f "$file" && ! -f "$file1" ]]; then
	echo "CSV File not found!!!"
else
	echo "Syncing the file..."
	#cp "$file1" "$file"
fi

# Line count
lineCount=$(cat $file | wc -l)

# Read the CSV file and create Server objects
for ((i = 2; i <= $lineCount; i++)); do

	# Get specific line base on itteration
	lineData=$(awk -v lnum="$i" 'NR == lnum  { print; exit }' $file)

	# Get specific ip section 
	ip=$(echo "$lineData" | awk -F, '{print $3}' | tr -d '[:space:]')
	
	un=$(echo "$lineData" | awk -F, '{print $2}' | tr -d '[:space:]')

	# Initialize the Object
	# Server [per line data] [admin user] [index]i [ip] [new user]
    #Server "$lineData" "carana" "$i" "$file" "$ip" "$un"

	# Use the Method 
   	#create_account 

done < "$file"


