#!/usr/bin/sh

alias pds="ssh -L localhsot:5910:markinck.inf.uk:5910"
alias rld="source ~/.bashrc"
alias usg="du -hac --time -d1"
# -n 1 refresh interval equals to 1 
alias idate="watch -n 1 date"

#Editing
#vim Bassh
alias vBf="vim $HOME/Script/Function.sh"
alias vBa="vim $HOME/Script/Alias.sh"
alias vBs="vim $HOME/Script/ssh.sh"
alias vBk="vim $HOME/.ssh/known_hosts"
alias vB="vim ~/.bashrc"
#vim 
alias vs="vim $HOME/Script/DR_Scripts/DR_Forward_Date.sh"
alias vV="vim $HOME/.vimrc"
alias vt="vim $HOME/Script/edit_Csv_File.sh"
alias vS="vim ~/Documents/SOD_EOD/SOD_EOD_System_Monitoring.csv"
alias vse="vim $HOME/Script/SOD.sh"

#Script Shortcut
#run DR Script
alias rdfd="$HOME/Script/DR_Scripts/DR_Forward_Date.sh"
alias rds="$HOME/Script/DR_Scripts/showDRStat.sh"

#ssh 
alias s99="go 168.99 chan"

#Change Direcory
alias gS="cd ~/Script; l ; pwd"
alias gSend="cd ~/trans/send; l ; pwd"
alias gGet="cd ~/trans/recieved; l ; pwd"

#Git
alias gl="git log --oneline"
alias gs="git status"

#This Alias should be at the end of the line
alias ls='(ls --color=always -lrthA | awk '\''BEGIN {print "\033[1;34mDirectories:\033[0m"} /^d/ && !/^\.\.?$/ {print; next} !/^d/ {files=files $0 "\n"} END {print "\033[1;34m\nFiles:\033[0m"; printf files}'\'')'
