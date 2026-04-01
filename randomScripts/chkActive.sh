#!/bin/env bash

IPLIST=./masterInventory.csv

COUNT=0
while IFS=, read -r int desc status vlan mac ip active; do
	if [[ $COUNT == 0 ]]; then
		(( COUNT++ ))
		continue
	fi
	(( COUNT++ ))
	echo pinging $ip...
	ping -4 -c4 -W1.5 "$ip" > tmpPingRes
	#Cheking if there is packet loss or ping discrepancy
	varCurStat=$(cat tmpPingRes | grep "packet loss" | awk -F',' '{print $3}' | awk '{print $1}')
	#checking if the pocket capture if not greater than 99% or string
	# Check if varCurStat is a valid number
	varCurStatNum="${varCurStat%\%}"
	if [[ "$varCurStatNum" =~ ^-?[0-9]+$ ]]; then
		if [[ $varCurStatNum -ge 0 ]] && [[ $varCurStatNum -lt 100 ]]; then
			varStatus="YES"
		else
			varStatus="NO"
		fi
	else
		varStatus="YES"
	fi
	echo Updating line $COUNT
	sed -i "${COUNT}s/,[^,]*$/,${varStatus}/" $IPLIST
	echo Done updating line $COUNT
	rm  tmpPingRes
done < $IPLIST

