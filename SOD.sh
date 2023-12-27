#!/usr/bin/sh

#varFilePath=$HOME/trans/send/sampleFile.csv
varFilePath=$HOME/Script/isalangMoAko
srvJSON=$HOME/Script/critical.json
#Associative array for IP
declare -A pdsCAAC
#CAAC
ppdsServerIP[cca_db]="172.32.1.127"
ppdsServerIP[cca_web]="172.32.1.127"

#Function for Date
function date(){
	#Get Day
	if [[ $1 = "day" ]]
	then
		ssh $usr@$srv_ip 'date --rfc-3339=date' | awk -F'-' '{print $3}'
	#Get Year Month
	elif [[ $1 = "ym" ]]
	then
		ssh $usr@$srv_ip  'date --rfc-3339=date' | awk -F'-' '{print $1"-"$2"-"}'
		#{ -F'-' } means set/read as field separator
	#Get Current time  
	elif [[ $1 = "tm" ]]
	then
		ssh carana@172.16.131.15 'date --rfc-3339=seconds' | awk -F'+' '{print $1}' | awk '{print $2}'
	fi
}
#
date tm
sleep 2
date tm

# Check if the file exists
if [ -f $varFilePath ]; then
    # Read each line of the file
    while IFS= read -r line; do
        echo "IP: $line"
	# Create a temporaryFile to store each result
	touch tmpPingRes
	touch eodsod.txt 
	# -4 => ping tcp only
	# -c3 => give 3 packet test
	# -W1.5 => wait interval to consiter timeout in seconds
	ping -4 -c2 -W1.5 $line > ./tmpPingRes
       	cat tmpPingRes >> eodsod.txt 
       	cat tmpPingRes | grep "packet loss" | awk -F',' '{print $3}' | awk '{print $1}'
	rm ./tmpPingRes
	echo "===================================="
	#echo $line | awk -F',' '{print $3}'
    done < "$varFilePath"
else
    echo "File does not exist."
fi
