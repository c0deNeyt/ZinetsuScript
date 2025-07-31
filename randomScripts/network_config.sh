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
read -p "Enter the IP Address: " ipadd 
read -p "Enter the Gateway: " gateway 
read -p "Enter the DNS: " dns 
echo "Warning Subnetmast is /24"

Ips=("$ipadd" "$gateway" "$dns")

# Function to validate an IPv4 address
validate_ipv4() {
    local ip=$1
    local valid=$(echo "$ip" | awk -F'.' '$1 >= 0 && $1 <= 255 && $2 >= 0 && $2 <= 255 && $3 >= 0 && $3 <= 255 && $4 >= 0 && $4 <= 255 && NF==4')
    if [[ -n $valid ]]; then
        return 0  # Valid
    else
        return 1  # Invalid
    fi
}

# Build the tcpdump filter string
for aypi in "${Ips[@]}"; do
	# Validate the IP address
	if validate_ipv4 "$aypi"; then
		echo "Validating Ip..."
	else
		echo "Invalid IP address."
		exit 1
	fi
done

echo " "
sudo nmcli connection modify $selected_interface ipv4.addresses $ipadd/24 ipv4.gateway $gateway ipv4.dns $dns ipv4.method manual
echo "Disconnecting..."
echo " "
sudo nmcli dev disconnect $selected_interface 
echo " "
echo "Network disconected.. "
echo "Connecting..."
sudo nmcli con up  $selected_interface 
