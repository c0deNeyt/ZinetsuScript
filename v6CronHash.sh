#!/bin/bash

declare -A Servers 

Servers["carana"]="172.16.86.2 172.16.86.3" 
#Servers["chan"]="192.168.168.99 192.168.168.99" 

# Loop through each key in the associative array
for key in "${!Servers[@]}"; do
  # Split the value string into an array of values
  IFS=' ' read -r -a values <<< "${Servers[$key]}"
  
  # Loop through each value for the current key
  for value in "${values[@]}"; do
	./cronMgmnt.sh $key $value 
  done
done

