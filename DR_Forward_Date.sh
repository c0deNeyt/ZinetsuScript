#!/usr/bin/sh

echo "Running..."

#Associative array for IP
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

#PDS Clear 
pdsIPs[PDSClear_1]="172.16.108.20"
pdsIPs[PDSClear_2]="172.16.107.10"
pdsIPs[PDSClear_3]="172.16.110.4"

#API Gateway
pdsIPs[PDSApigateway_1]="172.16.108.30"
pdsIPs[PDSApigateway_2]="172.16.15.4"

#SIS
pdsIPs[SIS]="172.16.106.7"

#Function for Cheking and systemd commands 
# ${ FNR == 3 } means select row 3
function chk(){
	#check Date 
	if [[ "date" = $1 ]]
	then
		ssh $usr@$srv_ip "sudo date"
	#check status
	elif [[ "st" = $1 ]]
	then
		ssh $usr@$srv_ip 'systemctl status crond' | awk 'FNR == 3'
	#stop crond service
	elif [[ "stp" = $1 ]]
	then
		ssh $usr@$srv_ip 'sudo systemctl stop crond' | awk 'FNR == 3'
	#check hostname 
	elif [[ "host" = $1 ]]
	then
		ssh $usr@$srv_ip "hostname"
	#restart crond service
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
#LOOP through the Ip address
for key in ${!pdsIPs[@]}
do 
	#Overiding Variable
	srv_ip=${pdsIPs[$key]}
	usr="carana"
	echo "=================START====================="
	echo "Alias: " $key
	echo "Server IP: "${pdsIPs[$key]}
	if [[ $key = "SIS" ]]
	then 
		echo "Hostname: " $(ssh -p 222 $usr@$srv_ip 'hostname')
		echo "Current Date: " $(ssh -p 222 $usr@$srv_ip "sudo date")
		echo "Setting Date For $(ssh -p 222 $usr@$srv_ip 'hostname')..."
		#Uncomment to Set date 2 days ahead  
		#ssh -p 222 $usr@$srv_ip "sudo date -s '+2 days'"
		#ssh -p 222 $usr@$srv_ip "sudo date -s '+1 days'"

		#ssh $usr@$srv_ip -p 222 "echo THIS_Is_A_Test_Result"

		#Uncomment to Sync date in realtime
		ssh -p 222 $usr@$srv_ip "sudo ntpdate -u 172.16.48.2" 
		ssh -p 222 $usr@$srv_ip "sudo ntpdate -u 172.16.48.2" 
		echo "New Date: " $(ssh -p 222 $usr@$srv_ip "sudo date")
	else
		echo "Hostname: " $(chk host)
		echo "Current Date: " $(chk date)
		echo "Setting Date For $(chk host)..."
		#Uncomment Set date 2 days ahead  
		#ssh $usr@$srv_ip "sudo date -s '+2 days'"
		#ssh $usr@$srv_ip "sudo date -s '+1 days'"

		#ssh $usr@$srv_ip "echo THIS_Is_A_Test_Result"

		#Uncomment to Sync date in realtime
		ssh $usr@$srv_ip "sudo ntpdate -u 172.16.48.2" 
		ssh $usr@$srv_ip "sudo ntpdate -u 172.16.48.2" 
		echo "New Date: " $(chk date)
	fi
	echo "==================END======================"
	echo " "
done 
echo " "
echo "DONE!"
