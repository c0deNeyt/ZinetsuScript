#!/usr/bin/sh

#Update Manual 
function updateMan(){
	# Directory to gzip files in
	TARGET_DIR="/usr/local/man/man1/"
	sudo cp ~/Script/manual/*.1 /usr/local/man/man1/
	#remove all existing gzip file
	sudo rm /usr/local/man/man1/*.gz

	# Check if the directory exists
	if [ -d "$TARGET_DIR" ]; then
	  # Loop through all files in the directory
	  for file in "$TARGET_DIR"*; do
		# Check if it's a file (not a directory)
		if [ -f "$file" ]; then
		  # Gzip the file
		  sudo gzip -f "$file"
		fi
	  done
	  echo "All files in $TARGET_DIR have been gzipped."
	else
	  echo "Directory $TARGET_DIR does not exist."
	fi
	sudo mandb -q 
	echo "Manual is now updated...!"
}

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
		echo "======================================================="
 		echo "URL: www.google.com" 
 		echo "HTTP CODE:" "$(curl -SksIXGET https://www.google.com | awk 'NR==1')"
 		echo " " 
 		echo "URL: www.facebook.com" 
 		echo "HTTP CODE:" "$(curl -SksIXGET https://www.facebook.com | awk 'NR==1')"
		echo "======================================================="
	fi
}

#SCP Transfer to Windows volume
function trans(){
	#windows machine workstation local path
	des="neyt@192.168.20.23:/D:/chan/Linux/Script"
	src0="neyt@192.168.20.23:/D:/chan/Linux/Send/*"
	des1="neyt@192.168.20.23:/D:/chan/Linux/Recieved"
	src1="neyt@192.168.20.23:/D:/chan/Linux/SOD_EOD/*"
	src2="neyt@192.168.20.23:/D:/chan/Linux/SOD_EOD"
	if [[ $1 = "sh" ]]
	then
		#read  -p "Source: " src
		scp -r -T $HOME/Script/* $des 
	elif [[ $1 = "get" ]]
	then
		#read  -p "Source: " src
		echo "Importing Files..."
		scp -r -T $src0 $HOME/trans/recieved/
	elif [[ $1 = "send" ]]
	then
		#read  -p "Source: " src
		echo "Exporting Files..."
		scp -r -T $HOME/trans/send/* $des1
	elif [[ $1 = "sm" ]]
	then
		scp -r -T $src1 $HOME/Documents/SOD_EOD/
	elif [[ $1 = "smu" ]]
	then
		scp -r -T $HOME/Documents/SOD_EOD/* $src2 
	fi	
}
#Find files
function fnd(){
	read  -p "In what directory? " src
	read  -p "What file? " file
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
#this function if for hopping into a different server
function go(){
	for key in  ${!srvIP[@]}
	do 
		if [[ $1 = "win" ]]
		then	
			ssh neyt@192.168.20.23
			break
	 	elif [[ -n $2 ]] && [[ -n $3 ]] && [[ $1 = $key ]] 
		then
			ssh -p$3 $2@${srvIP[$key]}
			break
		elif [[ -n $2 ]] && [[ $1 = $key ]] 
		then
			ssh $2@${srvIP[$key]}
			break
		elif [[ $1 = $key ]]
		then
			ssh carana@${srvIP[$key]}
			break
		fi
	done
}

#Check function to check internet
function chk(){
	if [[ -z $1 ]] 
	then
		echo "$0 LINE: $LINENO --> incomplete parameter!"	
		echo "eg. chk net [port] [ip]"	
		echo "chk net 22 192.168.168.2"	
	elif [[ -n $2 ]] && [[ -n $3 ]] && [[ $1 = "net" ]]
	then
		ssh -o BatchMode=yes -o ConnectTimeout=15 -p $2 carana@$3 bash << 'EOF'
			echo "Hostname: $(hostname)"
			curl -ko /dev/null -sw "Http Status Code: %{http_code}\n" https://access.redhat.com
EOF
	elif [[ $1 = "net" ]]
	then
		echo "HTTP Status Code: $(curl -ko /dev/null -sw "%{http_code}\n" https://access.redhat.com)"
	else
		echo " "
		echo "$0 LINE: $LINENO --> incomplete parameter!"	
		echo "eg. chk net [port] [ip]"	
		echo "chk net 22 192.168.168.2"	
		echo " "
	fi
}

chkcon(){
	for key in  ${!srvip[@]}
	do 
		ping -c4 ${srvip[$key]} 
	done
}
#show commands 
function show(){
	if [[ $1 = "interface" ]]
	then
		netstat -i		
	elif [[ $1 = "process" ]]
	then
		ps axjf	
	elif [[ $1 = "2" ]]
	then
		ssh carana@172.16.88.9
	else
		echo " "
		echo "Second Paramerter is missing!"
		echo " "
	fi
}
