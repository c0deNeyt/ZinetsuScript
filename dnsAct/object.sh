#!/bin/bash

# Define a class-like structure 
Server() {
	ip="$1"
	#ip="192.168.168.71"
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
		echo -e "[Checking dns @ ${@:1:1}...]"
		while kill -0 $pid 2> /dev/null; do
			for i in "${spin[@]}"; do
				echo -ne "\b$i" 
				sleep 0.1 
			done 
		done
		echo -ne "\rDone...!\n\n"
	}

    # Method to fetch DNS inside the server 
	fetch_dns() {
		port=$1
		SSH="ssh -o BatchMode=yes -o ConnectTimeout=15 -p ${port} ${admUser}@${ip} --"
		srv_hostname=$($SSH "hostname")

		# trace 
		if $SSH test -f /etc/resolv.conf; then
			###echo "Using /etc/resolv.conf:"
			dns_output=$($SSH "awk '/^nameserver/ {print \$2}' /etc/resolv.conf")
			config_file=$($SSH "cat /etc/resolv.conf")
		else
			###echo "Could not determine DNS configuration method on this system."
			write_to_csv "${ip},$srv_hostname,Either Blank or different config method" 
			exit 1
		fi

    	echo "$dns_output"
    	#echo "$config_file"
		# Check if both DNS IPs are present
		if echo "$dns_output" | grep -q '172.16.82.150' && echo "$dns_output" | grep -q '172.16.82.150'; then
			echo "Old DNS found"
			write_to_csv "${ip},$srv_hostname,Old DNS found" 
			change_dns "${port}"
			
		else
			echo "DNS not exist"
			write_to_csv "${ip},$srv_hostname,Old DNS not exist" 
		fi
	}

	#Method to change dns
	change_dns(){
		# SSH into the remote host and perform the DNS check and update
		port=$1
		ssh -o BatchMode=yes -o ConnectTimeout=15 -p ${port} ${admUser}@${ip} bash << 'EOF'
			RESOLV_CONF="/etc/resolv.conf"
			cat /etc/resolv.conf > ~/resolv.conf.bak04262025
			{
				echo "#carana 26April2025" 
				echo "#generated using bash script"
				echo "nameserver 172.18.145.13"
				echo "nameserver 172.18.145.14"
			} | sudo tee "$RESOLV_CONF" > /dev/null
			echo "DNS updated on remote host."
EOF

	}

	write_to_csv(){
		CSV_FILE="/media/sf_Linux/sandbox/dns_checklist.csv"
		HEADER="IP,Hostname,DSN_Status"
		# Check if file exists
		if [ -f "$CSV_FILE" ]; then
			# Read the first line to check if it matches the expected header
			first_line=$(head -n 1 "$CSV_FILE")

			if [ "$first_line" == "$HEADER" ]; then
				# Check if file has more than one line (i.e., data exists)
				line_count=$(wc -l < "$CSV_FILE")
				if [ "$line_count" -ge 1 ]; then
					#command to write in a csv file
					echo "$1" >> "$CSV_FILE"
				else
					echo "$1" >> "$CSV_FILE"
				fi
			else
				echo "$HEADER" > "$CSV_FILE"
			fi
		else
			echo "$HEADER" > "$CSV_FILE"
		fi
	}

	# delete user account 
	check_internal_DNS(){
		# Method that is used to validate if port 22 open
		if is_port_open "22"; then 
			#method instance
			fetch_dns "22"
		else
			#method instance
			fetch_dns "222" 
		fi

		return $?
	}

}
