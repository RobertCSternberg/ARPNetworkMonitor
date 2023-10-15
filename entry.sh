#!/bin/sh

echo "Received following parameters for arp-scanning: $@"
echo Starting nginx
nginx
echo Starting arp-scan loop
while true
do
    ./scan.sh "$@" > /usr/share/nginx/html/index.html
    sleep 60
done