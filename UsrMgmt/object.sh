#!/bin/bash

# Define a class-like structure for Server
Server() {
	# initialize params
	data="$1"
    usrAdm="$2"
	inum="$3"
	rawFile="$4"
	ip="$5"
	newUser="$6"
	status=""

    # Method to check if the IP is pingable
    is_pingable() {
        ping -c 1 -W 2 "$ip" &> /dev/null
        return $?
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

    # Method to check if a new user exists on a Linux server
    new_user_exists() {
		local nUser="${@:1:1}"
		local port="${@:2:1}"

		#condition to check if it is using port 22 or 222	 
		if [[ "$port" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "id -u $nUser" &> /dev/null
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "id -u $nUser" &> /dev/null
		fi
        return $?
    }

    # Method to write in csv file 
    write_to_file() {
		# $@ contains all the param
		local x="$@"

		# Format the content
		new_content=$(echo "$data" | awk -F',' -v hostName="$x" '{print $1","hostName}')

		# Escape special char
        escaped_variable=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
	
		# write to csv file
		sed -i "${inum}s/.*/${escaped_variable}/" "$rawFile"
		
		# Set status variable
		varStatus="$x"
    }
    update_user_status() {
		# $@ contains all the param
		local x="$@"

		# Format the content
		new_content=$(echo "$data" | awk -F',' -v status="$x" '{print $1","$2","$3","$4","status}')

		# Escape special char
        escaped_variable=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
	
		# write to csv file
		sed -i "${inum}s/.*/${escaped_variable}/" "$rawFile"
		
		# Set status variable
		varStatus="$x"
    }

    # Method to get the server hostname 
    get_hostname() {
		# $@ contains all the param
		local port="$@"
		
		#condition to check if it is using port 22 or 222	 
		if [[ "$port" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "hostname" 
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "hostname" 
		fi	
    }

	# Method to check if the server is ubuntu
	is_ubuntu() {
		local port="${@:1:1}"
		local osFlavor="ubuntu"
		local varCmd="uname -a | grep -iq $osFlavor" 
		if [[ "$port" -eq "222" ]]; then 
			ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "$varCmd" &> /dev/null 
		else
			ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "$varCmd" &> /dev/null 
		fi
		return $?
	}
	
	# Methond to check if admin or user
	is_admin() {
		if [[ $(echo "$data" | awk -F, '{print $4}') -eq "1" ]]; then
			return 0 # admin
		else 
			return 1 # user
		fi	
	}	
	
	# Method adduser
	cmd_adduser() {
		local port="${@:1:1}"
		local varCmd="${@:4:1}"

		# Verify what port to be use
		if [[ "$port" -eq "222" ]]; then 
			# Send to useradd command to the server using port 222
			ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "$varCmd" &> /dev/null 
		else
			# Send to useradd command to the server 
			ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "$varCmd" &> /dev/null 
		fi
		return $?
	}	
	
	# Method passwd 
	cmd_setpass(){
		local port="${@:1:1}"
		local un="${@:2:1}"

		# Verify what port to be use
		if [[ "$port" -eq "222" ]]; then 
			/usr/bin/expect sudoPasswd.exp "$usrAdm" "$ip" "$un" "$port" &> /dev/null   
		else
			/usr/bin/expect sudoPasswd.exp "$usrAdm" "$ip" "$un" &> /dev/null  
		fi
		return $?
	}

	# Method to delete user
	cmd_deluser(){
		local port="${@:1:1}"
		local user="${@:2:1}"

		# Verify what port to be use
		if [[ "$port" -eq "222" ]]; then 
			ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "sudo userdel -r $user" &> /dev/null 
		else
			ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "sudo userdel -r $user" &> /dev/null 
		fi
		return $?
	}

	# Method to Modify user
	cmd_moduser(){
		local port="${@:1:1}"
		local user="${@:2:1}"
		local group="${@:3:1}"

		# Verify what port to be use
		update_user_status "User $newUser role modified."
		ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "sudo usermod -aG $group $user" &> /dev/null 
		return $?
	}
	
	# Method to have it be server ask to change pass
	cmd_chage(){
		local port="${@:1:1}"
		local user="${@:2:1}"

		# Verify what port to be use
		if [[ "$port" -eq "222" ]]; then 
			ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$port" "$usrAdm@$ip" "sudo chage -d 0 $user" &> /dev/null 
		else
			ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "sudo chage -d 0 $user" &> /dev/null 
		fi
		return $?
	}


	# Method create account
	creation() {
		local port="${@:1:1}"
		local fn="${@:2:1}"
		local un="${@:3:1}"
		local mainGroup="${@:4:1}"

		# Condition to generate command template			
		if [ -z "$mainGroup" ]; then
			local varCmd="sudo useradd -c '$fn' -m -d /home/$un -s /bin/bash $un"
		else
			local varCmd="sudo useradd -c '$fn' -m -d /home/$un -s /bin/bash $un && sudo usermod -aG $mainGroup $un"
		fi
		 
		# Adduser 
		if cmd_adduser "$port" "$fn" "$un" "$varCmd"; then
			# Set Default password 
			if cmd_setpass "$port" "$un"; then 
				# Method to ensure that the server ask to change pass.
				if cmd_chage "$port" "$un"; then
					# Update Status
					update_user_status "Account $un created"
				fi
			else
				echo "${LINENO}:: cmd_setpass failed with exit code $?."
			fi
		else
			echo "${LINENO}:: Error: cmd_adduser failed with exit code $?."
		fi
	}

	# Method to create admin 
	put_admin() {
		if is_ubuntu "$@"; then
			# Method instance 
			creation "$@" "admin"
		else
			# Method instance 
			creation "$@" "wheel"
		fi	
	}
	validate_role() {
		if is_admin	; then
			# Method instance 
			put_admin "$@"
		else
			# Method instance 
			creation "$@" 
		fi
	}	

	# Method to validate the new user existence	
	validate_new_user() {
		local port="$@"
		local fn=$(echo "$data" | awk -F, '{print $1}')
		local un=$(echo "$data" | awk -F, '{print $2}' | tr -d '[:space:]')
		
		# Validate what port is using 	
		if [[ "$port" -eq "222" ]]; then 
			# Validate if the user exist 
    		if new_user_exists "$newUser" "$port"; then
				update_user_status "User $newUser already exist"

				# Method to modify user role
				if is_ubuntu "$port"; then
					# Method instance 
					cmd_moduser "$port" "$newUser" "admin"
					update_user_status "Account $newUser role modified."
				else
					# Method instance 
					cmd_moduser "$port" "$newUser" "wheel"
					update_user_status "Account $newUser role modified."
				fi	
			else
				validate_role "$port" "$fn" "$un" 
			fi
		else
			# Validate if the user exist 
    		if new_user_exists "$newUser"; then
				update_user_status "User $newUser already exist"
				# Method to modify user role
				if is_ubuntu "22"; then
					# Method instance 
					cmd_moduser "22" "$newUser" "admin"
					update_user_status "Account $newUser role modified."
				else
					# Method instance 
					cmd_moduser "22" "$newUser" "wheel"
					update_user_status "Account $newUser role modified."
				fi	
			else
				validate_role "" "$fn" "$un" 
			fi
		fi

	}
	

    # Method to check the server and print results
    check_server() {
        echo -e "\nChecking IP: $ip (UserAdmin: $usrAdm)"

        if is_pingable; then
            if is_port_open 22; then
                if user_exists; then
					hstname=$(get_hostname)
					write_to_file "$hstname"
                else
					write_to_file "User Admin Not Found!"
                fi
            elif is_port_open 222; then
                if user_exists 222; then
					hstname=$(get_hostname "222")
					write_to_file "$hstname"
                else
					write_to_file "User Admin Not Found!"
                fi
            elif is_port_open 3389; then
                write_to_file "Port 3389 is open (Windows)"
            else
                write_to_file "No relevant ports are open"
            fi
        else
			write_to_file "Server unreachable"
        fi

		# Display the status
		if [[ ! -z "$varStatus" ]]; then
			echo "$varStatus"
		fi
    }
	
    # Method for account creation 
    create_account() {
        echo -e "\nChecking IP: $ip (UserAdmin: $usrAdm)"
        if is_pingable; then
            if is_port_open 22; then
                if user_exists; then
					validate_new_user	
                else
					update_user_status "User admin unavailable"
                fi
            elif is_port_open 222; then
                if user_exists 222; then
					validate_new_user 222
                else
					update_user_status "User admin unavailable"
                fi
            elif is_port_open 3389; then
                update_user_status "Port 3389 is open (Windows)"
            else
               	update_user_status "No relevant ports are open"
            fi
        else
			update_user_status "Server unreachable"
        fi

		# Display the status
		if [[ ! -z "$varStatus" ]]; then
			echo "$varStatus"
		fi
    }
}
