#!/usr/bin/sh

# Enable programmable completion features.
shopt -s progcomp

# Function to generate completions for read
_read_completion() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -o filenames -o bashdefault -- "${cur}") )
}

# Register the autocompletion function for the read command
complete -F _autocomplete read

#Setting the source
echo "Example: /path/to/source"
read -e -p "Source: " srcHost  

#Setting the destination
echo " "
read -e -p "Remote User: " remoteUser 
read -e -p "Remote Server IP: " remoteIP
echo " "
echo "Example: /path/to/remote/destination"
read -e -p "Remote Destination: " destHost

#consolidation of variables
echo " "
finalDes="$remoteUser@$remoteIP:$destHost"
echo "Destination: ${finalDes}"
echo " "

sudo rsync -au --progress --delete --ignore-existing $srcHost $finalDes

# -a = archive mode stands for -alpogtD
# -u = skip files that are newer on the receiver
# --progress = just show progress
# --delete =  delete extraneous files from dest dirs 
# --ignore-existing = ignore if no changes 
