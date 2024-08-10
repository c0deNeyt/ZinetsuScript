#!/usr/bin/sh

######################
# Get interface      #
######################

# Display the list of interfaces with numbers
echo "Available network interfaces:"
sudo tcpdump -D | awk '{print $1}'

#declare variable
interfaces=$(sudo tcpdump -D | awk '{print $1}')

# Check if tcpdump command succeeded
if [ $? -ne 0 ]; then
    echo "Failed to list network interfaces. Ensure tcpdump is installed and you have the necessary permissions."
    exit 1
fi

# Prompt the user to select an interface
read -p "Enter the number of the interface you want to use: " iface_number

# Validate the user input
if ! [[ $iface_number =~ ^[0-9]+$ ]] || [ $iface_number -lt 0 ] || [ $iface_number -ge $(echo "$interfaces" | wc -l) ]; then
    echo "Invalid selection. Please enter a valid number corresponding to the interface."
    exit 1
fi

# Extract the selected interface name using awk
selected_interface=$(echo "$interfaces" | awk -v num=$((iface_number)) -F'.' 'NR==num {print $2}')

######################
# Get hosts          #
######################

# Prompt the user to enter the host IPs or hostnames
read -p "Enter the host IPs or hostnames to capture traffic for (separate by spaces): " -a hosts

# Function to validate an IPv4 address
validate_ipv4() {
    local ip=$1
    local valid=$(echo "$host" | awk -F'.' '$1 >= 0 && $1 <= 255 && $2 >= 0 && $2 <= 255 && $3 >= 0 && $3 <= 255 && $4 >= 0 && $4 <= 255 && NF==4')
    if [[ -n $valid ]]; then
        return 0  # Valid
    else
        return 1  # Invalid
    fi
}

# Build the tcpdump filter string
filter=""
for host in "${hosts[@]}"; do
	# Validate the IP address
	if validate_ipv4 "$host"; then
		if [ -z "$filter" ]; then
			filter="host $host"
		else
			filter="$filter or host $host"
		fi
	else
		echo "Invalid IP address."
		exit 1
	fi

done

######################
# File Formatting    #
######################

fname=$(date "+%F_%H%M%S")
path="/dbbackup_n1/$fname.pcap"

######################
# Command summary    #
######################

#command 
sudo tcpdump -i $selected_interface $fiter -s 0 -w $path &
#sudo tcpdump -i $selected_interface $fiter -s 0 -w ./fname.pcap &

######################
# Handle kill 		 #
######################
sleep 3
pid=$!

# Loop until the user confirms termination
while kill -0 $pid 2>/dev/null; do
    # Prompt user for confirmation
    read -p "Do you want to terminate process $pid? (yes/no): " confirm

    # Convert the user input to lowercase
    confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')

    # Check user's confirmation
    if [[ "$confirm" = "yes" || "$confirm" = "y" ]]; then
        echo "Terminating process $pid..."
        kill "$pid"
        echo "Process $pid has been terminated."
        break
    elif [[ "$confirm" = "no" || "$confirm" = "n" ]]; then
        echo "Termination of process $pid canceled."
        read -p "Do you want to try terminating process $pid again? (yes/no): " try_again
    else
        echo "Invalid input. Please enter 'yes' or 'no'."
    fi
done
	





