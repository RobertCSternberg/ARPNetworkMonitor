#!/bin/sh
echo "<html><head><title>Arp Scan Results</title></head><body><h1>Arp Scan Results</h1>"
echo "<p>Last updated: $(date '+%d.%B %Y %H:%M:%S %Z')</p>"
echo "<pre>"

BASECOMMAND="arp-scan"
if [ "$1" = "--parsable" ]; then
  BASECOMMAND="arp-scan -x -D -F ip:\${IP};mac:\${mac};rtt:\${rtt};vendor:\${vendor}"
  shift
fi

while [ "$1" != "" ]
do
  COMMAND="$BASECOMMAND $1"
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