#!/usr/bin/sh

function uuid(){
        sudo blkid|grep /dev/|awk -F" " \
                '{str="";
                    for (i=1;i<=NF;i++)
                        if($i~/^\/dev/ || $i~/^UUID/ || $i~/^TYPE/)
				{str= str " " $i}
                        print str
                }' 
}
#test something
function test(){
	if [[ $1 = "net" ]]
	then
		curl -I https://www.google.com
	fi
}

#SCP Transfer to Windows volume
function trans(){
	#windows machine workstation local path
	#des="christian.arana@172.31.11.109:/D:/chan/Linux/Script"
	des="christian.arana@192.168.20.23:/D:/chan/Linux/Script"
	des0="christian.arana@192.168.20.23:/D:/chan/Linux/Send/*"
	des1="christian.arana@192.168.20.23:/D:/chan/Linux/Recieved"
	if [[ $1 = "sh" ]]
	then
		#read -e -p "Source: " src
		scp -r -T $HOME/Script/* $des 
	elif [[ $1 = "get" ]]
	then
		#read -e -p "Source: " src
		echo "Importing Files..."
		scp -r -T $des0 $HOME/trans/recieved/
	elif [[ $1 = "send" ]]
	then
		#read -e -p "Source: " src
		echo "Exporting Files..."
		scp -r -T $HOME/trans/send/* $des1
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
function go(){
	for key in  ${!srvIP[@]}
	do 
		echo $key
	done
#	if [[ $1 = "108.25" ]]
#	then
#		ssh carana@172.16.108.25
#	elif [[ $1 = "132.15" ]]
#	then
#		ssh carana@172.16.132.15
	#fi
}
