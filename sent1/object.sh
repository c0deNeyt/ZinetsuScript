#!/bin/bash

# Define a class-like structure for Server
Server() {
	# initialize params
	data="$1"
	ip=$(echo "$data" | awk -F, '{print $3}' | tr -d '[:space:]')
	inum="$2"
    usrAdm="$3"

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
    update_csv_remarks() {
		# $@ contains all the param
		local z="$@"
		local file="resource/Linux_Rouge.csv"
		local data=$(awk -v lnum="$inum" 'NR == lnum  { print; exit }' $file)

		# Format the content
		local new_content=$(echo "$data" | awk -F',' -v ustat="$z" '{print $1\
		","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","ustat","}')

		# Escape special char
        local escaped_variable=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
	
		# write to csv file
		sed -i "${inum}s/.*/${escaped_variable}/" "resource/Linux_Rouge.csv"

		return $?
    }

    # Method to write in csv file 
    update_csv_hostname() {
		# $@ contains all the param
		local y="$@"
		local file="resource/Linux_Rouge.csv"
		local data=$(awk -v lnum="$inum" 'NR == lnum  { print; exit }' $file)

		# Format the content
		local new_content=$(echo "$data" | awk -F',' -v hname="$y" '{print $1\
		","$2","$3","$4","$5","$6","hname","$8","$9","$10","$11","$12","}')

		# Escape special char
        local ev_hostname=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
	
		# write to csv file
		sed -i "${inum}s/.*/${ev_hostname}/" "resource/Linux_Rouge.csv"

		return $?
    }

    # Method to write in csv file 
    update_csv_timestamp() {
		# $@ contains all the param
		local x="$@"
		local file="resource/Linux_Rouge.csv"
		local data=$(awk -v lnum="$inum" 'NR == lnum  { print; exit }' $file)

		# Format the content
		local new_content=$(echo "$data" | awk -F',' -v tstamp="$x" '{print $1\
		","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","tstamp}')

		# Escape special char
        local ev_timestamp=$(echo "$new_content" | sed 's/[][\.,/^$*+?(){}\\|]/\\&/g')
	
		# write to csv file
		sed -i "${inum}s/.*/${ev_timestamp}/" "resource/Linux_Rouge.csv"

		return $?
    }
	
    # Method to get the server hostname 
    get_hostname() {
		#condition to check if it is using port 22 or 222	 
		if [[ "$@" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$@" "$usrAdm@$ip" "hostname" 
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "hostname" 
		fi	

    }

    # Method to get to get the S1 installed timestamp 
    get_s1_timestamp() {
		#condition to check if it is using port 22 or 222	 
		if [[ "$@" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$@" "$usrAdm@$ip" "sudo bash -s" < installTimestamp.sh
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "sudo bash -s" < installTimestamp.sh
		fi	
    }

    # Method to get the server hostname 
    set_hostfile() {
		#condition to check if it is using port 22 or 222	 
		if [[ "$@" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$@" "$usrAdm@$ip" "bash -s" < hostfile.sh 
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "bash -s" < hostfile.sh 
		fi	
    }

    # Method to check if sentinelone is installed 
    is_sentinel() {
		sentinelone="/opt/sentinelone/bin/sentinelctl"
		#condition to check if it is using port 22 or 222	 
		if [[ "$@" -eq "222" ]];then
        	ssh -o BatchMode=yes -o ConnectTimeout=90 -p "$@" "$usrAdm@$ip" "sudo [ -e $sentinelone ]" &>/dev/null 
		else
        	ssh -o BatchMode=yes -o ConnectTimeout=90 "$usrAdm@$ip" "sudo [ -e $sentinelone ]" &>/dev/null 
		fi	
		return $?
    }

	# Method to get data from the server
	get_data() {
		if [[ "$@" -eq "222" ]];then

			# Get Hostname
			hstname=$(get_hostname "222")
			# Update Hostnae 
			update_csv_hostname	"$hstname"

			# Set sentinel hostfile
			set_hostfile "222" &>/dev/null

			# Check if sentinale is installed 
			if is_sentinel "222"; then
				# Method to update csv fields	
				update_csv_remarks "Sentinelone installed"
				timestamp=$(get_s1_timestamp "222")
				#echo "Timestamp: $timestamp"
				update_csv_timestamp"$timestamp"

			else
				update_csv_remarks "Sentinelone not installed"
			fi

		else
			# Get Hostname
			hstname=$(get_hostname)
			# Update Hostnae 
			update_csv_hostname	"$hstname"

			# Set sentinel hostfile
			set_hostfile &>/dev/null

			# Check if sentinale is installed 
			if is_sentinel; then
				# Method to update csv fields	
				update_csv_remarks "Sentinelone installed"
				timestamp=$(get_s1_timestamp)
				#echo "Timestamp: $timestamp"
				update_csv_timestamp "$timestamp"
			else
				update_csv_remarks "Sentinelone not installed"
			fi

		fi
	}
	
    # Method to check the server 
	check_server() {
        if is_pingable; then
	
			# Check if port 22 is open	
            if is_port_open 22; then
	
				# Check if admin exist 
                if user_exists; then
	
					# Begin gather data 
					get_data
				else
					update_csv_remarks "Admin $usrAdm not found"
				fi

			# Check if port 222 is open	
            elif is_port_open 222; then

				# Check if admin exist 
                if user_exists 222; then

					# Begin gather data 
					get_data "222"
				else
					update_csv_remarks "Admin $usrAdm not found"
				fi

			# Check if port 3389 is open	
            elif is_port_open 3389; then

				update_csv_remarks "Port 3389 (Windows)"	
			# No available port open
            else
				update_csv_remarks "No relevant ports are open"	
			fi
		else
			#echo "Can't ping"
			update_csv_remarks "Can't ping"
		fi
	}
}
