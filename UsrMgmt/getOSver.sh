#!/bin/bash

# Set your SSH username
USER="carana"

# Output CSV file
OUTPUT="server_info.csv"

# CSV Header
echo "IP Address,Hostname,Detected IP,RHEL Version" > "$OUTPUT"

# Loop through IPs in the array
for IP in ${!srvIP[@]}
do
    echo "Processing $IP..."

    RESULT=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$USER@${srvIP[$IP]}" '
        HOSTNAME=$(hostname)
        DETECTED_IP=$(hostname -I | awk "{print \$1}")
        if [ -f /etc/redhat-release ]; then
            RHEL_VERSION=$(cat /etc/redhat-release)
        else
            RHEL_VERSION="Not RHEL or file missing"
        fi
        echo "$HOSTNAME,$DETECTED_IP,$RHEL_VERSION"
    ' 2>/dev/null)

    # Check if SSH was successful
    if [ $? -eq 0 ]; then
        echo "$IP,$RESULT" >> "$OUTPUT"
    else
        echo "$IP,Connection Failed,N/A,N/A" >> "$OUTPUT"
    fi
done

echo "✅ Finished. Output saved to $OUTPUT"

