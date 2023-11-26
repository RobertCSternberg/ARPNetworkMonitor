#!/bin/sh

echo "Received following parameters for arp-scanning: $@"
echo Starting nginx
nginx
echo Starting arp-scan loop

TIME=60
if [ "$1" = "--time" ]; then
  TIME=$2
  shift
  shift
fi

while true
do
    TEMPFILE=$(mktemp -p /usr/share/nginx/html index.XXXXXX)
    ./scan.sh "$@" > $TEMPFILE
    chmod a+r $TEMPFILE
    mv $TEMPFILE /usr/share/nginx/html/index.html
    sleep $TIME
done