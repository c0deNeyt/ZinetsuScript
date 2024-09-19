#!/usr/bin/sh

#Random Aliases
alias s99="go 168.99 chan"
alias pds="ssh -L localhsot:5910:markinck.inf.uk:5910"
alias rld="source ~/.bashrc"
alias usg="du -hac  --max-depth=1"
# -n 1 refresh interval equals to 1 
alias idate="watch -n 1 date"
alias mm="man main"

#Editing
#vim Bassh
alias vB="vim ~/.bashrc"
alias vBa="vim $HOME/Script/Alias.sh"
alias vBf="vim $HOME/Script/Function.sh"

#vim DR 
alias vdf="vim $HOME/Script/DR_Scripts/DR_Forward_Date.sh"

#vim manual 
alias vmm="vim $HOME/Script/manual/main.1"

#vim script 
alias vss="vim $HOME/Script/SOD.sh"
alias vse="vim $HOME/Script/edit_Csv_File.sh"

#vim .ssh 
alias vSk="vim $HOME/.ssh/known_hosts"
alias vSs="vim $HOME/Script/ssh.sh"

#vim file
alias vV="vim $HOME/.vimrc"
alias vs="vim ~/Script/SysMonitoring/sysMonitoring.sh"

#Script Shortcut
#run DR Script
alias rdfd="$HOME/Script/DR_Scripts/DR_Forward_Date.sh"
alias rds="$HOME/Script/DR_Scripts/showDRStat.sh"

#Change Direcory
alias gS="cd ~/Script; l ; pwd"
alias gSm="cd ~/Script/SysMonitoring; l ; pwd"
alias gSu="cd ~/Script/UsrMgmt; l ; pwd"
alias gSend="cd ~/trans/send; l ; pwd"
alias gGet="cd ~/trans/recieved; l ; pwd"

#Git
alias gl="git log --oneline"
alias gs="git status"

#This Alias should be at the end of the line
alias l='(ls --color=always -lrthA | awk '\''BEGIN {print "\033[1;34mDirectories:\033[0m"} /^d/ && !/^\.\.?$/ {print; next} !/^d/ {files=files $0 "\n"} END {print "\033[1;34m\nFiles:\033[0m"; printf files}'\'')'
