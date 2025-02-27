#!/bin/bash

#working directory
defaultDir="$HOME/Script/json"
#Json File
varData=$defaultDir/config.json
#CSV File
csvFile="$HOME/Script/json/output.csv"

#jq command is for handling json data 
countPolicies=$(jq -r '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules | keys | length' $varData)
#testVar=$(jq -r '.devices."device VTR-FW-PRIMARY".config.orgs' $varData)

#LOOP through all policies
for (( c = 0; c < ${countPolicies}; c++ )); do
	rules=$(jq -r --argjson b "$c" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules | keys | .[$b]' $varData)
	stat=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d]."rule-disable"' $varData)
	sz=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.source.zone."zone-list"' $varData)
	sip=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.source.address."address-list"' $varData)
	sgip=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.source.address."address-group-list"' $varData)
	dz=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.destination.zone."zone-list"' $varData)
	dip=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.destination.address."address-list"' $varData)
	dgip=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.destination.address."address-group-list"' $varData)
	uc=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match."url-category"."user-defined"' $varData)
	sl=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].match.services."services-list"' $varData)
	act=$(jq -r --arg d "$rules" '.devices."device VTR-FW-PRIMARY".config.orgs."org-services PhilippineDealingSystem".security."access-policies"."Default-Policy".rules[$d].set.action' $varData)

	echo "$rules,$stat,$sz,$sip,$sgip,$dz,$dip,$dgip,$uc,$sl,$act" >> $csvFile
	#echo "$rules,$stat,$sz,$sip,$sgip,$dz,$dip,$dgip,$uc,$sl,$act" 
done
