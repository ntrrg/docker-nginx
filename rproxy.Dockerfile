FROM nginx:1.15.3-alpine
COPY common /etc/nginx
COPY rproxy/nginx /etc/nginx
EXPOSE 80 443
