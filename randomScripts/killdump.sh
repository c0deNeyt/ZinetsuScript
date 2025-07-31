#!/usr/bin/sh

REMOTE_USER="chan"
REMOTE_HOST="192.168.168.99"
REMOTE_PATH="~/capture.pcap"
INTERFACE="any"

# Function to clean up and ensure proper file closing
cleanup() {
    echo "Terminating tcpdump..."
    pkill -f "tcpdump -i $INTERFACE -w -"
    ssh "$REMOTE_USER@$REMOTE_HOST" 'sync'
    echo "Capture file should be properly closed on remote server."
}

# Trap signals and call cleanup function
#trap cleanup SIGINT SIGTERM

# Run tcpdump and write to remote server
sudo tcpdump -i "$INTERFACE" -w - | ssh "$REMOTE_USER@$REMOTE_HOST" 'cat > '"$REMOTE_PATH" &

sleep 5

cleanup

