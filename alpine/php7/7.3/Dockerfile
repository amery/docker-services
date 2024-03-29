# vim: set ft=dockerfile ts=4 sw=4 et:
FROM amery/docker-alpine-core:3.12
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
ENV COMPOSER_PREFERRED 2
RUN wget -qO /tmp/composer-setup.php https://getcomposer.org/installer && \
    php /tmp/composer-setup.php --1 --install-dir=/usr/bin --filename=composer1 && \
    php /tmp/composer-setup.php --2 --install-dir=/usr/bin --filename=composer2 && \
    rm /tmp/composer-setup.php

COPY 00-prepare-php7.sh /etc/entrypoint.d/

# listen all interfaces
RUN sed -i -e 's|^listen =.*|listen = 9000|' /etc/php7/php-fpm.d/www.conf

# add php-fpm to supervisord
COPY supervisord.conf /etc/supervisor.d/php-fpm.conf
