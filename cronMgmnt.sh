#!/bin/bash

: ' 
TO DO:
[done] create an array for th line that need to comment out.
[done] get the length of the json
[done] loop through the json variable
[] create a condition if the patter is starts with # uncomment else comment
'

#JSON data
cron_pattern='[
    {
        "id": 1,
        "job": "13 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root stoprcconsistgrp -access BANCS_DR_MIRROR"
    },
    {
        "id": 2,
        "job": "14 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root prestartfcconsistgrp BANCS_DR"
    },
    {
        "id": 3,
        "job": "15 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startfcconsistgrp BANCS_DR"
    },
    {
        "id": 4,
        "job": "16 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startrcconsistgrp -primary master -force BANCS_DR_MIRROR"

    },
    {
        "id": 5,
        "job": "43 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root stoprcconsistgrp -access BANCS_DR_MIRROR"
    },
    {
        "id": 6,
        "job": "44 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root prestartfcconsistgrp BANCS_DR"
    },
    {
        "id": 7,
        "job": "45 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startfcconsistgrp BANCS_DR"
    },
    {
        "id": 8,
        "job": "46 * * * * ssh fcmap@192.168.167.22 -i /root/.ssh/root startrcconsistgrp -primary master -force BANCS_DR_MIRROR"
    }
]'

# Backup current crontab
crontab -l > crontab_backup.txt

# Get the length from the json variable
jobCount=$(echo "$cron_pattern" | jq '. | length')

#this loop is to eterate to each job(key) instance from the json variable
for (( i = 0; i < ${jobCount}; i++ )); do
	
	#this is to store the job key value into a variable
	# - tonumber is to convert the num into a integer
	CRON_JOB=$(echo "$cron_pattern" | jq -r --arg k "job" --arg num "$i" '.[($num | tonumber)] | "\(.[$k])"')

	#escaped the special charater to avoid error on sed command
	escaped_variable=$(printf '%s' "$CRON_JOB" | sed 's/[_.*@/-]/\\&/g')

	#sed to comment out the job	
	sed -i "s/^${escaped_variable}/#&/" crontab_backup.txt 

	#sed to uncomment out the job	
	#sed -i "/${escaped_variable}/s/^#//" crontab_backup.txt 
done

# Create a temporary file
TEMP_CRON=$(mktemp)

#apply the changes to temp file
cat crontab_backup.txt > "$TEMP_CRON" 

# Install the new crontab
crontab "$TEMP_CRON"

# Remove the temporary file
rm "$TEMP_CRON"

echo "Cron job commented out."

