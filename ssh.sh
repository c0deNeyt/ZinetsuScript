#!/usr/bin/sh

declare -A srvIP
#RANDOM 
srvIP["88.2"]="172.16.88.2" #BANCSDBSNG1P
srvIP["88.3"]="172.16.88.3" #BANCSDBSNG2P
srvIP["95.11"]="172.16.95.11" #PDSNROSSTC1D
srvIP["7.247"]="172.16.7.247" #FXINTEGBLOT02
srvIP["216.10"]="172.16.216.10" #PDSDTAACPOINT1D
srvIP["me"]="192.168.20.23" #PDSDTAACPOINT1D
srvIP["195.12"]="172.16.195.12" #PDSNROSSNG2P
#POC STORAGE
srvIP["86.20"]="172.16.86.20" #
#ITOP
srvIP["131.20"]="172.16.131.20" #PDSITOPSVR1D
#Redisharvester DR
srvIP["131.15"]="172.16.131.15" #mpredisharvesterd
#Redisharvester PROD
srvIP["2.123"]="172.16.2.123" #mpredisharvesterp
#DNS Server
srvIP["82.30"]="172.16.82.30" #ns01.pdshc.com.ph.local
# SSCP ISO Docker
srvIP["123.29"]="172.16.123.29" #PDSDOCKISO2P
srvIP["123.17"]="172.16.123.17" #PDSSCCPISODB1P
srvIP["123.18"]="172.16.123.18" #PDSSCCPISODB2P
#SSCP ISO Docker (DR)
srvIP["133.28"]="172.16.133.28" #
srvIP["133.17"]="172.16.133.17" #PDSSCCPISODB1D
srvIP["121.11"]="172.16.121.11" #PDSSITEAPPNG1P 
#BANCS PROD 
srvIP["9.4"]="172.16.9.4" #BANCSWEBNG1P
srvIP["9.5"]="172.16.9.5" #BANCSWEBNG2P
srvIP["9.165"]="172.16.9.165" #BANCSWEBTC1D
srvIP["86.4"]="172.16.86.4" #BANCSAPPNG1P
srvIP["96.2"]="172.16.96.2" #BANCSAPPTC1D
srvIP["86.2"]="172.16.86.2" #BANCSAPPNG1P
srvIP["87.11"]="172.16.87.11" #BANCSREPNG1P
srvIP["87.12"]="172.16.87.12" #BANCSREPNG2P
srvIP["87.4"]="172.16.87.4" #BANCSCARNG1P
srvIP["87.5"]="172.16.87.5" #BANCSCARNG2P
srvIP["7.211"]="172.16.7.211" #BANCSINTNG1P
srvIP["7.212"]="172.16.7.212" #BANCSINTNG2P
#MARKET PAGE
srvIP["2.71"]="172.16.2.71" #NMPDBNV2P
srvIP["2.122"]="172.16.2.122" #NMPDBNP1P 
srvIP["132.15"]="172.16.132.15" #NMPDBTC1D
#PDS PROXY
srvIP["89.2"]="172.16.89.2" #PDSDSSWEBPXY01P
srvIP["89.3"]="172.16.89.3" #PDSDSSWEBPXY02P
#PDS Clear
srvIP["7.231"]="172.16.7.231" #pdsclgwyweb1p
srvIP["7.232"]="172.16.7.232" #pdsclgwyweb2p
#PDS WEBSITE 
srvIP["122.22"]="172.16.122.22" #PDSWEBPRODDB2
srvIP["122.21"]="172.16.122.21" #PDSSITEDBNG1P
#PDS ITOP 
srvIP["121.20"]="172.16.121.20" #PDSITOPSVR1P
srvIP["132.12"]="172.16.132.12" #PDSSITEDBTC1D
#CAAC
srvIP["1.127"]="172.32.1.127" #aristotle (caac APP PROD)
srvIP["1.130"]="172.32.1.130" #pdscaacdbp (caac DB PROD)
srvIP["9.9"]="172.16.9.9" #tts-db-prod-backup1
srvIP["9.7"]="172.16.9.7" #donatello
srvIP["9.167"]="172.16.9.167" #vangogh (Web DR) 
srvIP["1.19"]="172.30.1.19" #sungogh(caac DB DR)
#API
srvIP["7.251"]="172.16.7.251" #pdsapipxybal2p
srvIP["9.69"]="172.16.9.69" #pdsapiwebapp2p
srvIP["9.68"]="172.16.9.68" #pdsapiwebapp1p
srvIP["15.4"]="172.16.15.4" #pdsapiwebapp1d
srvIP["14.115"]="172.16.14.115" #PDSDSSWEBPXY01D
srvIP["100.3"]="172.16.100.3" #pdsapidbsvr2p
#Gateway
srvIP["108.20"]="172.16.108.20" #pdsclgwyweb1d
srvIP["105.10"]="172.16.105.10" #pdsclgwyapp1p
srvIP["105.11"]="172.16.105.11" #pdsclgwyapp2p
srvIP["107.10"]="172.16.107.10" #pdsclgwyapp1d
#New Market Page
srvIP["108.25"]="172.16.108.25" #pdsfxbnmptc01d
#TIS
srvIP["106.10"]="172.16.106.10"
srvIP["7.214"]="172.16.7.214" #TRADEINTNG2P
srvIP["7.215"]="172.16.7.215" #TRADEINTNG1P
#SIS
srvIP["106.7"]="172.16.106.7"
#SBL
srvIP["7.3"]="172.16.7.3" #pdsngsblprd01p
#DR Server
srvIP["97.2"]="172.16.97.2" #BANCSCARTC1D
srvIP["98.13"]="172.16.98.13" #pdsbancsv6db1d
srvIP["86.3"]="172.16.86.3" #BANCSAPPNG2P
srvIP["97.3"]="172.16.97.3" #BANCSREPVT01D
srvIP["186.10"]="172.16.186.10" #PDSDTAACPOINT01
#TEST Sever
srvIP["82.204"]="172.16.82.204" # Nmap server 
srvIP["167.15"]="192.168.167.15" # BANCSHAMNG1P
srvIP["168.99"]="192.168.168.99" # Inactive
srvIP["168.94"]="192.168.168.94" #PeejayTestServer
srvIP["168.166"]="192.168.168.166" #station1
srvIP["cloud"]="172.104.184.163" #personal Cloud
srvIP["168.181"]="192.168.168.181" #pdsclgwyappmwt
srvIP["168.182"]="192.168.168.182" #pdsclgwydbmwt
srvIP["168.180"]="192.168.168.180" #pdsclgwyweb1mwt
srvIP["168.247"]="192.168.168.247" #FXINTEGBLOT02
srvIP["168.172"]="192.168.168.172" #apimwt.pds.com.ph
srvIP["168.175"]="192.168.168.175" #pdsapigateway2
srvIP["168.177"]="192.168.168.177" #pdsclgwyapp1t
srvIP["168.116"]="192.168.168.116" #pdsfxbnmpws01
srvIP["168.11"]="192.168.168.11" #pdsbancsv6dbuat
srvIP["168.41"]="192.168.168.41" #PDSWEBAPPSTST01
srvIP["168.92"]="192.168.168.92" #ForwardBods
srvIP["168.108"]="192.168.168.108" #accstestenv
srvIP["168.93"]="192.168.168.93" #mpredisharvesterfxtest
srvIP["168.40"]="192.168.168.40" #PDSSITEAPPNG1T
srvIP["168.115"]="192.168.168.115" #
srvIP["168.21"]="192.168.168.21" #pdsfrwdbonddbp
srvIP["168.20"]="192.168.168.20" #pdsfrwdbondp
srvIP["168.31"]="192.168.168.31" #mwtpdswebapps
srvIP["168.3"]="192.168.168.3" #BANCSDBSNG1U
srvIP["168.105"]="192.168.168.105" #pdsesiprept
#TEST Marketpage
srvIP["168.133"]="192.168.168.133" #nmpdbprdtest
srvIP["168.30"]="192.168.168.30" #mrktpgedb1mwt
#TEST PDS Website
srvIP["168.32"]="192.168.168.32" #pdssitedbng1test
srvIP["168.42"]="192.168.168.42" #PDSWEBDBNGTST01
#TEST 19c 
srvIP["168.11"]="192.168.168.11" #pdsbancsv6dbuat
#TEST PDSClear 
srvIP["168.179"]="192.168.168.179" #pdsclgwydb1t
srvIP["168.153"]="192.168.168.153" #PDSITOPSVR1T
#TEST Syscon 
srvIP["168.2"]="192.168.168.2" #BANCSWACNG1U
srvIP["168.97"]="192.168.168.97" #bcpfiles_test
#TEST SIS
srvIP["168.4"]="192.168.168.4" #BANCSINTNG1U
#TEST CAAC 
srvIP["168.154"]="192.168.168.154" #caacws
srvIP["168.162"]="192.168.168.162" #PDSSCCPISODB1T
srvIP["168.161"]="192.168.168.161" #caacdb.local
srvIP["168.159"]="192.168.168.159" #caacws 
#TEST EMSC 
srvIP["168.125"]="192.168.168.125" #pdsemscmwt
#TEST TIS 
srvIP["168.6"]="192.168.168.6" #PDSWEBTIBTST01
