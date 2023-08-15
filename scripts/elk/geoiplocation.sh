#!/bin/bash

cd /var/log/dnsrout
LOGPATH=/var/log

cat $LOGPATH/auth.log | grep -i "Accepted password" >> temp-geo-log.txt
cat $LOGPATH/auth.log | grep -i "Failed password" | grep -v "invalid user" >> temp-geo-log.txt
cat $LOGPATH/auth.log | grep -i "Failed password for invalid user" > temp-geo-log-2.txt

awk '{ print $11 }' temp-geo-log.txt | sort | uniq > geoip-1.txt
awk '{ print $13 }' temp-geo-log-2.txt | sort | uniq > geoip-2.txt

cat geoip-1.txt | grep "\S" geoip-1.txt >> geoip-2.txt
cat geoip-2.txt | awk NF geoip-2.txt | sort | uniq > geoip.txt

cat /dev/null > geoiploc.txt
while read log;
do
location=$(curl -s http://ipwhois.app/json/$log\?objects=ip,country,latitude,longitude)
echo -e "$location" >> geoiploc.txt
done < geoip.txt

grep -i "country" geoiploc.txt > geoiplocation.log
rm temp-geo-log.txt temp-geo-log-2.txt geoip-1.txt geoip-2.txt geoiploc.txt geoip.txt
