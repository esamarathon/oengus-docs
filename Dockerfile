# 1. build redoc

FROM node:lts AS redoc
WORKDIR /redoc

COPY template.hbs ./
RUN npx @redocly/cli build-docs https://oengus.io/api/v3/api-docs -t template.hbs
RUN ls -hal


# 2. serve html with nginx
FROM alpine:latest
WORKDIR /var/www/html

RUN apk update --no-cache && apk add --no-cache nginx

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN adduser -u 1500 -g 1500 -D -G 'www-data' www-data
COPY ./entrypoint.sh /usr/sbin/entrypoint
RUN chmod 555 /usr/sbin/entrypoint
RUN chown -R www-data:www-data /var/lib/nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY favicon.ico /var/www/html/favicon.ico
COPY --from=redoc /redoc/redoc-static.html /var/www/html/index.html

RUN ls -hal

RUN chown -R www-data:www-data /var/www

ENTRYPOINT ["/usr/sbin/entrypoint"]

# npx redoc-cli bundle https://oengus.io/api/v2/api-docs
