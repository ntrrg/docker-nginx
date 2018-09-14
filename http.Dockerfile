FROM nginx:1.15.3-alpine
COPY common /etc/nginx
COPY http/nginx /etc/nginx
EXPOSE 80
VOLUME /usr/share/nginx/html

