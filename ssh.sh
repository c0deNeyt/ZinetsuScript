#!/usr/bin/sh

declare -A srvIP
#RANDOM 
srvIP["89.2"]="172.16.89.2" #PDSDSSWEBPXY01P
srvIP["123.28"]="172.16.123.28" #PDSDOCKISO1P
srvIP["7.247"]="172.16.7.247" #FXINTEGBLOT02
#PDS Clear
srvIP["7.231"]="172.16.7.231" #pdsclgwyweb1p
srvIP["7.232"]="172.16.7.232" #pdsclgwyweb2p
#API
srvIP["7.251"]="172.16.7.251" #pdsapipxybal2p
#pdsfxbnmptc01d(New Market Page)
srvIP["108.25"]="172.16.108.25"
#TIS
srvIP["106.10"]="172.16.106.10"
#TEST Sever
srvIP["168.99"]="192.168.168.99"
srvIP["168.166"]="192.168.168.166" #station1

pdsapiwebapp2p
