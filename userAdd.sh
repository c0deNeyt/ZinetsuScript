#!/bin/bash

#Csv File
file="$HOME/trans/recieved/adduser.csv"
#Line count
lineCount=$(cat $file | wc -l)
#admin user that will be using
adminUser="carana"
#groups that user will be use for account creation
groups="wheel"
#port to check
port=22
#Loop to iterate inside the .csv File.
for ((i = 2; i <= $lineCount; i++)); do
	#specific line inside the file based on the iteration 
	a=$(awk -v lnum="$i" 'NR == lnum  { print; exit }' $file)
	#Fullname
	fn=$(echo "$a" | awk -F, '{print $1}')
	#Username
	un=$(echo "$a" | awk -F, '{print $2}' | tr -d '[:space:]')
	#Server IP
	si=$(echo "$a" | awk -F, '{print $3}' | tr -d '[:space:]')

	#check if port 22 is open
	if nc -zv "$si" "$port" > /dev/null 2>&1; then
		echo -e "\nPort $port on $si is open."
	else
		echo "Port $port on $si is closed or unreachable. !!!"
		exit 1
	fi
	#check if admin account exist on the server 
	if ssh "$adminUser@$si" "id -u $adminUser > /dev/null 2>&1"; then
		echo "Admin $adminUser found on $si."
	else
		echo -e "Admin $adminUser not found.!!!"
		exit 1
	fi
	#check if account exist on the server 
	if ssh $adminUser@$si "getent passwd $un" > /dev/null 2>&1; then
		echo -e "\"$un\" Already exist! @ $si"
	else
		echo "Connecting to: $si"
		ssh $adminUser@$si "sudo useradd -c '$fn' $un" > /dev/null 2>&1
		ssh $adminUser@$si "sudo usermod -aG $groups $un" > /dev/null 2>&1
		expect sudoPasswd.exp $adminUser $si $un > /dev/null 2>&1
		ssh $adminUser@$si "sudo chage -d 0 $un" > /dev/null 2>&1
		echo -e "\"$un\" Successfully created! @ $si"
	fi
done




