FROM nginx:alpine
RUN apk update && apk add --no-cache arp-scan
COPY run_scan.sh /run_scan.sh
RUN chmod +x /run_scan.sh
COPY nginx.conf /etc/nginx/nginx.conf
CMD /bin/sh -c "/run_scan.sh & nginx -g 'daemon off;'"