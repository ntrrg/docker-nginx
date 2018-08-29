FROM nginx:alpine
COPY common /etc/nginx
COPY rproxy/nginx /etc/nginx
EXPOSE 80 443
