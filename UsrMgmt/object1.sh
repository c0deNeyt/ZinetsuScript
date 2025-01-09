#!/bin/bash

# Define a class-like structure for Server
Server() {
	ip="$1"
	admUser="$2"
    # Method to check if a port is open
    is_port_open() {
        local port="$@"
        nc -z -w 1 "$ip" "$port" &> /dev/null
        return $?
    }

    # Method to check if a port is open
	get_users(){
		REMOTE_USER=$1
		REMOTE_HOST=$2
		port=$3
		TMP_FILE=$(mktemp /tmp/passwd_XXXXXX)

		echo "Connecting to $REMOTE_HOST as $REMOTE_USER to fetch /etc/passwd..."

		# SSH to the remote server and fetch the /etc/passwd file
		ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$REMOTE_USER@$REMOTE_HOST" "cat /etc/passwd" > "$TMP_FILE"

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

		testvar="HI Im from variable!"

		# SSH to the remote server and fetch the /etc/passwd file
		ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$admUser@$ip" << EOF
groups "$user"
EOF
	}
	
	filter_users(){
		tmpUsersFile=$1
		#Loop through the temporary file contenet
		for user in $(cut -d: -f1 $tmpUsersFile); do
			# Method to get the role for each user
			get_roles "$2" "$user"
		done
	}
	
	# Generate user and roles 
	gen_users_rep(){
		# Method to validate if port is 222 open
		if is_port_open "22"; then 

			echo "Port 22 is open"
			#get the temporary file content
			tmpFile=$(get_users "$admUser" "$ip" "22" 2>/dev/null)

			# Method instance to fileter the users
			filter_users "$tmpFile" "22"
		else
			echo "Port 22 is close"
		fi
	}
}
