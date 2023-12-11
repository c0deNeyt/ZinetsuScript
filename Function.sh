#!/usr/bin/sh

#Get the UUID 
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
#SSH key Pairing
function sad(){
	ssh-copy-id carana@$1
}
#SentinelOne change hostsfile
function s1(){
	ssh carana@$1 'bash -s' < $HOME/Script/senT1.sh
}
function s2(){
	ssh root@$1 'bash -s' < $HOME/Script/senT1.sh
}
function go(){
	for key in  ${!srvIP[@]}
	do 
		if [[ -n $2 ]]
		then
			ssh chan@${srvIP[$key]}
			break
		elif [[ $1 = $key ]]
		then
			ssh carana@${srvIP[$key]}
		fi
	done
}
