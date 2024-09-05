#!/usr/bin/sh

#error checking
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
	echo " "  
	echo "ERROR: Incomplete Parameter!"
	echo " "  
	exit 1
fi

#echo "Writing to csv file..."
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
	varid=$(echo $a | awk -F',' '{print $2}')
	#condtion to check if it is belong to Server Group
	#if [[ "$varid" == "Server" || "$varid" == "Storage"  ]]; then
	if [[ "$varid" == "$4" ]]; then
		#this will create new content or updated data
		new_content=$(echo $a | awk -F',' -v srvGrp="$4" -v newTime="$1" -v srvAdm="$2" -v varStat="$3" '{print $1","srvGrp","newTime","srvAdm","varStat}')

		#This will escape the special charcter inside the variable
		escaped_variable=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
		#this will alter the line 
		sed -i "${i}s/.*/${escaped_variable}/" "$varData"
	fi
done
: '
TO DO:
[done] check if the Server Group is the same if yes write to the csv 
[done] Loop through each line of the file
[done] Get the specific id/line number of server related section
[done] Condition to check if it is belong to server Team
[done] Generate new line content 
[done] Escape the special character for sed command to work 
[done] replace the line with new output 

'
