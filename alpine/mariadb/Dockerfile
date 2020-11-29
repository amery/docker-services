# vim: set ts=4 sw=4 et:
FROM amery/docker-alpine-core:latest
MAINTAINER Alejandro Mery <amery@linux.com>

# Install MariaDB
RUN apk upgrade -U \
    && apk --update add \
        mariadb \
    && rm -rf /var/cache/apk/*
