#!/usr/bin/expect

spawn  "~/Script/DR_Scripts/DR_Forward_Date.sh";
expect "Enter the TASK that you want to use: ";
send "1\r";
expect "Enter the server number(s): ";
send "1 2 3 4 5\r";
interact;'
