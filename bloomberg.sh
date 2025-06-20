#!/usr/bin/sh

#Loading Function
spinner(){
	# Run a command (e.g., scp) in the background
	pid=$!

	# Define a spinner animation
	spin[0]="-"
	spin[1]="\\"
	spin[2]="|"
	spin[3]="/"

	# Display the spinner while the process is running
	echo -n  -e "[Generating Result...] \n ${spin[0]}"
	while kill -0 $pid 2> /dev/null; do
		for i in "${spin[@]}"; do
			echo -ne "\b$i"
			sleep 0.1
		done
	done
}
checkBloomberg(){
	echo "CHECKING 160.43.94.20..."
	ssh carana@172.16.186.10 'sudo mtr -o "LDRS" -c10 --report 160.43.94.20' & spinner
	echo " "
	echo "CHECKING 160.43.94.24..."
	ssh carana@172.16.186.10 'sudo mtr -c25 --report 160.43.94.24' & spinner

}
#checkBloomberg 

checkWhile(){
	pid=$!
    for i in {1..5}; do
        echo "Number: $i"
		if kill -0 $pid 2>/dev/null; then 
			echo "TRUE"
			while kill -0 $pid 2>/dev/null; do
				echo "TRUE FROM WHILE"
			done
		else 
			echo "FALSE"
		fi
		echo $pid
    done

	#while kill -0 $pid 2> /dev/null; do
			#current_date
			#varTime=$(date +%R)
			#varGiven=$(date -d "13:40" +%R)
			#$if [[ $varTime == $varGiven ]] ; then
				#exit 1
				#echo $varTime
			#fi
	#done
	#echo "I ASUME Im' Done";
	#myFunction
}

#current_date=$(date +%d__%S)
echo $current_date
myFunction(){
	#sudo mtr --report 1.1.1.1 & spinner
	ssh carana@172.16.186.10 'date' > ~/Script/test.txt
	ssh carana@172.16.186.10 'sudo mtr -o "LDRS" -c10 --report 160.43.94.20' >> ~/Script/test.txt & spinner
	echo " "
}
myFunction 

: '
TODO:
[] check if the date chages
'
