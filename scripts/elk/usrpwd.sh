#!/bin/bash

cd /var/log/dnsrout
LOGPATH=/var/log

grep -i "Login attempt" $LOGPATH/auth.log >> userpass.txt

cat /dev/null > usrpwd.log
while read log;
do
echo $log > userpa.txt
echo {'"username"': '"'$(awk '{ print substr($10,2,length($10)-3) }' userpa.txt)'"', '"password"': '"'$(awk '{ print substr($12,2,length($12)-2) }' userpa.txt)'"'} >> usrpwd.log
done < userpass.txt

rm userpa.txt userpass.txt
