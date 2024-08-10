#!/bin/bash

: ' 
TO DO:
[done] create an array for th line that need to comment out.
[done] get the length of the json
[done] loop through the json variable
[done] create a condition if the pattern is starts with # uncomment else comment
[done] prompt to apply changes 
'
#error checking
if [ -z "$1" ] || [ -z "$2" ]; then
	echo " "  
	echo "ERROR: Incomplete Parameter!"
	echo " "  
	exit 1
fi

#JSON data
cron_pattern='[
    {
        "job": "13 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root stoprcconsistgrp -access BANCS_DR_MIRROR"
    },
    {
        "job": "14 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root prestartfcconsistgrp BANCS_DR"
    },
    {
        "job": "15 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startfcconsistgrp BANCS_DR"
    },
    {
        "job": "16 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startrcconsistgrp -primary master -force BANCS_DR_MIRROR"
    },
    {
        "job": "43 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root stoprcconsistgrp -access BANCS_DR_MIRROR"
    },
    {
        "job": "44 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root prestartfcconsistgrp BANCS_DR"
    },
    {
        "job": "45 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startfcconsistgrp BANCS_DR"
    },
    {
        "job": "46 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startrcconsistgrp -primary master -force BANCS_DR_MIRROR"
    },
    {
        "job": "58 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root stoprcconsistgrp -access BANCS_DR_MIRROR"
    },
    {
        "job": "59 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root prestartfcconsistgrp BANCS_DR"
    },
    {
        "job": "00 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root startfcconsistgrp BANCS_DR"
    },
    {
        "job": "01 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root startrcconsistgrp -primary master -force BANCS_DR_MIRROR"

    },
    {
        "job": "28 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root stoprcconsistgrp -access BANCS_DR_MIRROR"
    },
    {
        "job": "29 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root prestartfcconsistgrp BANCS_DR"
    },
    {
        "job": "30 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root startfcconsistgrp BANCS_DR"
    },
    {
        "job": "31 * * * * ssh fcmap2@192.168.167.22 -i /root/.ssh/root startrcconsistgrp -primary master -force BANCS_DR_MIRROR"
    }
]'

USER=$1
SERVER=$2

# Backup current crontab
ssh $USER@$SERVER 'sudo crontab -l' > crontab_backup.txt

echo -e "\nConnected as $USER@$SERVER..."

# Get the length from the json variable
jobCount=$(echo "$cron_pattern" | jq '. | length')

#this loop is to eterate to each job(key) instance from the json variable
for (( i = 0; i < ${jobCount}; i++ )); do
	
	#this is to store the job key value into a variable
	# - tonumber is to convert the num into a integer
	CRON_JOB=$(echo "$cron_pattern" | jq -r --arg k "job" --arg num "$i" '.[($num | tonumber)] | "\(.[$k])"')

	#escaped the special charater to avoid error on sed command
	escaped_variable=$(printf '%s' "$CRON_JOB" | sed 's/[_.*@/-]/\\&/g')

	#Condition if the that needs to comment or uncomment
	if grep -q "^#${escaped_variable}" crontab_backup.txt; then	
		#sed to uncomment out the job	
		sed -i "/${escaped_variable}/s/^#//" crontab_backup.txt 
	else
		#sed to comment out the job	
		sed -i "s/^${escaped_variable}/#&/" crontab_backup.txt 
	fi
done

#transfer to the server the edited cron format
scp -q crontab_backup.txt $USER@$SERVER:/home/$USER

#FILE PREVIEW
#======================================================
file="crontab_backup.txt"

# Read the content of the file
file_content=$(cat "$file")

# Calculate the maximum length of any line in the file
max_length=$(awk '{ if ( length > L ) { L = length } } END { print L }' "$file")

# Create the top and bottom borders
top_border=$(printf '┌%*s┐' "$((max_length + 2))" "" | tr ' ' '─')
bottom_border=$(printf '└%*s┘' "$((max_length + 2))" "" | tr ' ' '─')

# Print the top border
echo "$top_border"

# Print the file content with side borders
while IFS= read -r line; do
  printf "│ %-*s │\n" "$max_length" "$line"
done < "$file"

# Print the bottom border
echo "$bottom_border"
#======================================================

# Prompt user for confirmation
echo " "
read -p "Do you want to apply the Cron job changes? (yes/no): " confirm

# Convert the user input to lowercase
confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

# Check user's confirmation
if [[ "$confirm" = "yes" || "$confirm" = "y" ]]; then
	#execute siries of command inside the target server
	ssh $USER@$SERVER "sudo bash -s" << 'EOF'
	# Create a temporary file
	TEMP_CRON=$(mktemp)

	#apply the changes to temp file
	cat crontab_backup.txt > "$TEMP_CRON" 

	# Install the new crontab
	crontab "$TEMP_CRON"
	echo "Aplying changes..."

	# Remove the temporary file
	rm "$TEMP_CRON"
	rm crontab_backup.txt
EOF
	rm crontab_backup.txt
elif [[ "$confirm" = "no" || "$confirm" = "n" ]]; then
	echo "Changes discarded..."
	rm crontab_backup.txt
	exit 1
else
	echo "Invalid input. Please enter 'yes' or 'no'."
	exit 1
fi

echo -e "Cron job modified!.\n"

ssh $USER@$SERVER 'sudo crontab -l' 

