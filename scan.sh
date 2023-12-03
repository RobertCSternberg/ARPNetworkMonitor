#!/bin/sh

JSON=false
BASECOMMAND="arp-scan"
DATE="$(date '+%Y-%m-%dT%H:%M:%SZ%z')"

if [ "$1" = "--json" ]; then
  JSON=true
  BASECOMMAND="${BASECOMMAND} -x -D -F \{\"ip\":\"\${IP}\",\"mac\":\"\${mac}\",\"rtt\":\"\${rtt}\",\"vendor\":\"\${vendor}\"\}"
  shift
fi

if [ $JSON = 'true' ]; then
  echo -n "{\"date\":\"${DATE}\",\"results\":["
else
  echo "<html><head><title>Arp Scan Results</title></head><body><h1>Arp Scan Results</h1>"
  echo "<p>Last updated: ${DATE}</p>"
  echo "<pre>"
fi

INLOOP=false
while [ "$1" != "" ]
do
  if [ $INLOOP = 'true' ]; then
    echo -n ','
  else
    INLOOP=true
  fi

  COMMAND="$BASECOMMAND $1"
  if [ "$2" != "" ]; then
    COMMAND="$COMMAND -I $2"
    shift
  fi
  shift
  if [ $JSON  = 'true' ]; then
    $COMMAND | paste -d, -s -
  else
    $COMMAND
    echo
  fi
  if [ $? -ne 0 ]; then
    echo '"Arp-scan failed. See log for details."'
  fi
done
if [ $JSON  = 'true' ]; then
  echo ']}'
else
  echo "</pre></body></html>"
fi