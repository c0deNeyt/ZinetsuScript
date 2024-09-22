#!/bin/bash

# Define a class-like structure for Server
Server() {
	# initialize params
	data="$1"
    usrAdm="$2"
	inum="$3"
	rawFile="$4"
	ip="$5"

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
        	ssh -o BatchMode=yes -o ConnectTimeout=5 -p "$port" "$usrAdm@$ip" "id -u $usrAdm" &> /dev/null
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=5 "$usrAdm@$ip" "id -u $usrAdm" &> /dev/null
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
    }

    # Method to get the server hostname 
    get_hostname() {
		# $@ contains all the param
		local port="$@"
		
		#condition to check if it is using port 22 or 222	 
		if [[ "$port" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=5 -p "$port" "$usrAdm@$ip" "hostname" 
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=5 "$usrAdm@$ip" "hostname" 
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
					write_to_file "User admin unavailable"
                fi
            elif is_port_open 3389; then
                write_to_file "Port 3389 is open (Windows)"
            else
                write_to_file "No relevant ports are open"
            fi
        else
			write_to_file "Server unreachable"
        fi
    }
}

