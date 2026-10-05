#!/usr/bin/env bash

# Check if the server source of config is available
serverSource="172.16.7.116"
nc -zv ${serverSource} 22 &> /dev/null

if [ $? -ne 0 ] ; then 
	echo "line ${LINENO}: Config is not available!"
fi

# Checking paramerter if it is valid ip address
ip="$1"

# Check if it valid numbers not alpah numeric etc.
if ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
	    echo "line ${LINENO} ERROR: '$ip' is not a valid IP address."
	        exit 1
fi

#Chck if the each octed is within a rance of 255
IFS='.' read -r o1 o2 o3 o4 <<< "$ip"

if (( o1 > 255 || o2 > 255 || o3 > 255 || o4 > 255 )); then
	    echo "line ${LINENO} ERROR: '$ip' is not a valid IP address."
	        exit 1
fi

# Store config from the srouce server that is already configured to pull
# update from localserver repository
repo_output=$(ssh "$serverSource" 'cat /etc/yum.repos.d/local.repo' 2>&1)
# Preserve exit code
rc=$?

# Check if the command is successfull
if (( rc != 0 )); then
	printf 'line ${LINENO} ERROR: Unable to retrieve repo configuration from %s\n' "$serverSource"
	printf '%s\n' "$repo_output"
	exit "$rc"
fi

printf '%s\n' "$repo_output"

ssh "$ip" "bash -s" << 'EOF'
echo $HOME

EOF

# Backup the existing .repo files
: '
[]
[Done] check if the source server is reachable 
[Done] get local repo config
[done] Check if the ip address of tartget server is valid
[] Archive existing config to the /etc/yum.repos.d/*
[]trans the local config to the Target Server
'
