#!/bin/bash

# Define a class-like structure 
Server() {
	ip="$1"
	admUser="$2"
    # Method to check if a port is open
    is_port_open() {
        local port="$@"
        nc -z -w 1 "$ip" "$port" &> /dev/null
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
		echo -n -e "[Generating Report for @ ${@:1:1}...] \n ${spin[0]}"
		while kill -0 $pid 2> /dev/null; do
			for i in "${spin[@]}"; do
				echo -ne "\b$i" 
				sleep 0.1 
			done 
		done
		echo -ne "\rDone...!\n"
	}

    # Method to get a server psswd file and store in a temporary file
	get_passwd(){
		REMOTE_USER="${@:1:1}"
		REMOTE_HOST="${@:2:1}"
		port="${@:3:1}" 
		TMP_FILE=$(mktemp /tmp/passwd_XXXXXX)

		# SSH to the remote server and fetch the /etc/passwd file
		ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$REMOTE_USER@$REMOTE_HOST" "cat /etc/passwd" > "$TMP_FILE"

		# Failover condition	
		if [ $? -eq 0 ]; then
		  echo "$TMP_FILE"
		else
		  echo "Failed to fetch /etc/passwd from $REMOTE_HOST"
		  exit 2
		fi
	}
	
    # Method to check if a port is open
	get_roles(){
		port=$1
		user=$2
		csv_file=$3

		# SSH to the remote server and fetch the /etc/passwd file
		ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$admUser@$ip" "groups $user" 

		# Failover condition	
		if [ $? -ne 0 ]; then
		  echo "Failed to fetch groups of user $user"
		  exit 2
		fi
	}

	#Method to write on a csv file
	write_to_csv(){
		varData="$1,$2,$3" 

		#command to write in a csv file
		echo "$varData" >> "/media/sf_Linux/sandbox/bancsUsers.csv" 
	}	
	# Method to filter users
	filter_users(){
		local tmp_file="${@:1:1}"
		#Temporary variable to get line number of the file
		lCount=$(cat $tmp_file | wc -l)

		#Loop through the temporary file contenet
		for ((c = 1; c <= $lCount; c++)); do

			#variable to get the end of the line
			isLogin=$(awk -v lnum="$c"  -F: 'NR == lnum  {print $7; exit }' $tmp_file)

			#variable to get the username 
			srvUsr=$(awk -v lnum="$c"  -F: 'NR == lnum  {print $1; exit }' $tmp_file)

			#check if the user can login
			if [[ "$isLogin" != "/sbin/nologin" ]]; then

				#storing method in a variable
				varRole=$(get_roles "$2" "$srvUsr")

				#separate role from username
				rawRole=$(echo $varRole | awk -F: '{print $2}')

				#method instance	
				write_to_csv "$ip" "$srvUsr" "$rawRole"
			fi
		done < $tmp_file

		# Cleaning of temporary file 
		rm -f "${tmp_file}"
	}
	
	# Method to exicute filtering	
	run_filter(){
		local port="${@:1:1}"
		#get the temporary file content
		tmpFile=$(get_passwd "$admUser" "$ip" "$port" 2>/dev/null)

		# Method instance to fileter the users
		filter_users "$tmpFile" "$port"
	}
	
	# Generate user and roles 
	gen_users_rep(){
		# Method that is used to validate if port 22 open
		if is_port_open "22"; then 
			#method instance
			run_filter "22"
		else
			#method instance
			run_filter "222"
		fi

		return $?
	}
}
