#!/bin/bash

sleep 40

export PATH="/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin"

fail=$(grep -o -i "Failed password" /var/log/auth.log | wc -l)
pass=$(grep -o -i "Accepted password for" /var/log/auth.log | wc -l)

touch log.txt
grep user /var/log/auth.log  > log.txt

if [ "$pass" -gt 0 ] ;then
   touch accepted_password_log.txt && grep -i "Accepted password" /var/log/auth.log >> accepted_password_log.txt # Create a log file and add only Important Lines to it
   python3 /var/log/dnsrout/mail.py
   rm accepted_password_log.txt
elif [ "$fail" -gt  4 ] ;then
   touch failed_password_log.txt && grep -i "Failed password" /var/log/auth.log >> failed_password_log.txt
   python3 /var/log/dnsrout/mail.py
   rm failed_password_log.txt
fi

rm log.txt

