#!/bin/bash

# Import the Object
source object.sh

# Workstation Csv File
sandbox="/media/sf_Linux/sandbox/Linux_Rouge.csv"

if [[ ! -f "$sandbox" ]]; then
	echo "CSV File not found!!!"
else
	cp "$sandbox" "resource/"
fi

# VM Csv File
file="resource/Linux_Rouge.csv"
spinner(){
	# Run a command (e.g., scp) in the background
	pid=$!

	# Define a spinner animation
	spin[0]="-"
	spin[1]="\\"
	spin[2]="|"
	spin[3]="/"

	# Display the spinner while the process is running
	echo -n  -e "[Generating Result...] \n ${spin[0]}"
	while kill -0 $pid 2> /dev/null; do
		for i in "${spin[@]}"; do
			echo -ne "\b$i"
			sleep 0.1
		done
	done
	echo -e "Done...!"
}

# Temporary variable for loop
lineCount=$(cat $file | wc -l)

# Read the CSV file and create Server objects
for ((i = 2; i <= $lineCount; i++)); do

	# Get specific line base on itteration
	lineData=$(awk -v lnum="$i" 'NR == lnum  { print; exit }' $file)

	# Get specific ip section 
	ip=$(echo "$lineData" | awk -F, '{print $3}' | tr -d '[:space:]')
	
	# Initialize the Object
	# Server [per line data] [iteration index] [user admin]
   	Server "$lineData" "$i" "carana"

	# Use the Method 
    check_server 
	
done < "$file" & spinner

cp "$file" "$sandbox" 
