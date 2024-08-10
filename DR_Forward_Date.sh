#!/usr/bin/sh

usr="carana"
#Associative array for IP
declare -A pdsIPs
#Market Page
pdsIPs[MarketPage]="172.16.131.15 172.16.108.25 172.16.132.15"

#PDS Website
pdsIPs[PDSWebsite]="172.16.108.10 172.16.131.12 172.16.132.12"

#SIS
pdsIPs[SIS]="172.16.106.7"

#SSCP_ISO (Docker DB)
pdsIPs[SCCPIso]="172.16.133.28 172.16.133.17"

#CAAC (Web App/DB)
#pdsIPs[CAAC]="172.16.9.167 172.30.1.19"
pdsIPs[CAAC]="172.30.1.19"

#TIS
pdsIPs[TIS]="172.16.106.10"

#PDS Clear (Web, App, DB)
pdsIPs[PDSClear]="172.16.108.20 172.16.107.10 172.16.110.4"

#API Gateway
pdsIPs[PDSApigateway]="172.16.108.30 172.16.15.4"

#Function for Cheking and systemd commands 
# ${ FNR == 3 } means select row 3
#{ -F'-' } means set/read as field separator
function chk(){
	#check Date 
	if [[ "date" = $1 ]]
	then
		ssh $usr@$2 "sudo date"
	#check status
	elif [[ "st" = $1 ]]
	then
		ssh $usr@$2 'systemctl status crond' | awk 'FNR == 3'
	#stop crond service
	elif [[ "stp" = $1 ]]
	then
		ssh $usr@$2 'sudo systemctl stop crond' | awk 'FNR == 3'
	#check hostname 
	elif [[ "host" = $1 ]]
	then
		ssh $usr@$2 "hostname"
	#restart crond service
	elif [[ "rt" = $1 ]]
	then
		ssh $usr@$2'sudo systemctl restart crond' | awk 'FNR == 3'
	fi
}

#This will validate the input of each read command
function validateInput(){
	# Validate the user input
	if ! [[ $1 =~ ^[0-9]+$ ]] || [ $1 -lt 0 ] || [ $1 -gt $2 ]; then
		echo -e "\nInvalid selection!!!\n" 
		exit 1
	fi
}
#This function will validate the server selection
        #if (($i !~ /^[+-]?[0-9]*\.?[0-9]+$/) && ($i <= len) && !($i < 0)){
validateServer() {
    local seq=$1
    local var_length=$2
    local valid=$(echo -e "$seq" | awk -v len="$var_length" -F' ' '
{
    all_numbers = 1
    for (i = 1; i <= NF; i++) {
        if (($i !~ /^[+-]?[0-9]*\.?[0-9]+$/) || !($i <= len) || ($i < 0)){
            all_numbers = 0
            break
        }
    }
    if (all_numbers) {
		print $0
    } else {
    }
}')
    if [[ -n $valid ]]; then
        return 0  # Valid
    else
        return 1  # Invalid
    fi
}
##########################
# What do you want to do?#
##########################
function benigning(){
	echo -e "\nWhat are we going to do?"
	echo "1.Change Date"
	echo -e "2.Calibrate date to NTP Server \n"
	# Prompt the user to select an interface
	read -p "Enter the TASK that you want to use: " task_number 

	#validate the input
	validateInput $task_number 2
}
benigning

##############
# Select Day #
##############
function selectDay(){
	echo -e "\nSelect What Day:
1.Push forward by 1 days
2.Push forward by 2 days\n"
	# Prompt the user to select an interface
	read -p "Enter the DAY that you want to use: " day_number 
	#validate the input
	validateInput $day_number 2 
	if [[ $day_number == 1 ]]
	then
		varAdjust="+1"	
	else
		varAdjust="+2"	
	fi
}

####################
# Select server(s) #
####################
function getSrvIp(){
	echo -e "\n=================START====================="
	echo -e "Alias: $1\n" 
	#proccess each server withting the $1 Group
	printf "${pdsIPs[$1]}" | awk -v tsk="$cond" -v grp="$1" -v usrn="$usr" -v ajDate="$2"  -F' ' '
{ 
	for (i=1;i<=NF;i++) {
		#GET SERVER IP
		print "Server IP: " $i;
		remoteCmdhst = " hostname";
		if (grp == "SIS"){
			p = "ssh -p 222 ";
			px= "@"
			p1 = p usrn px;
		} else {
			p = "ssh ";
			px= "@"
			p1 = p usrn px;
		}
		p2 = $i;
		runSsh = p1 p2;
		hst = runSsh remoteCmdhst;
		hst | getline hostName	
		close(hst)
		#GET SERVER HOSTNAME
		print "Hostname: " hostName;
		remoteCmddate = " date";
		currentDate = runSsh remoteCmddate;
		currentDate | getline curDate;
		close(currentDate)
		#GET SERVER CURRENT DATE 
		print "Current Date: " curDate;
		if ((tsk != "" || tsk != null) && (grp == "SCCPIso")) {
			remoteCalibrate = " sudo systemctl restart chronyd | sleep 5"; 
			calibrateDate = runSsh remoteCalibrate; 
			calibrateDate |  getline reDate;
			close(calibrateDate) 
			print "Resyncing Time/DAte..." reDate;
  		} else if (tsk) {
			remoteCalibrate = " sudo ntpdate -b -u 172.16.48.2"; 
			calibrateDate = runSsh remoteCalibrate 
			calibrateDate |  getline reDate;
			close(calibrateDate) 
			print reDate;
  		} else if (tsk == "" || tsk == null) {
			v1 = " sudo date -s ";
			v3 = " days";
			v4 = ajDate v3;
			v2 = "\x27" v4 "\x27"
			remoteCmd = v1 v2;
			setDate = runSsh " \x22"remoteCmd"\x22";
			setDate | getline newDate;
			close(setDate)
			print "Setting date for " hostName ". . ." newDate;
		}
		remoteCmdnewdate = " date";
		chkNewDate = runSsh remoteCmdnewdate 
		chkNewDate | getline chkNewDate;
		close(chkNewDate) 
		#GET SERVER NEW DATE 
		print "New Date: " chkNewDate "\x0A";
	}
}' 
	echo "==================END======================"
}

function selectServer(){
	echo -e "\nSelect Server(s) that you want to use:"
	cat drServerList
	num_len="$(cat drServerList | wc -l)"
	read -p "Enter the server number(s): " -a server_numbers
	# Validate the the user input 
	#loop through the server_numbers from user input
	for server in "${server_numbers[@]}"; do
		#if this is empty or false mean there is an invalid input from the user
		if ! (validateServer "$server" "$num_len"); then
			echo -e "\nInvalid selection!!!\n" 
			exit 1
		fi 
	done
}
function adjustDate(){
	local file="./drServerList"
	cond="$1"
	# Loop through each line in the file
	while IFS= read -r line; do
		# Process each line from the file
		#loop through the server_numbers from user input
		for server in "${server_numbers[@]}"; do
			if [[ $line = $server* ]]; then
				srvGrp="$(echo $line | awk -F'.' '{print $2}')"
				getSrvIp $srvGrp $varAdjust 
			fi
		done
	done < "$file"
}
#Condition if what task needs to be done
if [[ $task_number == 1 ]]
then 
	selectServer	
	selectDay	
	adjustDate
elif [[ $task_number == 2 ]]
then
	selectServer	
	adjustDate $task_number 
fi 


: '
TODO:
[done] What task are going to do is it change date or resync time to ntp server
[done] function to list all the server available 
[done] function to select multiple server based on the list 
[done] identify if can run ntp or chronyd
'
