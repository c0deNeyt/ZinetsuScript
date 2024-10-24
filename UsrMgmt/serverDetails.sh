#!/bin/bash

# Import the Object
source object.sh

# Csv File
file="usrs/ip.csv"
sandbox="/media/sf_Linux/sandbox/ip.csv"

if [[ ! -f "$file" && ! -f "$file1" ]]; then
	echo "CSV File not found!!!"
	exit 1
else
	cp "$sandbox" "$file"
fi

# Temporary variable for loop
lineCount=$(cat $file | wc -l)

# Read the CSV file and create Server objects
for ((i = 2; i <= $lineCount; i++)); do

	# Get specific line base on itteration
	lineData=$(awk -v lnum="$i" 'NR == lnum  { print; exit }' $file)

	# Get specific ip section 
	ip=$(echo "$lineData" | awk -F, '{print $1}' | tr -d '[:space:]')
	
	# Initialize the Object
	# Server [per line data] [admin user] [index]i [ip]
    Server "$lineData" "carana" "$i" "$file" "$ip"

	# Use the Method 
    check_server

done < "$file"

cp "$file" "$sandbox" 
