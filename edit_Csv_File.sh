#!/usr/bin/sh

echo "Writing to csv file..."
# import customize function 
source $HOME/Script/Function.sh

#MainFile
varData="$HOME/Documents/SOD_EOD/SOD_EOD_System_Monitoring.csv"

#stores total length for the line inside the file
varLineCount=$(cat $varData | wc -l)

#Loop for every line inside the file
for ((i = 1; i <= $varLineCount; i++)); do
	#this will store details per line
	a=$(awk -v lnum="$i" 'NR == lnum  { print; exit }' $varData)

	#store row ID
	varid=$(echo $a | awk -F',' '{print $1}')
	
	#condtion to check if it is belong to Server Group
	if [[ "$varid" == "Server" || "$varid" == "Storage"  ]]; then
		#this will create new content or updated data
		new_content=$(echo $a | awk -F',' -v newTime="$1" '{print $1","$2","newTime,","$4","$5}')
	
		#This will escape the special charcter inside the variable
		escaped_variable=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
	
		#this will alter the line 
		sed -i "${i}s/.*/${escaped_variable}/" "$varData"
	fi
done

echo "Trasfering to windows machine..."
trans smu

: '
TO DO:
[done] Loop through each line of the file
[done] Get the specific id/line number of server related section
[done] Condition to check if it is belong to server Team
[done] Generate new line content 
[done] Escape the special character for sed command to work 
[done] replace the line with new output 

'
