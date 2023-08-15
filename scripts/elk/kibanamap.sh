#!/bin/bash

cd /var/log/dnsrout
LOGPATH=/var/log

grep -i "Accepted password" $LOGPATH/auth.log >> random.txt
grep -i "Failed password" $LOGPATH/auth.log >> random.txt

awk '{ print $11 }' random.txt | sort | uniq > geoip.txt
cat /dev/null > geoiploc.json

echo "{
    "type": "FeatureCollection",
    "features": [" >> geoiploc.json


while read log;
do
latitude=$(curl -s http://ipwhois.app/json/$log\?objects=latitude | awk '{print substr($1 ,13,10 )}')
longitude=$(curl -s http://ipwhois.app/json/$log\?objects=longitude | awk '{print substr($1 ,14,11 )}')

if [[ -n "$longitude" ]]
then
echo "        {
            "type": "Feature",
            "geometry": {
                "type": "Point",
                "coordinates": [$longitude, $latitude]
            }
        },

" >> geoiploc.json

fi

done < geoip.txt
echo "    ]
}" >> geoiploc.json

rm random.txt geoip.txt
