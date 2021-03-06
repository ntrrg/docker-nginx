FROM nginx:1.15.3-alpine
COPY common /etc/nginx
COPY http2/nginx /etc/nginx
EXPOSE 80 443
VOLUME /etc/nginx/ssl /usr/share/nginx/html

