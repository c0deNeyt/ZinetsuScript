#!/usr/bin/sh

echo "Processing data..."
varData=$HOME/Script/data.json
varData0=$(<$HOME/Script/data.json)

#jq command is for handling json data 
varSrvCount=$(jq -r '.servers | keys | length' $varData)

# this will iterate to the server groups e.g CAAC 
for (( i = 0; i < ${varSrvCount}; i++ )); do

	#variable that store each server group per iteration
	srvGroup=$(jq -r ".servers[$i] | keys[0]" $varData)

	echo "Server Category: $srvGroup"

	#this will store the count of all server's within current group 
	srvGrpCount=$(jq -r ".servers[$i].$srvGroup | keys | length" $varData)

	#Loop to each server's
	for (( j = 1; j < ${srvGrpCount}; j++ )); do
		#thi will get the ip address of each server
		varSrvIp=$(jq -r ".servers[$i].$srvGroup[$j].serverip" $varData)
		varSrvAlias=$(jq -r ".servers[$i].$srvGroup[$j].alias" $varData)

                echo "Server IP: $varSrvIp"
		ping -4 -W1.5 -c3 $varSrvIp > ./tmpPingRes

		varCurStat=$(cat tmpPingRes | grep "packet loss" | awk -F',' '{print $3}' | awk '{print $1}')
                if [[ $varCurStat != "0%" ]]
                then
                        echo "Server IP: $varSrvIp"
			echo "Server Status: 100% Loss"
                        echo " "
                fi
		rm tmpPingRes	
	done # End of second Loop
	echo " "
done # End of First Loop
echo "Success!"


