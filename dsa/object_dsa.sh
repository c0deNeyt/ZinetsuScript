#!/bin/bash

# Define a class-like structure for Server
Dsa(){
	ip="$1"
	usrAdm="$2"

    # Method to check if the IP is pingable
    is_pingable() {
        ping -c 1 -W 2 "$ip" >/dev/null
        return $?
    }

    # Method to check ibm_utl.bin exist 
    is_ibm_utl() {
        local port="$@"
        ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" \
	 	"sudo -s [ -f /root/ibm_utl_dsa*.bin ]" 
        return $?
    }
	
    # Method to create log file
	get_log() {
		sleep 2
		echo -ne "\r$1 \n" | tee -a $2
	}

    # Method to check if a port is open
    is_port_open() {
        local port="$@"
        nc -z -w 1 "$ip" "$port" &> /dev/null
        return $?
    }

    # Method to check if a user exists on a Linux server
    user_exists() {
		local port="$@"

		#condition to check if it is using port 22 or 222	 
		if [[ "$port" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "id -u $usrAdm" &> /dev/null
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "id -u $usrAdm" &> /dev/null
		fi
        return $?
    }
	
	# get dsa report
    get_dsa() {
        local port="$@"
		# Ge the dsa.bin full name
        fileName=$(ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" 'sudo ls /root/ | grep ibm_utl_dsa' 2>&1)

		# Remove the previous logs
        ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "sudo rm -rf /var/log/IBM_Support/*" 

		# run the dsa command
		ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" 'sudo /root/'"$fileName"' -v' <<EOF
Y
Y
EOF
		#get the new generated long folder name 
        logFolderName=$(ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "sudo ls /var/log/IBM_Support | awk 'NR==1 {print \$1}'" 2>&1)
		
		# Copy new Generated DSA folder
		scp -qrP "$port" "$usrAdm@$ip:/var/log/IBM_Support/$logFolderName" /media/sf_Linux/dsa 
        return $?
    }

	# Loading animation
	spinner(){
		# Run a command (e.g., scp) in the background
		pid=$!

		# Define a spinner animation
		spin[0]="-"
		spin[1]="\\"
		spin[2]="|"
		spin[3]="/"

		# Display the spinner while the process is running
		echo -n -e "[Generating DSA...] \n ${spin[0]}"
		while kill -0 $pid 2> /dev/null; do
			for i in "${spin[@]}"; do
				echo -ne "\b$i" 
				sleep 0.1 
			done 
		done
		echo -ne "\rDone...!\n"
	}
}
