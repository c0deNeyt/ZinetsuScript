#!/bin/bash

CONFIG_FILE="servers.json"

# Check for jq
if ! command -v jq &>/dev/null; then
    echo "Error: jq is not installed. Install it with: sudo apt install jq"
    exit 1
fi

# Function to run commands for a server
run_server_commands() {
    local name="$1"
    local host="$2"
    local user="$3"
    local port="$4"
    local cmds=("${!5}")

    echo "----- Running commands on $name ($user@$host:$port) -----"
    for cmd in "${cmds[@]}"; do
        echo "> $cmd"
        ssh -p "$port" "$user@$host" "$cmd"
        echo ""
    done
}

# Main logic to read JSON and run commands
parse_and_execute() {
    local servers_count
    servers_count=$(jq '.servers | length' "$CONFIG_FILE")

    for ((i=0; i<servers_count; i++)); do
        name=$(jq -r ".servers[$i].name" "$CONFIG_FILE")
        host=$(jq -r ".servers[$i].host" "$CONFIG_FILE")
        user=$(jq -r ".servers[$i].user" "$CONFIG_FILE")
        port=$(jq -r ".servers[$i].port" "$CONFIG_FILE")
        readarray -t cmds < <(jq -r ".servers[$i].commands[]" "$CONFIG_FILE")

        run_server_commands "$name" "$host" "$user" "$port" cmds[@]
    done
}

# Start execution
parse_and_execute

