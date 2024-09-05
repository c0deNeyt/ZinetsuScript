#!/bin/bash

#this condition is added for the reason no lsnode command in 192.168.67.12
if [ "$2" != "192.168.67.12" ]; then
	varNode="$(ssh $1@$2 'lsnode -delim :')"
fi
varDrive="$(ssh $1@$2 'lsdrive -delim :')"
varDisk="$(ssh $1@$2 'lsmdisk -delim :')"

#function to get the field number of status
function getStatFiled(){
	echo -e "\n$1" | \
	awk -F':' '{
		col = 0
		for (i = 1; i <= NF; i++) {
			if ( $i == "status" && !col) {
				col += i
				print col
			}
		}
}'  
}
#function to get the final status
checkStatus() {
    local varName="$1"  # First argument is the variable (Drive or Disk)
    local fieldNum  # Field number to be retrieved
    fieldNum=$(getStatFiled "$varName")  # Get the field number based on the variable
    echo -e "\n$varName" | \
    awk -F':' -v fnum="$fieldNum" '{ print $fnum }' | \
    tail -n +3
}

# Checking Node Status
if [ "$varNode" ]; then
	checkStatus "$varNode"
fi

# Checking Drive Status
checkStatus "$varDrive"

# Checking Disk Status
checkStatus "$varDisk"

: '
TODO:
[done] get the field number of status 
[done] create a function to get the final status 
[done] accept server ip and run command
'
