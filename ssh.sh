#!/usr/bin/sh

declare -A srvIP
#RANDOM 
srvIP["88.2"]="172.16.88.2" #BANCSDBSNG1P
srvIP["88.3"]="172.16.88.3" #BANCSDBSNG2P
srvIP["95.11"]="172.16.95.11" #PDSNROSSTC1D
srvIP["89.2"]="172.16.89.2" #PDSDSSWEBPXY01P
srvIP["123.28"]="172.16.123.28" #PDSDOCKISO1P
srvIP["7.247"]="172.16.7.247" #FXINTEGBLOT02
srvIP["123.29"]="172.16.123.29" #PDSDOCKISO2P
srvIP["216.10"]="172.16.216.10" #PDSDTAACPOINT1D
srvIP["me"]="192.168.20.23" #PDSDTAACPOINT1D
#DNS Server
srvIP["82.30"]="172.16.82.30" #ns01.pdshc.com.ph.local
#BANCS PROD 
srvIP["96.2"]="172.16.96.2" #BANCSAPPTC1D
srvIP["86.2"]="172.16.86.2" #BANCSAPPNG1P
srvIP["87.11"]="172.16.87.11" #BANCSREPNG1P
srvIP["87.4"]="172.16.87.4" #BANCSCARNG1P
srvIP["132.15"]="172.16.132.15" #NMPDBTC1D
srvIP["7.211"]="172.16.7.211" #BANCSINTNG1P
#PDS Clear
srvIP["7.231"]="172.16.7.231" #pdsclgwyweb1p
srvIP["7.232"]="172.16.7.232" #pdsclgwyweb2p
#CAAC
srvIP["1.127"]="172.32.1.127" #aristotle
#API
srvIP["7.251"]="172.16.7.251" #pdsapipxybal2p
srvIP["9.69"]="172.16.9.69" #pdsapiwebapp2p
srvIP["15.4"]="172.16.15.4" #pdsapiwebapp1d
#Gateway
srvIP["108.20"]="172.16.108.20" #pdsclgwyweb1d
srvIP["105.10"]="172.16.105.10" #
srvIP["105.11"]="172.16.105.11" #
srvIP["107.10"]="172.16.107.10" #pdsclgwyapp1d
#New Market Page
srvIP["108.25"]="172.16.108.25" #pdsfxbnmptc01d
#TIS
srvIP["106.10"]="172.16.106.10"
#SIS
srvIP["106.7"]="172.16.106.7"
#DR Server
srvIP["97.2"]="172.16.97.2" #BANCSCARTC1D
srvIP["98.13"]="172.16.98.13" #pdsbancsv6db1d
srvIP["86.3"]="172.16.86.3" #BANCSAPPNG2P
srvIP["97.3"]="172.16.97.3" #BANCSREPVT01D
#TEST Sever
srvIP["168.99"]="192.168.168.99"
srvIP["168.94"]="192.168.168.94" #PeejayTestServer
srvIP["168.2"]="192.168.168.2" #BANCSWACNG1U
srvIP["168.166"]="192.168.168.166" #station1
srvIP["cloud"]="172.104.184.163" #personal Cloud
srvIP["168.181"]="192.168.168.181" #pdsclgwyappmwt
srvIP["168.182"]="192.168.168.182" #pdsclgwydbmwt
srvIP["168.180"]="192.168.168.180" #pdsclgwyweb1mwt
srvIP["168.247"]="192.168.168.247" #FXINTEGBLOT02
srvIP["168.172"]="192.168.168.172" #apimwt.pds.com.ph
srvIP["168.175"]="192.168.168.175" #pdsapigateway2
srvIP["168.177"]="192.168.168.177" #pdsclgwyapp1t
srvIP["168.179"]="192.168.168.179" #pdsclgwydb1t
srvIP["168.116"]="192.168.168.116" #pdsfxbnmpws01
srvIP["168.11"]="192.168.168.11" #pdsbancsv6dbuat
