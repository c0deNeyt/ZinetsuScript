#!/bin/bash

: ' 
TO DO:
[done] create an array for th line that need to comment out.
[done] get the length of the json
[done] loop through the json variable
[done] create a condition if the pattern is starts with # uncomment else comment
'
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

	#Condition if the that needs to comment or uncomment
	if grep -q "^#${escaped_variable}" crontab_backup.txt; then	
		#sed to uncomment out the job	
		sed -i "/${escaped_variable}/s/^#//" crontab_backup.txt 
	else
		#sed to comment out the job	
		sed -i "s/^${escaped_variable}/#&/" crontab_backup.txt 
	fi
done

# Create a temporary file
TEMP_CRON=$(mktemp)

#apply the changes to temp file
cat crontab_backup.txt > "$TEMP_CRON" 

# Install the new crontab
crontab "$TEMP_CRON"

# Remove the temporary file
rm "$TEMP_CRON"
rm crontab_backup.txt

echo "Cron job commented out."

