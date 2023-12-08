#!/usr/bin/sh

#test something
function test(){
	if [[ $1 = "net" ]]
	then
		curl -I https://www.google.com
	fi
}

#SCP Transfer to Windows volume
function trans(){
	if [[ $1 = "sh" ]]
	then
		#read -e -p "Source: " src

		#windows machine workstation local path
		des="christian.arana@172.31.11.109:/D:/chan/Linux/Script"
		scp -T $HOME/Script/* $des 
	fi
}

#Find files
function fnd(){
	read -e -p "In what directory? " src
	read -e -p "What file? " file
	find $src -type f -name $file
	
}
#scp -T /home/zinetsu/Script/* christian.arana@172.31.11.109:'/D:/chan/Linux/Script'

#SSH to Database Nodes
function node(){
	if [[ $1 = "1" ]]
	then
		ssh carana@172.16.88.8
	elif [[ $1 = "2" ]]
	then
		ssh carana@172.16.88.9
	fi
}
function sad(){
	ssh-copy-id carana@$1
}

