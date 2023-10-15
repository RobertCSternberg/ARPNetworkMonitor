#!/bin/sh
while true
do
  echo "<html><head><title>Arp Scan Results</title></head><body><h1>Arp Scan Results</h1>" > /tmp/index.html
  echo "<p>Last updated: $(TZ='America/Chicago' date '+%B %d, %Y %I:%M:%S %p') Central Time US</p>" >> /tmp/index.html
  echo "<pre>" >> /tmp/index.html

  # For uptime monitoring uncomment the line and replace the URL with the one you want to call from your uptime push monitor of choice, like Uptime Kuma.  
  # /usr/bin/curl "https://google.com" > /dev/null 2>&1

  # Replace the arp-scan address with your network address and subnet mask.  Most commonly 192.168.1.0/24
  arp-scan 192.168.1.0/24 >> /tmp/index.html 2>> /tmp/arp-scan-errors.log
  if [ $? -ne 0 ]; then
    echo "Arp-scan failed. See /tmp/arp-scan-errors.log for details." >> /tmp/index.html
  fi
  echo "</pre></body></html>" >> /tmp/index.html
  mv /tmp/index.html /usr/share/nginx/html/index.html
  cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index-copy.html
  sleep 30
done
