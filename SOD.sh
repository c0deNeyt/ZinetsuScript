#!/usr/bin/sh

echo "Generating Report..."
source $HOME/Script/Alias.sh
varData=$HOME/Script/data.json
varData0=$(<$HOME/Script/data.json)
varStatus="NO ISSUE FOUND!"
#jq command is for handling json data 
varSrvCount=$(jq -r '.servers | keys | length' $varData)
#Function for Date
function gdate(){
	#Get Date time 
	if [[ $1 = "long" ]]
	then
		ssh carana@172.16.131.15 'date +"%B %d, %Y %A, %r"' 
	elif [[ $1 = "short" ]]
	then
		if [[ $(date +"%r" | awk '{print $2}') = "PM" ]]
		then 
			ssh carana@172.16.131.15 'date +"EOD_%m%d%Y_%H%M"' 
		elif [[	$(date +"%r" | awk '{print $2}') = "AM" ]]
		then
			ssh carana@172.16.131.15 'date +"SOD_%m%d%Y_%H%M"' 
		fi
	elif [[ $1 = "tme" ]]
	then
		ssh carana@172.16.131.15 'date +"%H:%M"' 
	fi
}

#creating a file to store results
varDataStorage="$(gdate short).txt" #filename
touch $varDataStorage #create 
# this will iterate to the server groups e.g CAAC 
for (( i = 0; i < ${varSrvCount}; i++ )); do
	#variable that store each server group per iteration
	srvGroup=$(jq -r ".servers[$i] | keys[0]" $varData)
	echo "=====================================================" >> $varDataStorage 
	echo "$srvGroup" $(gdate long) >> $varDataStorage
	echo "=====================================================" >> $varDataStorage
	varIndex=$(jq -r ".servers[$i].$srvGroup[0].index" $varData)
	echo "$srvGroup..."

	#this will edit the csv file
	./edit_Csv_File.sh $varIndex $(gdate tme)

	#this will store the count of all server's within current group 
	srvGrpCount=$(jq -r ".servers[$i].$srvGroup | keys | length" $varData)
	#Loop to each server's
	for (( j = 1; j <= ${srvGrpCount}; j++ )); do
		#this will get the ip address of each server
		varSrvIp=$(jq -r ".servers[$i].$srvGroup[$j].serverip" $varData)
		varSrvAlias=$(jq -r ".servers[$i].$srvGroup[$j].alias" $varData)
		
		#server header	
		echo "*** $varSrvAlias ***" >> $varDataStorage
		# -4 => ping tcp only
		# -c3 => give 3 packet test
		# -W1.5 => wait interval to consider timeout in seconds
		# > => to stdout the ouput into a file tmpPingRes
		ping -4 -c3 -W1.5 $varSrvIp > ./tmpPingRes
		echo " " >> ./tmpPingRes
		cat tmpPingRes >> $varDataStorage 
		#Cheking if there is packet loss or ping discrepancy
		varCurStat=$(cat tmpPingRes | grep "packet loss" | awk -F',' '{print $3}' | awk '{print $1}')
		if [[ $varCurStat != "0%" ]]
		then
			varStatus="ISSUE(S) FOUND!"
			echo " "
			echo "Server Alias: $varSrvAlias"
			echo "Server IP: $varSrvIp"
			echo " "
		fi
		rm  tmpPingRes
	done
	#add space on each group
	echo " " >> $varDataStorage
done
# This will echo out the final status of the file 
echo $varStatus

#this will update the file from windows
trans smu
#PENDING
# Access the csv File
# write to a csv file
