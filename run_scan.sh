#!/bin/sh
while true
do
  echo "<html><head><title>Arp Scan Results</title></head><body><h1>Arp Scan Results</h1><pre>" > /tmp/index.html
  arp-scan 192.168.1.0/24 >> /tmp/index.html 2>> /tmp/arp-scan-errors.log
  if [ $? -ne 0 ]; then
    echo "Arp-scan failed. See /tmp/arp-scan-errors.log for details." >> /tmp/index.html
  fi
  echo "</pre></body></html>" >> /tmp/index.html
  mv /tmp/index.html /usr/share/nginx/html/index.html
  cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index-copy.html
  sleep 60
done