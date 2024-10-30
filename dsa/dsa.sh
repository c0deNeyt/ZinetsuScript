#!/bin/bash

# Import the object
source object_dsa.sh

# Object instance	
Dsa
serverList="resources/serverList" 
logFile="resources/logfile.log" 

# Check the availability of file
if [[ ! -f "$serverList" ]]; then
	get_log "$0 line ${LINENO}:: File $serverList not found." "$logFile"
	exit 1
fi
if [[ ! -f "$logFile" ]]; then
	get_log "$0 ${LINENO}:: File $logFile not found." "$logFile"
	exit 1
fi
# check the availability of param
if [[ ! "$1" ]]; then
	get_log "$0 ${LINENO}:: Missing parameter (eg. ./dsa.sh admin)." "$logFile"
	exit 1
fi


#function to run dsa
function runDsa(){
	if is_ibm_utl "$1"; then
		if get_dsa "$1"; then
			get_log "$0 Line ${LINENO}:: dsa at $2 Sucess!" "$logFile"
		else 
			get_log "$0 Line ${LINENO}:: dsa Failed!" "$logFile"
		fi
	else
		get_log "$0 Line ${LINENO}:: IBM utils not found!" "$logFile"
	fi
}

# Temporary variable for loop
lineCount=$(cat "$serverList" | wc -l)

# Read the CSV file and create Server objects
for (( i=1; i <= $lineCount; i++ )); do 

	# Get specific line base on itteration
	lData=$(awk -v lnum="$i" 'NR==lnum' $serverList)

	# Object instance	
	Dsa "$lData" "$1"

	# Method instance	
	if ! is_pingable; then
		get_log "$0 line ${LINENO}:: Can't ping $lData" "$logFile"
		continue # break iteration and proceed to the next
	fi

	# Method instance	
	if is_port_open 22; then
		if user_exists; then
			#echo "User $1@$lData found!"	
			runDsa "22" "$lData" 
		else
			get_log "$0 line ${LINENO}:: $1@$lData unavailable."  "$logFile"
		fi
	elif is_port_open 222; then
		if user_exists 222; then
			#echo "User $1@$lData found!"	
			runDsa "222" "$lData"
		else
			get_log "$0 line ${LINENO}:: $1@$lData unavailable."  "$logFile"
		fi
	elif is_port_open 3389; then
		get_log "$0 line ${LINENO}:: $lData Port 3389 is open (Windows)"  "$logFile"
	else
		get_log "$0 line ${LINENO}:: $lData No relevant ports are open" "$logFile"
		continue # break iteration and proceed to the next
	fi
done & spinner

: '
TODO:
[done]	Create a list of server the at needs to run dsa 
[done]	Loop through the list of server
[done]	Check if the server is pingable 
[done]	create logfile function	
[done]	Check if the what port is available
[done]	Inside the loop idendtfy if admin exist 
[done] 	Check if ibm_utl exist	
[done] 	Run the dsa 
'

