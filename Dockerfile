FROM nginx:alpine
RUN apk update && apk add --no-cache arp-scan
COPY scan.sh entry.sh /
RUN chmod +x /*.sh
COPY nginx.conf /etc/nginx/nginx.conf
ENTRYPOINT ["/entry.sh"]
CMD ["192.168.1.0/24"]
