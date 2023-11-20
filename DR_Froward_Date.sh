#!/usr/bin/sh

echo " "
#Variable assignment 
srv_ip="192.168.168.99"
usr="chan"

#Associative IP's
declare -A pdsIPs
#TIS
pdsIPs[TIS]="172.16.106.10"

#Market Page
pdsIPs[MarketPage_1]="172.16.131.15"
pdsIPs[MarketPage_2]="172.16.108.25"
pdsIPs[MarketPage_3]="172.16.132.15"

#PDS Website
pdsIPs[PDSWebsite_1]="172.16.108.10"
pdsIPs[PDSWebsite_2]="172.16.131.12"
pdsIPs[PDSWebsite_3]="172.16.132.12"


#Function for Cheking and systemd commands 
# ${ FNR == 3 } means select row 3
function chk(){
	#check Date 
	if [[ "date" = $1 ]]
	then
		ssh $usr@$srv_ip 'date'
	#check status
	elif [[ "st" = $1 ]]
	then
		ssh $usr@$srv_ip 'systemctl status crond' | awk 'FNR == 3'
	#stop service
	elif [[ "stp" = $1 ]]
	then
		ssh $usr@$srv_ip 'sudo systemctl stop crond' | awk 'FNR == 3'
	#check hostname 
	elif [[ "host" = $1 ]]
	then
		ssh $usr@$srv_ip 'hostname'
	#restart service
	elif [[ "rt" = $1 ]]
	then
		ssh $usr@$srv_ip 'sudo systemctl restart crond' | awk 'FNR == 3'
	fi
}

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
		ssh $usr@$srv_ip 'date --rfc-3339=seconds' | awk -F'+' '{print $1}' | awk '{print $2}'
	fi
}

#Forward Date
function processDate(){
	#${ bc -l } means standard math operation
	#${ scale=2 } mean scale limit with 2 decimal point
	newDay=$(bc -l <<< "scale=2; $(date day) + 2")
	newDate="$(date ym)${newDay}"
	newTime="$(date tm)"
	newDateTime="${newDate} ${newTime}"
	setDate="sudo date -s '${newDateTime}'"
	echo $setDate
}

#Initial Service Checking 
#chk date
#echo "Checking Server CRON status" $srv_ip "..."
#chk st
#echo " "

#Stoping service  
#echo "Restarting Server CRON service... "
#chk rt
#echo "Restarted Server CRON service... "
#chk st
#echo " "

#Checking Server Date
#echo "Checking Current Server Date..."
#chk date
#echo " "

#echo "Server day ==> " $(date day)
#echo "Server year month ==> " $(date ym)
#echo "Server time ==> " $(date tm)
#echo "Command for setting date ==> "  $(processDate)
#ssh chan@$srv_ip $(processDate)


#echo " "
#echo "New Server Date Set!"
#chk date

#LOOP through the Ip address
for key in ${!pdsIPs[@]}
do 
	#Overiding Variable
	srv_ip=${pdsIPs[$key]}
	usr="carana"

	echo "=========START==========="

	echo "Alias: " $key
	echo "Server IP: "${pdsIPs[$key]}
	echo "Hostname: " $(chk host)
	echo "Current Date: " $(chk date)
	echo "New Date: " $(processDate)
	echo "New Date: " $newDate
	#ssh $usr@$srv_ip $(processDate)

	echo "==========END============"
	echo " "
done 
