#!/usr/bin/sh

#Location to find 
if [[ -z "$1" ]]; then
	echo " "  
	echo "ERROR: File path not specified!"
	echo "Sample Command: "./dr.sh ~/""
	echo " "  
	exit 1
fi

#Patter to find
read -e -p "Find: " changeThis
#Pattern to change
#read -e -p "Replace: " changeTo

#look for the relateed diretories
# Commands:
# grep -> filter/find something
# awk -> to select a row/columns 
# uniq -> filter out duplicate results
# Params:
# -rI -> recursive and don't search for binary file e.g ".swp"
# -F':' -> set ':' as delimeter
# '{print $1}' -> first column(defult delimiter is space) in a row(line)
echo "Searching for Files..."
sudo grep -rI --exclude=".bash_history" $changeThis $1 | awk -F':' '{print $1}' | uniq > searchDirectory.txt
#sudo grep -rI --exclude=".bash_history" "8.8.8.8" /etc | awk -F':' '{print $1}' | uniq > searchDirectory.txt
#Function to edit all the results from the serarchDirectory.txt
function iditFile(){
	varFile="searchDirectory.txt"
	varLines=$(cat $varFile)
	#loop to each list of directories
	for File in $varLines
	do
		# sed -i 's/[change this]/[change to]/ filePath
		sed -i "s/$changeThis/$changeTo/" $File	
	done
}
#echo $(iditFile)
echo "Affected Files:"
cat ./searchDirectory.txt
#rm ./searchDirectory.txt
