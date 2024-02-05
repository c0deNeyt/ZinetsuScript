#!/usr/bin/sh

#get file structure on prod and put into temporary file
ssh chan@192.168.168.99 'find /bancsmireports -maxdepth 5 -type d ! -path "/bancsmireports/V602_PROD/OnlineReports/*"' > tmpDirStructure
#ssh chan@192.168.168.99 'find /bancsmireports1 -maxdepth 6 -type d -not -path "/bancsmireports1/EQ_PROD/EmailDaemon/EmailLogs/*"' > tmpDirStructure
#ssh chan@192.168.168.99 'find /bancsmireports2 -maxdepth 6 -type d' > tmpDirStructure
#ssh chan@192.168.168.99 'find /bancsmireports3 -maxdepth 6 -type d' > tmpDirStructure
cat ./tmpDirStructure
echo "Generating Structure... "
# Use create the directory structure 
cat ./tmpDirStructure | awk \
	'{ for (i = 1; i <= NF; i++) { 
		p1 = "sudo mkdir -p ";
		p2 = p1 $i;
		p3 = "ssh carana@172.16.96.2 ";
		cmd = p3  p2; 
		system(cmd); 
	    }
         }'
#remove temporary File 
#p3= "ssh chan@192.168.168.99 ";
#p3= "ssh carana@172.16.97.3 ";
rm ./tmpDirStructure 
: '
To Do:
[done] get all the list of directory
[done] limit the directory depth
[done] pass an ssh command on the destination server  

'

