#!/bin/bash

ip_list=$(cat ./ip-ad.txt)
for ip in $ip_list
do
    sudo ufw reject from $ip to any
done
