#!/usr/bin/sh

#error checking
if [ -z "$1" ]; then
	echo " "  
	echo "ERROR: Incomplete Parameter!"
	echo "Example: ./sysMonitoring.sh chan"
	echo " "  
	exit 1
fi

echo "Generating Report..."
source $HOME/Script/Function.sh
srvAdm="$1"
varData=$HOME/Script/SysMonitoring/data.json
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
		#condition for EOD
		if [[ $(date +"%r" | awk '{print $2}') = "PM" ]]
		then 
			ssh carana@172.16.131.15 'date +"EOD_%m%d%Y_%H%M"' 
		#condition for SOD 
		elif [[	$(date +"%r" | awk '{print $2}') = "AM" ]]
		then
			ssh carana@172.16.131.15 'date +"SOD_%m%d%Y_%H%M"' 
		fi
	#get time e.g. 13:00
	elif [[ $1 = "tme" ]]
	then
		ssh carana@172.16.131.15 'date +"%H:%M"' 
	fi
}

#creating a file to store results
varDataStorage="$(gdate short).txt" #filename
touch $varDataStorage #create 
srvCount=0
# this will iterate to the server groups e.g CAAC 
for (( i = 0; i < ${varSrvCount}; i++ )); do
	#variable that store each server group per iteration
	srvGroup=$(jq -r ".servers[$i] | keys[0]" $varData)
	echo "=====================================================" >> $varDataStorage 
	echo "$srvGroup" $(gdate long) >> $varDataStorage
	echo "=====================================================" >> $varDataStorage
	varIndex=$(jq -r ".servers[$i].$srvGroup[0].index" $varData)
	echo "$srvGroup..."

	#this will store the count of all server's within current group 
	srvGrpCount=$(jq -r ".servers[$i].$srvGroup | keys | length" $varData)
	#Loop to each server's
	for (( j = 1; j < ${srvGrpCount}; j++ )); do
		#this will get the ip address 
		varSrvIp=$(jq -r ".servers[$i].$srvGroup[$j].serverip" $varData)
		#this will get the Alias
		varSrvAlias=$(jq -r ".servers[$i].$srvGroup[$j].alias" $varData)
		#this will get the category/classification
		varSrvCat=$(jq -r ".servers[$i].$srvGroup[$j].classification" $varData)
		
		#server header	
		echo "*** $varSrvAlias ***" >> $varDataStorage
		# -4 => ping tcp only
		# -c3 => give 3 packet test
		# -W1.5 => wait interval to consider timeout in seconds
		# > => to stdout the ouput into a file tmpPingRes
		srvCount=$(echo $srvCount + 1 | bc)
		ping -4 -c3 -W1.5 $varSrvIp > ./tmpPingRes
		echo " " >> ./tmpPingRes
		cat tmpPingRes >> $varDataStorage 

		#Cheking if there is packet loss or ping discrepancy
		varCurStat=$(cat tmpPingRes | grep "packet loss" | awk -F',' '{print $3}' | awk '{print $1}')
		#checking if the pocket capture is not 0% loss
		if [[ $varCurStat != "0%" ]]
		then
			varStatus="ISSUE(S) FOUND!"
			srvStatus="$varStatus"
			echo -e "\nServer Alias: $varSrvAlias"
			echo "Server IP: $varSrvIp"
			echo -e "Classification : $varSrvCat\n"
		else
			srvStatus="UP"
		fi
		#remove temporary file
		rm  tmpPingRes
	done
	#this considtion aims to avoid the noncritical server 
	#to write on csv but also check the  server condition
	if [[ $varIndex -ne 0 ]] 
	then 
		#this will edit the csv file
		$HOME/Script/SysMonitoring/edit_Csv_File.sh $(gdate tme) $srvAdm $srvStatus $srvGroup
	fi
	#add space below on each group
	echo " " >> $varDataStorage
done

#==========================
#Handle Storages
#==========================
: '
TO DO:
[]Get server Status 
[]Get server Group 
'
# This will echo out the final status of the file 
echo -e "\nMonitoring Status: $varStatus"

#this will update the file SOD_EOD dir 
rm $HOME/Documents/SOD_EOD/*.txt 
mv $HOME/Script/SysMonitoring/*.txt $HOME/Documents/SOD_EOD/ 
#this will update the Excel file based on the csv data
/usr/bin/python3 toExcel.py
#this will update the file from windows
trans smu
echo -e "\nServer Count: $srvCount"
