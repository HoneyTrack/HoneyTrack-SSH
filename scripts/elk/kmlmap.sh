#!/bin/bash

cd /var/log/dnsrout
LOGPATH=/var/log

cat $LOGPATH/auth.log | grep -i "Accepted password" >> random1.txt
cat $LOGPATH/auth.log | grep -i "Failed password" | grep -v "invalid user" > random2.txt
cat $LOGPATH/auth.log | grep -i "Failed password for invalid user" > random3.txt

cat /dev/null > random.txt

cat random1.txt | grep "\S" random1.txt >> random2.txt
cat random2.txt | grep "\S" random2.txt >> random.txt
#cat random3.txt | grep "\S" random3.txt >> random.txt

awk '{ print $11 }' random.txt | sort | uniq > geoip1.txt
awk '{ print $13 }' random3.txt | sort | uniq > geoip2.txt

cat geoip1.txt | grep "\S" geoip1.txt >> geoip2.txt
cat geoip2.txt | awk NF geoip2.txt | sort | uniq > geoip.txt

cat /dev/null > geoiploc.kml

echo '<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
<Style id="transBluePoly"><LineStyle><width>1.5</width><color>501400E6</color></LineStyle></Style>' >> geoiploc.kml

while read log;
do

latitude=$(curl -s http://ipwhois.app/json/$log\?objects=latitude | awk '{ print substr($1,13, length($1)-13) }')
longitude=$(curl -s http://ipwhois.app/json/$log\?objects=longitude | awk '{print substr($1,14, length($1)-14) }')

if [[ -n "$longitude" ]]
then
echo "  <Placemark>
    <name>$log</name>
    <extrude>1</extrude>
    <tessellate>1</tessellate>
    <styleUrl>#transBluePoly</styleUrl>
    <LineString>
    <coordinates>$longitude,$latitude
72.8776559,19.0759837</coordinates>
    </LineString>
  </Placemark>" >> geoiploc.kml

fi

done < geoip.txt
echo '</Document>
</kml>' >> geoiploc.kml

rm random.txt random1.txt random2.txt random3.txt geoip1.txt geoip2.txt geoip.txt
