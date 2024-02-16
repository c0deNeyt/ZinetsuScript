#!/usr/bin/sh

alias pds="ssh -L localhsot:5910:markinck.inf.uk:5910"
alias l="ls -alh"
alias rld="source ~/.bashrc"
alias usg="du -hac --time -d1"
# -n 1 refresh interval equals to 1 
alias idate="watch -n 1 date"

#Editing
#vim Bassh
alias vBf="vim $HOME/Script/Function.sh"
alias vBa="vim $HOME/Script/Alias.sh"
alias vBs="vim $HOME/Script/ssh.sh"
alias vB="vim ~/.bashrc"
#vim 
alias vs="vim $HOME/Script/DR_Forward_Date.sh"
alias vV="vim $HOME/.vimrc"
alias vt="vim $HOME/Script/edit_Csv_File.sh"
alias vS="vim ~/Documents/SOD_EOD/SOD_EOD_System_Monitoring.csv"
alias vse="vim $HOME/Script/SOD.sh"

#Script Shortcut
alias rs="/home/zinetsu/Script/DR_Forward_Date.sh"

#ssh 
alias s99="go 168.99 chan"

#Change Direcory
alias gS="cd ~/Script; l ; pwd"
alias gSend="cd ~/trans/send; l ; pwd"
alias gGet="cd ~/trans/recieved; l ; pwd"

#Git
alias gl="git log --oneline"
alias gs="git status"
