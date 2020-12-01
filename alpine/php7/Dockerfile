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
        php7-posix \
        php7-session \
        php7-tidy \
        php7-xml \
        php7-zip

# append supervisord.conf
COPY supervisord.conf /etc/supervisord.conf~
RUN cat /etc/supervisord.conf~ >> /etc/supervisord.conf \
    && rm -f /etc/supervisord.conf~
