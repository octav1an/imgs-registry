FROM nginx:1.27.3-alpine as BASE

COPY nginx.conf /etc/nginx/nginx.conf
COPY .htpasswd /etc/nginx/conf.d/.htpasswd

EXPOSE 80
EXPOSE 443
