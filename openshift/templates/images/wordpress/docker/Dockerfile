FROM wordpress:6.9.1-php8.2-fpm-alpine
# Install LDAP for Next Active Directory Integration Plugin.
RUN set -ex; \
        apk add --no-cache --virtual .build-deps \
        openldap-dev; \
        docker-php-ext-install ldap; \
        docker-php-ext-enable ldap;

COPY php.conf.ini /usr/local/etc/php/conf.d/php.ini
