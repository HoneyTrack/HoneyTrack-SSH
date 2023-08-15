#!/bin/bash

cd /var/log/dnsrout
LOGPATH=/var/log

touch master.txt
cat $LOGPATH/auth.log | grep -i "Accepted password" > accepted.txt
cat $LOGPATH/auth.log | grep -i "Failed password" | grep -v "invalid user" > failed.txt
cat $LOGPATH/auth.log | grep -i "Failed password for invalid user" > failed_user.txt

awk '{print $1" "$2 "\t\t" $3 "\t\t" $9 "\t\t" $6 " " $7 "\t\t" $11} END {print "\n"}' accepted.txt > master1.txt
awk '{print $1" "$2 "\t\t" $3 "\t\t" $9 "\t\t" $6 " " $7 "\t\t" $11} END {print "\n"}' failed.txt > master2.txt
awk '{print $1" "$2 "\t\t" $3 "\t\t" $11 "\t\t" $6 " " $7 "\t\t" $13} END {print "\n"}' failed_user.txt > master3.txt

cat /dev/null > master.txt

cat master1.txt | grep "\S" master1.txt >> master2.txt
cat master2.txt | awk NF master2.txt >> master3.txt
cat master3.txt | awk NF master3.txt >> master.txt

cat /dev/null > master.log
while read log2;
do
echo $log2 > fail.txt
echo  {'"Date"': '"'$(awk '{print $1" "$2}' fail.txt)'"', '"Time"':  '"'$(awk '{print substr($3,1,5)}' fail.txt)'"', '"Hour"':  '"'$(awk '{print substr($3,1,2)}' fail.txt)'"', '"IP_Address"':  '"'$(awk '{print $7}' fail.txt)'"', '"Username"':  '"'$(awk '{print $4}' fail.txt)'"', '"Status"':  '"'$(awk '{print $5" "$6}' fail.txt)'"'} >> master.log
done < master.txt
echo " " >> master.log

cat ./master.log | cut -d " " -f9 | tr -d '"',"," | sort | uniq > ip-ad.txt

rm failed.txt failed_user.txt master.txt master1.txt master2.txt master3.txt accepted.txt fail.txt
