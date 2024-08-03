#!/usr/bin/sh

echo  "Script is running..."
#To find 
varFind="54.199.58.200"
varFind2="52.192.195.27"
#To  place
pri="18.136.25.234    apne1-1001.sentinelone.net"
sec="13.215.247.89    apne1-1001.sentinelone.net"
#File location
varHosts="/etc/hosts"

#Function to edit all the results from the serarchDirectory.txt
function iditFile(){
	lineNum="$(sudo grep -rIn $varFind /etc/hosts | awk -F':' '{print $1}')d"
	if [[ "d" != $lineNum ]] 
	then
		#remove varfind match
		sudo sed -i $lineNum $varHosts;
	else
		echo  "$varFind Not exist!";
	fi

	lineNum2="$(sudo grep -rIn $varFind2 /etc/hosts | awk -F':' '{print $1}')d"
	if [[ "d" != $lineNum2 ]]; 
	then
		#remove varfind match
		sudo sed -i $lineNum2 $varHosts;
	else
		echo -e "$varFind2 Not exist!";
	fi;

	newIP="$(cat $varHosts | grep "18.137.25.234\|13.215.247.89")"
	if [[ -n $newIP ]];
	then
		echo  "New Sentinelone host already exist!"
	else
		#add a line from variable pri,sec
		echo "$pri" | sudo tee -a $varHosts >> /dev/null;
		echo "$sec" | sudo tee -a $varHosts >> /dev/null;
	fi
}
iditFile
echo -e "\n"
echo "SERVER NAME: $(hostname)"
echo "ADDED: $pri"
echo "ADDED: $sec"
echo " "
echo "NEW HOST FILE:"
cat /etc/hosts
