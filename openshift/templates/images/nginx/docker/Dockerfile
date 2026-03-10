FROM nginx:1.23.1-alpine

RUN set -x \
    && sed -i -e 's/^\(nginx:[^:]\):[0-9]*:[0-9]*:/\1:1001:0:/' /etc/passwd \
    && mkdir -p /var/cache/nginx /var/run \
    && chown nginx:0 /var/cache/nginx /var/run \
    && chmod 770 /var/cache/nginx /var/run \
    && rm /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh /docker-entrypoint.d/30-tune-worker-processes.sh

HEALTHCHECK --start-period=5s CMD pgrep nginx

VOLUME ["/var/www/html", "/var/log/nginx"]

#ng. mar 10, 2026. No longer need a default. Make sure the nginx.conf handles everything.
#COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443
