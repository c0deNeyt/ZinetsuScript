#!/bin/bash


# Workstation Csv File
sentinelone="/opt/sentinelone/bin/sentinelctl"
if [[ ! -f "$sentinelone" ]]; then
	echo "Sentinel not found!"
else
	sudo stat $sentinelone |  awk 'END {split($3, x, ":"); print $2, x[1] ":" x[2]}' 
fi
