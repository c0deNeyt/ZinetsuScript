#!/bin/bash

: ' 
TO DO:
[done] Validate if parameter if provided 
[done]	validate the file path 
'
# Check if a parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file-path>"
  exit 1
fi

# Get the file path from the first argument
dir_path="$1" 

# Check if the path exists and is a directory
if [ -d "$dir_path" ]; then
	echo "The path '$dir_path' is a valid directory."
	find $1 -type f -printf '%T@ %p\n' | sort -n | tail -n 1 | awk '{ cmd = "date -d @" $1 " +\"%d %B %Y %T\""; cmd | getline formatted_date; close(cmd); print formatted_date, $2 }'
else
	echo "The path '$dir_path' is not a valid directory."
fi

