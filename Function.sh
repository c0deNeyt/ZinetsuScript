#!/usr/bin/sh

function test(){
	echo "Hi! I'm from Function.sh file"
}
function trans(){
	read "test" src
	echo $src
	#scp -T /home/zinetsu/Script/* christian.arana@172.31.11.109:'/D:/chan/Linux'
}
