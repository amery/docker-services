# vim: set ft=dockerfile ts=4 sw=4 et:
FROM amery/docker-alpine-core:latest
MAINTAINER Alejandro Mery <amery@linux.com>

# Install PHP7
RUN apk --update upgrade -U && apk --no-cache add \
        php7 \
        php7-ctype \
        php7-curl \
        php7-dom \
        php7-fileinfo \
        php7-fpm \
        php7-gd \
        php7-iconv \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqli \
        php7-opcache \
        php7-openssl \
        php7-pcntl \
        php7-pdo \
        php7-pdo_mysql \
        php7-phar \
        php7-posix \
        php7-session \
        php7-tidy \
        php7-xml \
        php7-zip

# php-composer
RUN apk --no-cache add curl && \
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
        apk del curl

# listen all interfaces
RUN sed -i -e 's|^listen =.*|listen = 9000|' /etc/php7/php-fpm.d/www.conf

# append supervisord.conf
COPY supervisord.conf /etc/supervisord.conf~
RUN cat /etc/supervisord.conf~ >> /etc/supervisord.conf \
    && rm -f /etc/supervisord.conf~
