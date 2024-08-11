#!/bin/bash

USER="carana"
SERVER="192.168.167.22"

ssh -t "$USER@$SERVER" 'lsrcconsistgrp' 2>/dev/null > tempGrp


# Function to print a table row
print_row() {
    printf "| %-15s | %-23s |\n" "$1" "$2" 
}

# Function to print a separator
print_separator() {
    printf "+-----------------+-------------------------+\n"
}
echo "========================================================"
echo "Consistency Group Status..."
varName="$(cat tempGrp | awk 'NR==1 {print $2}')"
varState="$(cat tempGrp | awk 'NR==1 {print $8}')"
varD="$(cat tempGrp | awk 'NR==2 {print $2}')"
varD1="$(cat tempGrp | awk 'NR==2 {print $8}')"

# Table header
print_separator
print_row $varName $varState
print_separator

# Table rows
print_row "$varD" "$varD1" 
print_separator

echo " "
if [[ $varD1 == "consistent_synchronized" ]];
then 
	echo "Consisted and Sycronized!"
	./v6CronHash.sh
	echo "Setting allow read and write access!"
	echo "Stopping consistency group..."
	ssh -t "$USER@$SERVER" 'svctask stoprcconsistgrp -access 0'

	echo "Starting Flash Copy..."
	#ssh -t "$USER@$SERVER" 'svctask startfcconsistgrp -prep 1 DR_MIRROR_FC'
else
	echo "Unconsistent and Unsynchronized!"	
	./v6CronHash.sh
	ssh -t "$USER@$SERVER" 'svctask startrcconsistgrp -force -primary master 0'
fi
