#!/usr/bin/sh

echo "Processing data..."
varData=$HOME/Script/data.json
varData0=$(<$HOME/Script/data.json)

#jq command is for handling json data 
varSrvCount=$(jq -r '.servers | keys | length' $varData)

#temporary variable
changeCount=1
# this will iterate to the server groups e.g CAAC 
for (( i = 0; i < ${varSrvCount}; i++ )); do

	#variable that store each server group per iteration
	srvGroup=$(jq -r ".servers[$i] | keys[0]" $varData)

	#this will store the count of all server's within current group 
	srvGrpCount=$(jq -r ".servers[$i].$srvGroup | keys | length" $varData)

	#Loop to each server's
	for (( j = 0; j < ${srvGrpCount}; j++ )); do
		#thi will get the ip address of each server
		varSrvIp=$(jq -r ".servers[$i].$srvGroup[$j].serverip" $varData)
		varSrvAlias=$(jq -r ".servers[$i].$srvGroup[$j].alias" $varData)

		#altering json file
		one=".servers["
		two="]."
		three="$srvGroup"
		four="["
		five="] |= . + { "
		six='"classification": "Critical"'
		seven="}"
		#contatinating the command parameter
		param="$one$i$two$three$four$j$five$six$seven"
		
		#conditional to store a new data
		if [[ $changeCount > 1 ]]
		then
			#assign altered data to a variable 
			reduce=$( echo "$changeCount - 1 " | bc)
			newContent=$(<$HOME/Script/newData$reduce.json)

			#insert a new data	
			new_json=$(echo "$newContent" | jq "$param") 

			#put newData to a file
			echo "$new_json" > newData$changeCount.json

			#remove the previous file
			rm $HOME/Script/newData$reduce.json
			((changeCount++))
		else
			#insert a new data	
			new_json=$(echo "$varData0" | jq "$param")

			#put newData to a file
			echo "$new_json" > newData$changeCount.json
			((changeCount++))
		fi
	done # End of second Loop
done # End of First Loop

echo "Changing the original file..."
newFile=$(<$HOME/Script/newData$(echo "$changeCount - 1" | bc).json)
echo "$newFile" > data.json
echo "Removing temporary File..."
rm $HOME/Script/newData$(echo "$changeCount - 1" | bc).json
echo "Success!"


