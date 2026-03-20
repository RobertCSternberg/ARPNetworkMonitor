FROM nginx:1.29.6-alpine
RUN apk update && apk add --no-cache arp-scan=1.10.0-r2
COPY scan.sh entry.sh /
RUN chmod +x /*.sh
COPY nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["/entry.sh"]
CMD ["192.168.1.0/24"]
