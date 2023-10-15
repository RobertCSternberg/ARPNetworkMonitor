#!/bin/sh
echo "<html><head><title>Arp Scan Results</title></head><body><h1>Arp Scan Results</h1>"
echo "<p>Last updated: $(date '+%d.%B %Y %H:%M:%S %Z')</p>"
echo "<pre>"

while [ "$1" != "" ]
do
  COMMAND="arp-scan $1"
  if [ "$2" != "" ]; then
    COMMAND="$COMMAND -I $2"
    shift
  fi
  shift
  $COMMAND
  if [ $? -ne 0 ]; then
    echo "Arp-scan failed. See log for details."
  fi
done
echo "</pre></body></html>"