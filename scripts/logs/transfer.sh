#!/bin/bash

sleep 40

LOCALPATH=/var/log/dnsrout
# REMOTEUSER=
# REMOTEPATH=
# REMOTEIP=
# REMOTEPORT=

# Define files to transfer
FILES=("../auth.log" "master.log" "usrpwd.log" "geoiplocation.log" "geoiploc.json" "geoiploc.kml" "firewall.sh" "ip-ad.txt" "passwordpolicy.txt")

# Function to transfer a file to remote server
function transfer_file() {
    local file="$1"
    scp -o StrictHostKeyChecking=no "$LOCALPATH/$file" "$REMOTEUSER@$REMOTEIP:$REMOTEPATH" -P $REMOTEPORT
}

# Loop through files and transfer them in the background
for file in "${FILES[@]}"; do
    transfer_file "$file" &  # Run the transfer in the background
done

# Wait for all background processes to finish
wait
