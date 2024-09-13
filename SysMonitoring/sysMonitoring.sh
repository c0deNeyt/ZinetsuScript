#!/usr/bin/sh

#error checking
if [ -z "$1" ]; then
	echo " "  
	echo "ERROR: Incomplete Parameter!"
	echo "Example: ./sysMonitoring.sh chan"
	echo " "  
	exit 1
fi

date
echo "Generating Report..."
source $HOME/Script/Function.sh
srvAdm="$1"
defaultDir="$HOME/Script/SysMonitoring"
dumpDir="$HOME/Documents/SOD_EOD"
varData=$defaultDir/data.json
varGStatus="NO ISSUE FOUND!"
#jq command is for handling json data 
varSrvCount=$(jq -r '.servers | keys | length' $varData)
adminUsr="carana"
timeBasis="172.16.88.9"
smtpip="192.168.168.166"

#Function for Date
function gdate(){
	#Get Date time 
	if [[ $1 = "long" ]]
	then
		ssh $adminUsr@$timeBasis 'date +"%B %d, %Y %A, %r"' 
	elif [[ $1 = "xlsxName" ]]
	then
		#condition for EOD
		if [[ $(ssh $adminUsr@$timeBasis 'date +"%p"') = "PM" ]]
		then 
			ssh $adminUsr@$timeBasis 'date +"EOD_System_Monitoring_%B_%d_%Y_%A"' 
		#condition for SOD 
		elif [[	$(ssh $adminUsr@$timeBasis 'date +"%p"') = "AM" ]]
		then
			ssh $adminUsr@$timeBasis 'date +"SOD_System_Monitoring_%B_%d_%Y_%A"' 
		fi
	#get time e.g. 13:00
	elif [[ $1 = "tme" ]]
	then
		ssh $adminUsr@$timeBasis 'date +"%H:%M"' 
	elif [[ $1 = "ampm" ]]
	then
		ssh $adminUsr@$timeBasis 'date +"%p"' > timeAmOrPm
		ssh $adminUsr@$timeBasis 'date +"%B %d, %Y-%A"' >> timeAmOrPm
	fi
}

#Function for IBM Storage Checking
function runScript(){
	$defaultDir/storage.sh $1 $2 >> storageStatus
}

#Function notification incase Issue is found.
function notif(){
	echo -e "\nServer Alias: $1"
	echo "Server IP: $2"
	echo -e "Classification : $3\n"
}

#Write the server status
checkStatus(){
	if [[ "$1" -ne 0 ]] && [[ "$6" == "NO ISSUE FOUND!" ]] 
	then 
		#this will edit the csv file
		$defaultDir/edit_Csv_File.sh "$2" "$3" "$4" "$5"
	else
		$defaultDir/edit_Csv_File.sh "$2" "$3" "$6" "$5"
	fi
}

#creating a file to store results
varDataStorage="$defaultDir/Monitoring_Results.txt" #filename
touch "$varDataStorage" #create 
srvCount=0
# this will iterate to the server groups e.g CAAC 
for (( i = 0; i < ${varSrvCount}; i++ )); do
	varStatus="NO ISSUE FOUND!"
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
		srvCount=$(echo $srvCount + 1 | bc)
		# -4 => ping tcp only
		# -c3 => give 3 packet test
		# -W1.5 => wait interval to consider timeout in seconds
		# > => to stdout the ouput into a file tmpPingRes
		ping -4 -c4 -W1.5 "$varSrvIp" > tmpPingRes
		echo " " >> tmpPingRes
		cat tmpPingRes >> $varDataStorage 

		#Condition to check the heath of IBM Storages
		if [ "$srvGroup" == "IBM_STORAGE" ] && [ "$varSrvAlias" != "PdsProdVmV7000" ]; then
			runScript "superuser"  "$varSrvIp"  
			strgStat=$(awk -F':' '{
				for (i = 1; i <= NF; i++) {
					if ( $i != "online" ) {
						print "ISSUE(S) FOUND!"
						break
					} 	
				}
			}' storageStatus)
		fi

		#Cheking if there is packet loss or ping discrepancy
		varCurStat=$(cat tmpPingRes | grep "packet loss" | awk -F',' '{print $3}' | awk '{print $1}')
		#checking if the pocket capture if not greater than 99% or string 
		# Check if varCurStat is a valid number
		varCurStatNum="${varCurStat%\%}"
		if [[ "$varCurStatNum" =~ ^-?[0-9]+$ ]]; then
			if [[ $varCurStatNum -ge 0 ]] && [[ $varCurStatNum -lt 100 ]]; then
				srvStatus="UP"
			else
				varStatus="ISSUE(S) FOUND!"
				srvStatus="$varStatus"
				varGStatus="$varStatus"
				notif "$varSrvAlias" "$varSrvIp" "$varSrvCat"
			fi
		else
			varStatus="ISSUE(S) FOUND!"
			varGStatus="$varStatus"
			srvStatus="$varStatus"
			notif "$varSrvAlias" "$varSrvIp" "$varSrvCat"
		fi
		#Condition to check the heath of IBM Storages
		if [ "$strgStat" ]; then
			srvStatus="$strgStat"
			notif "$varSrvAlias" "$varSrvIp" "$varSrvCat"
		fi
		#remove temporary file
		if [ -f storageStatus ]; then
			rm  storageStatus 
		fi
		rm  tmpPingRes
	done
	#this considtion aims to avoid the noncritical server 
	#to write on csv but also check the  server condition
	checkStatus "$varIndex" $(gdate tme) "$srvAdm" "$srvStatus" "$srvGroup" "$varStatus"
	#Update Global Status
	#add space below on each group
	echo " " >> $varDataStorage
done
# This will echo out the final status of the file 
echo -e "\nMonitoring Status: $varGStatus"
echo -e "Running CSV to HTML... \n"
/usr/bin/python3 "$defaultDir"/tohtml.py
echo -e "Starting to transfer the files... \n"
#this will update the file SOD_EOD dir 
rm "$dumpDir"/*.txt >> /dev/null 2>&1
mv $defaultDir/*.txt "$dumpDir"

#this will update the Excel file based on the csv data
/usr/bin/python3 "$defaultDir"/toExcel.py
cp "$dumpDir"/SystemMonitoring.xlsx "$dumpDir"/$(gdate xlsxName).xlsx 

#this will update the file from windows
#trans smu

#transfer the excel file on smtp server 
ssh $adminUsr@$smtpip 'rm /home/carana/SystemMonitoring/*.xlsx' > /dev/null 2>&1
scp -q "$dumpDir"/$(gdate xlsxName).xlsx $adminUsr@$smtpip:/home/$adminUsr/SystemMonitoring/

#transfer the html file on smtp server 
scp -q ebody.html $adminUsr@$smtpip:/home/$adminUsr/SystemMonitoring/ > /dev/null 2>&1

#transfer the text file on smtp server 
scp -q "$dumpDir"/*.txt $adminUsr@$smtpip:/home/$adminUsr/SystemMonitoring/

#transfer the file on smtp server 
gdate ampm 
echo "$(gdate xlsxName).xlsx" >> timeAmOrPm 
scp -q timeAmOrPm $adminUsr@$smtpip:/home/$adminUsr/SystemMonitoring/

echo -e "Trying to send Email... \n"
ssh $adminUsr@$smtpip 'cd SystemMonitoring; ./send_email.sh'

#remove the xlsx file
rm "$dumpDir"/$(gdate xlsxName).xlsx 
rm ebody.html 
rm timeAmOrPm 

echo -e "\nServer Count: $srvCount"
date
